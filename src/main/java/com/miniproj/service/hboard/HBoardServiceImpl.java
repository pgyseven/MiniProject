package com.miniproj.service.hboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.miniproj.controller.hboard.HBoardController;
import com.miniproj.model.HBoardVO;
import com.miniproj.persistence.HBoardDAO;

@Service // 아래의 클래스가 서비스 객체임을 컴파일러에 공지 (알려준다)
public class HBoardServiceImpl implements HBoardService {

	private static Logger logger = LoggerFactory.getLogger(HBoardServiceImpl.class);
	
	@Autowired
	private HBoardDAO bDao;
	
	@Override
	public List<HBoardVO> getAllBoard() {
		logger.info("HBoardServiceImpl.........");
		
		
		// DAO 단 호출
		List<HBoardVO> lst = bDao.selectAllBoard();
		return lst;
	}

}
