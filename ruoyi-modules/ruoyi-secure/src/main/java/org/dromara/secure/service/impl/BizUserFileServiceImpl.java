package org.dromara.secure.service.impl;

import org.dromara.common.satoken.utils.LoginHelper;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.RequiredArgsConstructor;
import org.dromara.common.mybatis.core.page.PageQuery;
import org.dromara.common.mybatis.core.page.TableDataInfo;
import org.dromara.common.core.exception.ServiceException;
import org.dromara.common.core.utils.StringUtils;
import org.dromara.common.core.utils.file.FileUtils;
import org.dromara.common.json.utils.JsonUtils;
import org.dromara.common.oss.core.OssClient;
import org.dromara.common.oss.entity.UploadResult;
import org.dromara.common.oss.factory.OssFactory;
import org.dromara.secure.domain.BizUserFile;
import org.dromara.secure.mapper.BizUserFileMapper;
import org.dromara.secure.service.IBizUserFileService;
import org.dromara.secure.util.AesStreamUtil;
import org.dromara.system.domain.SysOss;
import org.dromara.system.domain.SysOssExt;
import org.dromara.system.domain.vo.SysOssVo;
import org.dromara.system.mapper.SysOssMapper;
import org.dromara.system.service.ISysOssService;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 用户个人文件记录 服务层实现
 *
 * @author ruoyi
 */
@RequiredArgsConstructor
@Service
public class BizUserFileServiceImpl extends ServiceImpl<BizUserFileMapper, BizUserFile> implements IBizUserFileService {

    private static final int PIPE_BUFFER_SIZE = 1024 * 1024;
    private static final ExecutorService PIPE_EXECUTOR = Executors.newCachedThreadPool(r -> {
        Thread t = new Thread(r, "secure-file-download");
        t.setDaemon(true);
        return t;
    });

    private final ISysOssService sysOssService;
    private final SysOssMapper sysOssMapper;

    @Override
    public TableDataInfo<BizUserFile> queryPageList(Long userId, PageQuery pageQuery) {
        LambdaQueryWrapper<BizUserFile> wrapper = new LambdaQueryWrapper<BizUserFile>()
            .eq(BizUserFile::getUserId, userId)
            .orderByDesc(BizUserFile::getCreateTime);
        Page<BizUserFile> page = page(pageQuery.build(), wrapper);
        return TableDataInfo.build(page);
    }

    @Override
    public BizUserFile uploadFile(MultipartFile file) throws IOException {
        if (ObjectUtil.isNull(file) || file.isEmpty()) {
            throw new ServiceException("上传文件不能为空");
        }

        Long userId = LoginHelper.getUserId();
        String originalFileName = file.getOriginalFilename();
        if (StringUtils.isBlank(originalFileName)) {
            originalFileName = "unknown";
        }
        String suffix = originalFileName.contains(".") ?
            StringUtils.substring(originalFileName, originalFileName.lastIndexOf("."), originalFileName.length()) : "";
        long originalFileSize = file.getSize();

        Path tempFile = null;
        try {
            tempFile = Files.createTempFile("secure_upload_", suffix);
            try (InputStream inputStream = file.getInputStream();
                 OutputStream outputStream = Files.newOutputStream(tempFile)) {
                AesStreamUtil.encrypt(inputStream, outputStream);
            }

            long encryptedSize = Files.size(tempFile);
            OssClient storage = OssFactory.instance();
            UploadResult uploadResult = storage.uploadSuffix(tempFile.toFile(), suffix);

            SysOss oss = new SysOss();
            oss.setUrl(uploadResult.getUrl());
            oss.setFileSuffix(suffix);
            oss.setFileName(uploadResult.getFilename());
            oss.setOriginalName(originalFileName);
            oss.setService(storage.getConfigKey());
            SysOssExt ext1 = new SysOssExt();
            ext1.setFileSize(encryptedSize);
            ext1.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            oss.setExt1(JsonUtils.toJsonString(ext1));
            sysOssMapper.insert(oss);

            BizUserFile bizUserFile = new BizUserFile();
            bizUserFile.setUserId(userId);
            bizUserFile.setOssId(oss.getOssId());
            bizUserFile.setFileName(originalFileName);
            bizUserFile.setFileSuffix(StringUtils.isNotBlank(suffix) && suffix.length() > 1 ? suffix.substring(1) : null);
            bizUserFile.setFileSize(originalFileSize);
            bizUserFile.setIsEncrypted("1");
            save(bizUserFile);

            return bizUserFile;
        } finally {
            if (tempFile != null && Files.exists(tempFile)) {
                FileUtils.del(tempFile.toFile());
            }
        }
    }

