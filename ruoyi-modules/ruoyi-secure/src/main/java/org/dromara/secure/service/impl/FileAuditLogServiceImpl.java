package org.dromara.secure.service.impl;

import lombok.RequiredArgsConstructor;
import org.dromara.secure.domain.BizFileOperateLog;
import org.dromara.secure.service.FileAuditLogService;
import org.dromara.secure.service.IBizFileOperateLogService;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

/**
 * 文件操作审计日志异步保存服务实现
 *
 * @author ruoyi
 */
@RequiredArgsConstructor
@Service
public class FileAuditLogServiceImpl implements FileAuditLogService {

    private final IBizFileOperateLogService bizFileOperateLogService;

    @Async
    @Override
    public void saveLogAsync(BizFileOperateLog log) {
        try {
            bizFileOperateLogService.save(log);
        } catch (Exception e) {
            // 异步日志保存失败不影响主流程，仅记录
            org.slf4j.LoggerFactory.getLogger(FileAuditLogServiceImpl.class)
                .warn("文件操作审计日志保存失败: {}", e.getMessage());
        }
    }
}
