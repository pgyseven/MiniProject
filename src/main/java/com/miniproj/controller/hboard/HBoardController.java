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

// Controller 단에서 해야 할 일
// 1) URI 매핑(어떤 URI가 어떤 방식으로(GET/Post)으로 호출 되었을 때 어떤 메서드에 매핑 시킬 것이냐
// 2) 있다면 view 단에서 보내준 매개변수 수집
// 3) 데이터베이스에 대한 CRUD 를 수행하기 위해 service단의 해당 메서드를 호출. service단에서 rerutn 갑을 view 바인딩 view 호출
// 4) 부가적으로... 컨트롤러 단은 servlet에 의해 동작되는 모듈이기 때문에 HttpServletRequest, HttpServletReponse,HttpSession
// 등의 Servlet 객체들을 이용할 수 있다 -> 이러한 객체들을 이용하여 구현할 기능이 있다면 그 기능은 Controller 단에서 구현한다.(참고로 리퀘스트는 한번 하면 사라지지만 세션은 유저마다 하나씩 생긴다. 유저가 떠날때까지 유지) 서비스단 이후는 서블릿이 아니라 리퀘스트 세션 불러올수 없다 그래서 컨트롤러 단에서만 이걸 불러오는건 다 해야한다.

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
		 try {
			service.saveBoard(boardDTO);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			// VO는 리드 온리로서 디비에 꺼내온걸 저장해서 앞단까지 가져가는 것 즉 뷰단까지 즉 DTO와 VO가 다른거다 같이 쓰기도 하는데 앞단 뷰단은 자주 바뀔수 있다. 그래서 따로 쓰는게 좋다. 
	}
  
}
