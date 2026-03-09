package org.dromara.secure.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.dromara.secure.domain.BizFileShare;
import org.dromara.secure.domain.vo.ShareExtractVo;

/**
 * 文件安全分享 服务层
 *
 * @author ruoyi
 */
public interface IBizFileShareService extends IService<BizFileShare> {

    /**
     * 创建分享
     *
     * @param fileId     被分享的文件ID
     * @param expireDays 有效天数，为空表示永久
     * @param needCode   是否需要提取码
     * @return 分享记录
     */
    BizFileShare createShare(Long fileId, Integer expireDays, Boolean needCode);

    /**
     * 校验并提取分享信息
     *
     * @param shareLink  短链接
     * @param extractCode 提取码（需要时必填）
     * @return 文件基本信息 + 下载 Token
     */
    ShareExtractVo extractShare(String shareLink, String extractCode);

    /**
     * 免登录下载（需携带校验通过的 Token）
     *
     * @param shareLink 短链接
     * @param token     校验通过的下载 Token
     * @param response  HTTP 响应
     */
    void downloadByShare(String shareLink, String token, jakarta.servlet.http.HttpServletResponse response) throws java.io.IOException;
}
