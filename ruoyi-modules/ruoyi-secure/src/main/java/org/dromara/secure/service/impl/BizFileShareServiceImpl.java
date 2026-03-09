package org.dromara.secure.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.dromara.secure.domain.BizFileShare;
import org.dromara.secure.mapper.BizFileShareMapper;
import org.dromara.secure.service.IBizFileShareService;
import org.springframework.stereotype.Service;

/**
 * 文件安全分享 服务层实现
 *
 * @author ruoyi
 */
@Service
public class BizFileShareServiceImpl extends ServiceImpl<BizFileShareMapper, BizFileShare> implements IBizFileShareService {
}
