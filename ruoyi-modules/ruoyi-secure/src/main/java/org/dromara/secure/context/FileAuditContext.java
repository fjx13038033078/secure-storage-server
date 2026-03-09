package org.dromara.secure.context;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;

/**
 * 文件操作审计上下文（ThreadLocal）
 * 用于在无法从方法参数获取 fileId 的场景（如分享免登录下载），由业务代码在调用前设置
 *
 * @author ruoyi
 */
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public final class FileAuditContext {

    private static final ThreadLocal<Long> FILE_ID_HOLDER = new ThreadLocal<>();

    /**
     * 设置当前线程的 fileId（如分享下载场景）
     */
    public static void setFileId(Long fileId) {
        FILE_ID_HOLDER.set(fileId);
    }

    /**
     * 获取并清除当前线程的 fileId
     */
    public static Long getAndClearFileId() {
        try {
            return FILE_ID_HOLDER.get();
        } finally {
            FILE_ID_HOLDER.remove();
        }
    }
}
