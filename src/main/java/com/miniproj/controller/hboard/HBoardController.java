package com.miniproj.controller.hboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.miniproj.model.HBoardDTO;
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
   
   // 게시글 저장 버튼을 눌렀을때 해당 게시글을 db에 저장하는 메서드
	@RequestMapping(value="/saveBoard", method = RequestMethod.POST)  /*url 호출이름이 위와 같은데 전송방식이 다르기 때문에 문제 없다*/
   public void saveBoard(HBoardDTO boardDTO) {
		 System.out.println("이게시글을 출력하자...................." + boardDTO.toString()); //"/saveBoard 보이드는 이거에 의해서 .jsp 가 붙어서 간다.
		 
			// VO는 리드 온리로서 디비에 꺼내온걸 저장해서 앞단까지 가져가는 것 즉 뷰단까지 즉 DTO와 VO가 다른거다 같이 쓰기도 하는데 앞단 뷰단은 자주 바뀔수 있다. 그래서 따로 쓰는게 좋다. 
	}
  
}
