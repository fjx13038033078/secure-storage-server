package org.dromara.secure.controller;

import cn.dev33.satoken.annotation.SaIgnore;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.dromara.common.core.domain.R;
import org.dromara.common.log.annotation.Log;
import org.dromara.common.log.enums.BusinessType;
import org.dromara.common.web.core.BaseController;
import org.dromara.secure.annotation.FileAuditLog;
import org.dromara.secure.annotation.OperateType;
import org.dromara.secure.domain.BizFileShare;
import org.dromara.secure.domain.vo.ShareExtractVo;
import org.dromara.secure.service.IBizFileShareService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

/**
 * 文件安全分享 控制层
 *
 * @author ruoyi
 */
@Validated
@RequiredArgsConstructor
@RestController
@RequestMapping("/secure/share")
public class BizFileShareController extends BaseController {

    private final IBizFileShareService bizFileShareService;

    /**
     * 创建分享
     *
     * @param fileId     被分享的文件ID
     * @param expireDays 有效天数，为空表示永久
     * @param needCode   是否需要提取码
     */
    @FileAuditLog(operateType = OperateType.SHARE, fileIdParam = "fileId")
    @Log(title = "创建分享", businessType = BusinessType.INSERT)
    @PostMapping("/create")
    public R<BizFileShare> create(
        @RequestParam Long fileId,
        @RequestParam(required = false) Integer expireDays,
        @RequestParam(defaultValue = "false") Boolean needCode) {
        BizFileShare share = bizFileShareService.createShare(fileId, expireDays, needCode);
        return R.ok(share);
    }

    /**
     * 校验并提取分享信息（免登录）
     *
     * @param shareLink   短链接
     * @param extractCode 提取码（需要时必填）
     */
    @SaIgnore
    @PostMapping("/extract")
    public R<ShareExtractVo> extract(
        @RequestParam String shareLink,
        @RequestParam(required = false) String extractCode) {
        ShareExtractVo vo = bizFileShareService.extractShare(shareLink, extractCode);
        return R.ok(vo);
    }

    /**
     * 免登录下载（需携带校验通过的 Token）
     * 该接口已通过 application.yml 的 security.excludes 放行
     * fileId 通过 FileAuditContext 由 Service 层设置
     */
    @FileAuditLog(operateType = OperateType.DOWNLOAD)
    @SaIgnore
    @GetMapping("/download")
    public void download(
        @RequestParam String shareLink,
        @RequestParam String token,
        HttpServletResponse response) throws IOException {
        bizFileShareService.downloadByShare(shareLink, token, response);
    }
}
