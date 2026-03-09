package org.dromara.secure.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.dromara.common.mybatis.core.page.PageQuery;
import org.dromara.common.mybatis.core.page.TableDataInfo;
import org.dromara.common.satoken.utils.LoginHelper;
import org.dromara.common.core.utils.StringUtils;
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

    @Override
    public TableDataInfo<BizFileOperateLog> queryPageList(Long userId, String operateType, String userName,
        String beginTime, String endTime, PageQuery pageQuery) {
        LambdaQueryWrapper<BizFileOperateLog> wrapper = new LambdaQueryWrapper<BizFileOperateLog>()
            .eq(!LoginHelper.isSuperAdmin(userId), BizFileOperateLog::getUserId, userId)
            .eq(StringUtils.isNotBlank(operateType), BizFileOperateLog::getOperateType, operateType)
            .like(StringUtils.isNotBlank(userName), BizFileOperateLog::getUserName, userName)
            .between(StringUtils.isNotBlank(beginTime) && StringUtils.isNotBlank(endTime),
                BizFileOperateLog::getCreateTime, beginTime, endTime)
            .orderByDesc(BizFileOperateLog::getCreateTime);
        Page<BizFileOperateLog> page = page(pageQuery.build(), wrapper);
        return TableDataInfo.build(page);
    }
}
