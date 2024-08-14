package com.miniproj.reply;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.miniproj.model.ReplyVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/reply")
@RequiredArgsConstructor
public class ReplyController {

	private final ReplyService rService;

	@GetMapping("/all/{boardNo}") // @PathVariable : 이 자리에 boardNo가 들어간다는 의미
	public @ResponseBody List<ReplyVO> getAllReplyByBoardNo(@PathVariable("boardNo") int boardNo) {
		//@ResponseBody 는 List<ReplyVO> 을 제이슨으로 만들라는 애이다.  단점이 전송 상태를 같이 못 보내준다.
		System.out.println(boardNo + "번의 모든 댓글을 얻어오자.");
		
		List<ReplyVO> result = null;
		
		try {
			result = rService.getAllReplies(boardNo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
		
	}
}
