package org.dromara.secure.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.dromara.secure.domain.BizFileOperateLog;
import org.dromara.secure.mapper.BizFileOperateLogMapper;
import org.dromara.secure.service.IBizFileOperateLogService;
import org.springframework.stereotype.Service;

/**
 * 文件操作审计日志 服务层实现
 *
 * @author ruoyi
 */
@Service
public class BizFileOperateLogServiceImpl extends ServiceImpl<BizFileOperateLogMapper, BizFileOperateLog> implements IBizFileOperateLogService {
}
