package org.dromara.secure.annotation;

import java.lang.annotation.*;

/**
 * 文件操作审计日志注解
 *
 * @author ruoyi
 */
@Target({ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface FileAuditLog {

    /**
     * 操作类型
     */
    OperateType operateType();

    /**
     * 包含 fileId 的参数名，如 "fileId"。
     * 若不指定，将尝试从方法参数中查找名为 fileId 的 Long 类型参数。
     */
    String fileIdParam() default "fileId";
}
