package org.dromara.secure.service;

import org.dromara.secure.domain.BizFileOperateLog;

/**
 * 文件操作审计日志异步保存服务
 *
 * @author ruoyi
 */
public interface FileAuditLogService {

    /**
     * 异步保存操作日志
     *
     * @param log 日志实体
     */
    void saveLogAsync(BizFileOperateLog log);
}
