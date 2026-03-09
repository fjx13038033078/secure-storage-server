package org.dromara.secure.service.impl;

import org.dromara.common.satoken.utils.LoginHelper;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.RandomUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.RequiredArgsConstructor;
import org.dromara.common.core.exception.ServiceException;
import org.dromara.common.core.utils.StringUtils;
import org.dromara.common.redis.utils.RedisUtils;
import org.dromara.secure.constant.ShareConstant;
import org.dromara.secure.context.FileAuditContext;
import org.dromara.secure.domain.BizFileShare;
import org.dromara.secure.domain.BizUserFile;
import org.dromara.secure.domain.vo.ShareExtractVo;
import org.dromara.secure.mapper.BizFileShareMapper;
import org.dromara.secure.service.IBizFileShareService;
import org.dromara.secure.service.IBizUserFileService;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.Calendar;
import java.util.Date;

/**
 * 文件安全分享 服务层实现
 *
 * @author ruoyi
 */
@RequiredArgsConstructor
@Service
public class BizFileShareServiceImpl extends ServiceImpl<BizFileShareMapper, BizFileShare> implements IBizFileShareService {

    private static final String SHARE_LINK_CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    private static final int SHARE_LINK_LENGTH = 8;
    private static final int MAX_SHARE_LINK_RETRIES = 10;

    private final IBizUserFileService bizUserFileService;

    @Override
    public BizFileShare createShare(Long fileId, Integer expireDays, Boolean needCode) {
        Long userId = LoginHelper.getUserId();

        BizUserFile bizUserFile = bizUserFileService.getById(fileId);
        if (ObjectUtil.isNull(bizUserFile)) {
            throw new ServiceException("文件不存在");
        }
        if (!userId.equals(bizUserFile.getUserId())) {
            throw new ServiceException("无权限分享该文件");
        }

        String shareLink = generateUniqueShareLink();
        String extractCode = Boolean.TRUE.equals(needCode) ? RandomUtil.randomNumbers(4) : null;

        Date expireTime = null;
        if (expireDays != null && expireDays > 0) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, expireDays);
            expireTime = cal.getTime();
        }

        BizFileShare share = new BizFileShare();
        share.setUserId(userId);
        share.setFileId(fileId);
        share.setShareLink(shareLink);
        share.setExtractCode(extractCode);
        share.setExpireTime(expireTime);
        share.setStatus(ShareConstant.STATUS_NORMAL);
        share.setCreateBy(String.valueOf(userId));
        share.setCreateTime(new Date());

        save(share);
        return share;
    }

    @Override
    public ShareExtractVo extractShare(String shareLink, String extractCode) {
        if (StringUtils.isBlank(shareLink)) {
            throw new ServiceException("分享链接不能为空");
        }

        BizFileShare share = lambdaQuery()
            .eq(BizFileShare::getShareLink, shareLink)
            .one();

        if (ObjectUtil.isNull(share)) {
            throw new ServiceException("分享不存在或已失效");
        }

        if (ShareConstant.STATUS_INVALID.equals(share.getStatus())) {
            throw new ServiceException("分享已失效");
        }

        if (share.getExpireTime() != null && share.getExpireTime().before(new Date())) {
            throw new ServiceException("分享已过期");
        }

        if (StringUtils.isNotBlank(share.getExtractCode())) {
            if (StringUtils.isBlank(extractCode)) {
                throw new ServiceException("请输入提取码");
            }
            if (!share.getExtractCode().equals(extractCode)) {
                throw new ServiceException("提取码错误");
            }
        }

        BizUserFile bizUserFile = bizUserFileService.getById(share.getFileId());
        if (ObjectUtil.isNull(bizUserFile)) {
            throw new ServiceException("文件不存在");
        }

        String token = IdUtil.fastSimpleUUID();
        String redisValue = shareLink + ":" + share.getFileId();
        RedisUtils.setCacheObject(
            ShareConstant.SHARE_DOWNLOAD_TOKEN_PREFIX + token,
            redisValue,
            Duration.ofMinutes(ShareConstant.SHARE_DOWNLOAD_TOKEN_EXPIRE_MINUTES)
        );

        ShareExtractVo vo = new ShareExtractVo();
        vo.setFileName(bizUserFile.getFileName());
        vo.setFileSize(bizUserFile.getFileSize());
        vo.setDownloadToken(token);
        return vo;
    }

    @Override
    public void downloadByShare(String shareLink, String token, jakarta.servlet.http.HttpServletResponse response) throws java.io.IOException {
        if (StringUtils.isBlank(shareLink) || StringUtils.isBlank(token)) {
            throw new ServiceException("分享链接和下载凭证不能为空");
        }

        String redisKey = ShareConstant.SHARE_DOWNLOAD_TOKEN_PREFIX + token;
        String redisValue = RedisUtils.getCacheObject(redisKey);
        if (StringUtils.isBlank(redisValue)) {
            throw new ServiceException("下载凭证已过期，请重新提取");
        }

        String[] parts = redisValue.split(":", 2);
        if (parts.length != 2 || !shareLink.equals(parts[0])) {
            throw new ServiceException("下载凭证无效");
        }

        Long fileId = Long.parseLong(parts[1]);

        BizFileShare share = lambdaQuery()
            .eq(BizFileShare::getShareLink, shareLink)
            .eq(BizFileShare::getFileId, fileId)
            .one();

        if (ObjectUtil.isNull(share)) {
            throw new ServiceException("分享不存在");
        }
        if (ShareConstant.STATUS_INVALID.equals(share.getStatus())) {
            throw new ServiceException("分享已失效");
        }
        if (share.getExpireTime() != null && share.getExpireTime().before(new Date())) {
            throw new ServiceException("分享已过期");
        }

        FileAuditContext.setFileId(fileId);
        bizUserFileService.downloadFileWithoutAuth(fileId, response);
    }

    private String generateUniqueShareLink() {
        for (int i = 0; i < MAX_SHARE_LINK_RETRIES; i++) {
            String link = RandomUtil.randomString(SHARE_LINK_CHARS, SHARE_LINK_LENGTH);
            long count = lambdaQuery().eq(BizFileShare::getShareLink, link).count();
            if (count == 0) {
                return link;
            }
        }
        throw new ServiceException("生成分享链接失败，请重试");
    }
}
