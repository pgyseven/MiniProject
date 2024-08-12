package com.miniproj.controller.hboard;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.miniproj.model.HBoardVO;
import com.miniproj.model.PagingInfo;
import com.miniproj.model.PagingInfoDTO;
import com.miniproj.model.SearchCriteriaDTO;
import com.miniproj.service.hboard.RBoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/rboard")
public class RBoardController {
	
	private static Logger logger = LoggerFactory.getLogger(HBoardController.class);
	
	
	
	private final RBoardService service;
	@RequestMapping("/listAll")
	public void listAll(Model model, @RequestParam(value="pageNo", defaultValue = "1") int pageNo, @RequestParam(value="pagingSize", defaultValue = "10") int pagingSize, SearchCriteriaDTO searchCriteria) {
		logger.info(pageNo + "번 페이지 출력.....HBoardController.listAll()~" + ", 검색조건 :" + searchCriteria.toString());

		PagingInfoDTO dto = PagingInfoDTO.builder()
		.pageNo(pageNo)
		.pagingSize(pagingSize)
		.build();

		
			Map<String, Object> result = null;
			
			try {
				result = service.getAllBoard(dto, searchCriteria);
				
				PagingInfo pi = (PagingInfo)result.get("pagingInfo"); // 명시적 변환 다운 캐스팅
				
				List<HBoardVO> list = (List<HBoardVO>)result.get("boardList");
				
				model.addAttribute("boardList", list);
				model.addAttribute("pagingInfo",pi);
				model.addAttribute("search",searchCriteria);
			} catch (Exception e) {
				e.printStackTrace();
				model.addAttribute("exception", "error");
				

			}

	}

	
}
