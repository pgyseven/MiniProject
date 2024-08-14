package com.miniproj.reply;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.model.ReplyVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReplyServiceImpl implements ReplyService {


	private final ReplyDAO rDao;
	@Override
	@Transactional(readOnly = true)
	public List<ReplyVO> getAllReplies(int boardNo) throws Exception {
		
		return rDao.getAllReplies(boardNo);
	}

}
