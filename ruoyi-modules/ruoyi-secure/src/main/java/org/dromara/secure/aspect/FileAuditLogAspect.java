package org.dromara.secure.aspect;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.ObjectUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.dromara.common.core.domain.model.LoginUser;
import org.dromara.common.core.utils.ServletUtils;
import org.dromara.common.core.utils.StringUtils;
import org.dromara.common.satoken.utils.LoginHelper;
import org.dromara.secure.annotation.FileAuditLog;
import org.dromara.secure.annotation.OperateType;
import org.dromara.secure.context.FileAuditContext;
import org.dromara.secure.domain.BizFileOperateLog;
import org.dromara.secure.domain.BizUserFile;
import org.dromara.secure.service.FileAuditLogService;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * 文件操作审计日志切面
 *
 * @author ruoyi
 */
@Slf4j
@Aspect
@Order(100)
@Component
@RequiredArgsConstructor
public class FileAuditLogAspect {

    /**
     * 免登录下载时的操作人 ID
     */
    private static final long ANONYMOUS_USER_ID = -1L;

    /**
     * 免登录下载时的操作人账号
     */
    private static final String ANONYMOUS_USER_NAME = "匿名";

    private final FileAuditLogService fileAuditLogService;

    @AfterReturning(pointcut = "@annotation(fileAuditLog)", returning = "result")
    public void doAfterReturning(JoinPoint joinPoint, FileAuditLog fileAuditLog, Object result) {
        try {
            Long fileId = resolveFileId(joinPoint, fileAuditLog, result);
            Long userId = resolveUserId();
            String userName = resolveUserName();
            String ipaddr = ServletUtils.getClientIP();

            BizFileOperateLog operateLog = new BizFileOperateLog();
            operateLog.setUserId(userId);
            operateLog.setUserName(userName);
            operateLog.setFileId(fileId);
            operateLog.setOperateType(fileAuditLog.operateType().getCode());
            operateLog.setIpaddr(StringUtils.isNotBlank(ipaddr) ? ipaddr : "");
            operateLog.setCreateTime(new Date());

            fileAuditLogService.saveLogAsync(operateLog);
        } catch (Exception e) {
            log.warn("文件操作审计日志记录失败: {}", e.getMessage());
        }
    }

    private Long resolveFileId(JoinPoint joinPoint, FileAuditLog fileAuditLog, Object result) {
        String paramName = fileAuditLog.fileIdParam();
        if (StringUtils.isNotBlank(paramName)) {
            Long fromParam = getFileIdFromParam(joinPoint, paramName);
            if (fromParam != null) {
                return fromParam;
            }
        }

        if (ObjectUtil.isNotNull(result) && result instanceof BizUserFile bizUserFile) {
            return bizUserFile.getFileId();
        }

        Long fromContext = FileAuditContext.getAndClearFileId();
        if (fromContext != null) {
            return fromContext;
        }

        return null;
    }

    private Long getFileIdFromParam(JoinPoint joinPoint, String paramName) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        String[] paramNames = signature.getParameterNames();
        Object[] args = joinPoint.getArgs();

        if (paramNames != null && args != null) {
            for (int i = 0; i < paramNames.length; i++) {
                if (paramName.equals(paramNames[i]) && args[i] != null) {
                    Object arg = args[i];
                    if (arg instanceof Long) {
                        return (Long) arg;
                    }
                    if (arg instanceof Number) {
                        return ((Number) arg).longValue();
                    }
                    return null;
                }
            }
        }
        return null;
    }

    private Long resolveUserId() {
        try {
            StpUtil.checkLogin();
            return StpUtil.getLoginIdAsLong();
        } catch (Exception e) {
            return ANONYMOUS_USER_ID;
        }
    }

    private String resolveUserName() {
        if (!LoginHelper.isLogin()) {
            return ANONYMOUS_USER_NAME;
        }
        LoginUser loginUser = LoginHelper.getLoginUser();
        return loginUser != null ? loginUser.getUsername() : ANONYMOUS_USER_NAME;
    }
}
