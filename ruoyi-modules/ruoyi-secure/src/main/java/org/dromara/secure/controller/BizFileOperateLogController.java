package org.dromara.secure.controller;

import lombok.RequiredArgsConstructor;
import org.dromara.common.mybatis.core.page.PageQuery;
import org.dromara.common.mybatis.core.page.TableDataInfo;
import org.dromara.common.satoken.utils.LoginHelper;
import org.dromara.common.web.core.BaseController;
import org.dromara.secure.domain.BizFileOperateLog;
import org.dromara.secure.service.IBizFileOperateLogService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 文件操作审计日志 控制层
 *
 * @author ruoyi
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/secure/fileLog")
public class BizFileOperateLogController extends BaseController {

    private final IBizFileOperateLogService bizFileOperateLogService;

    /**
     * 分页查询文件操作日志
     */
    @GetMapping("/list")
    public TableDataInfo<BizFileOperateLog> list(
        PageQuery pageQuery,
        @RequestParam(required = false) String operateType,
        @RequestParam(required = false) String userName,
        @RequestParam(required = false) String beginTime,
        @RequestParam(required = false) String endTime) {
        Long userId = LoginHelper.getUserId();
        return bizFileOperateLogService.queryPageList(userId, operateType, userName, beginTime, endTime, pageQuery);
    }
}
