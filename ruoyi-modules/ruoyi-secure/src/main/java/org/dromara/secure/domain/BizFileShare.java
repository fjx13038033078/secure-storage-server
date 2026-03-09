package org.dromara.secure.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

/**
 * 文件安全分享表 biz_file_share
 *
 * @author ruoyi
 */
@Data
@TableName("biz_file_share")
public class BizFileShare implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 分享主键
     */
    @TableId(value = "share_id", type = IdType.AUTO)
    private Long shareId;

    /**
     * 分享人ID
     */
    private Long userId;

    /**
     * 被分享的业务文件ID
     */
    private Long fileId;

    /**
     * 短链接标识(如: aBcD123)
     */
    private String shareLink;

    /**
     * 提取码(4位随机数，为空则无密码)
     */
    private String extractCode;

    /**
     * 过期时间(为空表示永久有效)
     */
    private Date expireTime;

    /**
     * 状态(0正常 1失效)
     */
    private String status;

    /**
     * 创建者
     */
    private String createBy;

    /**
     * 分享创建时间
     */
    private Date createTime;

}
