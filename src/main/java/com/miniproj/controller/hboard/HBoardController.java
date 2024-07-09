package com.miniproj.controller.hboard;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller // 아래의 클래스가 컨트롤러 객체임을 명시
@RequestMapping("/hboard")
public class HBoardController 
{
   // Log를 남길 수 있도록 하는 객체
   private static Logger logger = LoggerFactory.getLogger(HBoardController.class);
   
   @RequestMapping("/listAll")
   public void listAll()
   {
      logger.info("HBoardController.listAll()~");
      // return "/hboard/listAll.jsp";
      // /hboard/listAll.jsp
   }
}
