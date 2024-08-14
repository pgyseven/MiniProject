package com.miniproj.reply;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.miniproj.model.ReplyVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class ReplyDAOImpl implements ReplyDAO {

	
	private static final String NS = "com.miniproj.replyMapper";
	private final SqlSession ses;
	
	@Override
	public List<ReplyVO> getAllReplies(int boardNo) throws Exception {
		
		return ses.selectList(NS + ".getReplies", boardNo);
	}

}
