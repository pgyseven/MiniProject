package com.miniproj.reply;

import java.util.List;

import com.miniproj.model.ReplyVO;

public interface ReplyDAO {
	List<ReplyVO> getAllReplies(int boardNo) throws Exception;
}
