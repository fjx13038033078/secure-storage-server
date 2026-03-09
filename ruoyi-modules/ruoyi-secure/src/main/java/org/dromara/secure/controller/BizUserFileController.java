package org.dromara.secure.controller;

import cn.dev33.satoken.stp.StpUtil;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.dromara.common.core.domain.R;
import org.dromara.common.log.annotation.Log;
import org.dromara.common.log.enums.BusinessType;
import org.dromara.common.mybatis.core.page.PageQuery;
import org.dromara.common.mybatis.core.page.TableDataInfo;
import org.dromara.common.web.core.BaseController;
import org.dromara.secure.annotation.FileAuditLog;
import org.dromara.secure.annotation.OperateType;
import org.dromara.secure.domain.BizUserFile;
import org.dromara.secure.service.IBizUserFileService;
import org.springframework.http.MediaType;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

/**
 * 用户个人文件 控制层
 *
 * @author ruoyi
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/secure/file")
public class BizUserFileController extends BaseController {

    private final IBizUserFileService bizUserFileService;

    /**
     * 查询当前用户的文件列表
     */
    @GetMapping("/list")
    public TableDataInfo<BizUserFile> list(PageQuery pageQuery) {
        Long userId = StpUtil.getLoginIdAsLong();
        return bizUserFileService.queryPageList(userId, pageQuery);
    }

    /**
     * 删除文件
     */
    @FileAuditLog(operateType = OperateType.DELETE)
    @Log(title = "删除文件", businessType = BusinessType.DELETE)
    @DeleteMapping("/{fileIds}")
    public R<Void> remove(@PathVariable List<Long> fileIds) {
        return toAjax(bizUserFileService.removeByIds(fileIds));
    }

    /**
     * 上传文件（AES 加密后存储）
     *
     * @param file 文件
     */
    @FileAuditLog(operateType = OperateType.UPLOAD)
    @Log(title = "安全文件上传", businessType = BusinessType.INSERT)
    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public R<BizUserFile> upload(@RequestPart("file") MultipartFile file) throws IOException {
        BizUserFile bizUserFile = bizUserFileService.uploadFile(file);
        return R.ok(bizUserFile);
    }

    /**
     * 下载文件（流式解密后输出）
     *
     * @param fileId   业务文件主键
     * @param response HTTP 响应
     */
    @FileAuditLog(operateType = OperateType.DOWNLOAD, fileIdParam = "fileId")
    @GetMapping("/download/{fileId}")
    public void download(@PathVariable Long fileId, HttpServletResponse response) throws IOException {
        bizUserFileService.downloadFile(fileId, response);
    }
}
