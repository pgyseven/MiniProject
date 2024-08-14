package com.miniproj.reply;

import java.util.List;

import com.miniproj.model.ReplyVO;

public interface ReplyService {
	List<ReplyVO> getAllReplies(int boardNo) throws Exception;
}
