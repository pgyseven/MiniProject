package com.miniproj.controller.hboard;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller  // 아래의 클래스가 컨트롤러 객체임을 명시
@RequestMapping("/hboard")
public class HBoardController {
	
	@RequestMapping("/listAll")
	public void listAll() {
		// return "/hboard/listAll.jsp; // /hboard/listAll.jsp
		
	}
}
