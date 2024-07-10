package com.miniproj.controller.hboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;

import com.miniproj.model.HBoardVO;
import com.miniproj.service.hboard.HBoardService;

@Controller // 아래의 클래스가 컨트롤러 객체임을 명시
@RequestMapping("/hboard")
public class HBoardController 
{
   // Log를 남길 수 있도록 하는 객체
   private static Logger logger = LoggerFactory.getLogger(HBoardController.class);
   
   @Autowired
   private HBoardService service;  //상속 받았기 때문에 부모가 HBoard 다
   
   // 게시판 전체 목록 리스트를 출력하는 메서드
   @RequestMapping("/listAll")
   public void listAll(Model model)
   {
      logger.info("HBoardController.listAll()~");
      
      // 서비스 단 호출
      List<HBoardVO> list = null;
	try {
		list = service.getAllBoard();
		 model.addAttribute("boardList", list);
	} catch (Exception e) {
		model.addAttribute("exception", "error");
	}
      
//      for(HBoardVO b : list) {
//			System.out.println(b.toString());
//		}
      //model.addAttribute("boardList", list); //바이터 파인딩
      // return "/hboard/listAll.jsp";
      // /hboard/listAll.jsp 으로 포워딩 됨
   }
   
   // 게시판 글 저장 페이지를 출력하는 메서드
   @RequestMapping("/saveBoard")
   public String showSaveBoardForm() {
	   return "/hboard/saveBoardForm";
   }
   
   
   
}
