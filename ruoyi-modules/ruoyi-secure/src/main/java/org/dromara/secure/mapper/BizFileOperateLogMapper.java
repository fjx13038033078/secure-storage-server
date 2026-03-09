package org.dromara.secure.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.dromara.secure.domain.BizFileOperateLog;

/**
 * 文件操作审计日志 数据层
 *
 * @author ruoyi
 */
@Mapper
public interface BizFileOperateLogMapper extends BaseMapper<BizFileOperateLog> {
}
