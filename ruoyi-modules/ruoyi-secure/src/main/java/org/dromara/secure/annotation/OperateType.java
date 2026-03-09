package org.dromara.secure.annotation;

/**
 * 文件操作类型枚举
 * 对应 biz_file_operate_log.operate_type 字段（1上传 2下载 3分享 4删除）
 *
 * @author ruoyi
 */
public enum OperateType {

    UPLOAD("1"),
    DOWNLOAD("2"),
    SHARE("3"),
    DELETE("4");

    private final String code;

    OperateType(String code) {
        this.code = code;
    }

    public String getCode() {
        return code;
    }
}
