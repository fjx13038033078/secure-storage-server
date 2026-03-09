package org.dromara.secure.constant;

/**
 * 分享相关常量
 *
 * @author ruoyi
 */
public interface ShareConstant {

    /**
     * 分享状态：正常
     */
    String STATUS_NORMAL = "0";

    /**
     * 分享状态：失效
     */
    String STATUS_INVALID = "1";

    /**
     * 分享下载 Token Redis 前缀
     */
    String SHARE_DOWNLOAD_TOKEN_PREFIX = "secure:share:download:";

    /**
     * 分享下载 Token 有效期（分钟）
     */
    int SHARE_DOWNLOAD_TOKEN_EXPIRE_MINUTES = 10;
}
