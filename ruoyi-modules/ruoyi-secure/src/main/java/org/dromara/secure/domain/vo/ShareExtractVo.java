package org.dromara.secure.domain.vo;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

/**
 * 分享提取结果 VO
 *
 * @author ruoyi
 */
@Data
public class ShareExtractVo implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 文件名
     */
    private String fileName;

    /**
     * 文件大小（字节）
     */
    private Long fileSize;

    /**
     * 校验通过后的临时 Token，用于免登录下载
     */
    private String downloadToken;
}
