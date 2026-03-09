package org.dromara.secure.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.dromara.common.mybatis.core.page.PageQuery;
import org.dromara.common.mybatis.core.page.TableDataInfo;
import org.dromara.secure.domain.BizUserFile;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

/**
 * 用户个人文件记录 服务层
 *
 * @author ruoyi
 */
public interface IBizUserFileService extends IService<BizUserFile> {

    /**
     * 分页查询当前用户的文件列表
     */
    TableDataInfo<BizUserFile> queryPageList(Long userId, PageQuery pageQuery);

    /**
     * 上传文件（AES 加密后存储到 MinIO）
     *
     * @param file 前端上传的文件
     * @return 业务文件记录
     */
    BizUserFile uploadFile(MultipartFile file) throws IOException;

    /**
     * 下载文件（从 MinIO 获取加密文件，流式解密后输出）
     *
     * @param fileId   业务文件主键
     * @param response HTTP 响应
     */
    void downloadFile(Long fileId, jakarta.servlet.http.HttpServletResponse response) throws IOException;

    /**
     * 根据 fileId 直接下载文件（不校验用户权限，用于分享场景）
     *
     * @param fileId   业务文件主键
     * @param response HTTP 响应
     */
    void downloadFileWithoutAuth(Long fileId, jakarta.servlet.http.HttpServletResponse response) throws IOException;
}
