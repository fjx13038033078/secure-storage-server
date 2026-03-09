package org.dromara.secure.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.dromara.secure.domain.BizUserFile;
import org.dromara.secure.mapper.BizUserFileMapper;
import org.dromara.secure.service.IBizUserFileService;
import org.springframework.stereotype.Service;

/**
 * 用户个人文件记录 服务层实现
 *
 * @author ruoyi
 */
@Service
public class BizUserFileServiceImpl extends ServiceImpl<BizUserFileMapper, BizUserFile> implements IBizUserFileService {
}
