package org.dromara.secure.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.dromara.common.mybatis.core.domain.BaseEntity;

import java.io.Serial;

/**
 * 用户个人文件记录表 biz_user_file
 *
 * @author ruoyi
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("biz_user_file")
public class BizUserFile extends BaseEntity {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 业务文件主键
     */
    @TableId(value = "file_id", type = IdType.AUTO)
    private Long fileId;

    /**
     * 所属用户ID
     */
    private Long userId;

    /**
     * 关联sys_oss主键(物理文件ID)
     */
    private Long ossId;

    /**
     * 文件展示名称
     */
    private String fileName;

    /**
     * 文件后缀扩展名
     */
    private String fileSuffix;

    /**
     * 文件大小(字节)
     */
    private Long fileSize;

    /**
     * 是否已AES加密(0否 1是)
     */
    private String isEncrypted;

    /**
     * 删除标志(0代表存在 2代表删除)
     */
    @TableLogic(value = "0", delval = "2")
    private String delFlag;

}