    @Override
    public void downloadFile(Long fileId, jakarta.servlet.http.HttpServletResponse response) throws IOException {
        BizUserFile bizUserFile = getById(fileId);
        if (ObjectUtil.isNull(bizUserFile)) {
            throw new ServiceException("文件不存在");
        }

        Long userId = LoginHelper.getUserId();
        if (!userId.equals(bizUserFile.getUserId())) {
            throw new ServiceException("无权限下载该文件");
        }

        SysOssVo sysOss = sysOssService.getById(bizUserFile.getOssId());
        if (ObjectUtil.isNull(sysOss)) {
            throw new ServiceException("OSS 文件记录不存在");
        }

        FileUtils.setAttachmentResponseHeader(response, bizUserFile.getFileName());
        response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE + "; charset=UTF-8");
        if (bizUserFile.getFileSize() != null && bizUserFile.getFileSize() > 0) {
            response.setContentLengthLong(bizUserFile.getFileSize());
        }

        OssClient storage = OssFactory.instance(sysOss.getService());
        try (PipedOutputStream pos = new PipedOutputStream();
             PipedInputStream pis = new PipedInputStream(pos, PIPE_BUFFER_SIZE)) {

            CompletableFuture<Void> decryptFuture = CompletableFuture.runAsync(() -> {
                try {
                    AesStreamUtil.decrypt(pis, response.getOutputStream());
                } catch (IOException e) {
                    throw new RuntimeException("解密失败: " + e.getMessage(), e);
                }
            }, PIPE_EXECUTOR);

            storage.download(sysOss.getFileName(), pos, null);
            pos.close();

            decryptFuture.join();
        } catch (Exception e) {
            if (e.getCause() instanceof IOException) {
                throw (IOException) e.getCause();
            }
            throw new IOException("文件下载失败: " + e.getMessage(), e);
        }
    }

    @Override
    public void downloadFileWithoutAuth(Long fileId, jakarta.servlet.http.HttpServletResponse response) throws IOException {
        BizUserFile bizUserFile = getById(fileId);
        if (ObjectUtil.isNull(bizUserFile)) {
            throw new ServiceException("文件不存在");
        }

        SysOssVo sysOss = sysOssService.getById(bizUserFile.getOssId());
        if (ObjectUtil.isNull(sysOss)) {
            throw new ServiceException("OSS 文件记录不存在");
        }

        FileUtils.setAttachmentResponseHeader(response, bizUserFile.getFileName());
        response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE + "; charset=UTF-8");
        if (bizUserFile.getFileSize() != null && bizUserFile.getFileSize() > 0) {
            response.setContentLengthLong(bizUserFile.getFileSize());
        }

        OssClient storage = OssFactory.instance(sysOss.getService());
        try (PipedOutputStream pos = new PipedOutputStream();
             PipedInputStream pis = new PipedInputStream(pos, PIPE_BUFFER_SIZE)) {

            CompletableFuture<Void> decryptFuture = CompletableFuture.runAsync(() -> {
                try {
                    AesStreamUtil.decrypt(pis, response.getOutputStream());
                } catch (IOException e) {
                    throw new RuntimeException("解密失败: " + e.getMessage(), e);
                }
            }, PIPE_EXECUTOR);

            storage.download(sysOss.getFileName(), pos, null);
            pos.close();

            decryptFuture.join();
        } catch (Exception e) {
            if (e.getCause() instanceof IOException) {
                throw (IOException) e.getCause();
            }
            throw new IOException("文件下载失败: " + e.getMessage(), e);
        }
    }
}
