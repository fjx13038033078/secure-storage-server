package org.dromara.secure.service;

import com.baomidou.mybatisplus.extension.service.IService;
import org.dromara.common.mybatis.core.page.PageQuery;
import org.dromara.common.mybatis.core.page.TableDataInfo;
import org.dromara.secure.domain.BizFileOperateLog;

/**
 * 文件操作审计日志 服务层
 *
 * @author ruoyi
 */
public interface IBizFileOperateLogService extends IService<BizFileOperateLog> {

    /**
     * 分页查询文件操作日志
     *
     * @param userId     当前用户ID（非超管时仅查本人）
     * @param operateType 操作类型（1上传 2下载 3分享 4删除）
     * @param userName   操作人账号
     * @param beginTime  开始时间
     * @param endTime    结束时间
     * @param pageQuery  分页参数
     * @return 分页结果
     */
    TableDataInfo<BizFileOperateLog> queryPageList(Long userId, String operateType, String userName,
        String beginTime, String endTime, PageQuery pageQuery);
}
