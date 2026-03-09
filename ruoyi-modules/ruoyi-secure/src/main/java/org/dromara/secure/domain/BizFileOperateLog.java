package org.dromara.secure.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

/**
 * 文件操作审计日志表 biz_file_operate_log
 *
 * @author ruoyi
 */
@Data
@TableName("biz_file_operate_log")
public class BizFileOperateLog implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /**
     * 日志主键
     */
    @TableId(value = "log_id", type = IdType.AUTO)
    private Long logId;

    /**
     * 操作人ID
     */
    private Long userId;

    /**
     * 操作人账号
     */
    private String userName;

    /**
     * 操作的文件ID(可为空)
     */
    private Long fileId;

    /**
     * 操作类型(1上传 2下载 3分享 4删除)
     */
    private String operateType;

    /**
     * 操作IP地址
     */
    private String ipaddr;

    /**
     * 操作时间
     */
    private Date createTime;

}
