package com.miniproj.service.hboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.miniproj.controller.hboard.HBoardController;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.PointLogDTO;
import com.miniproj.persistence.HBoardDAO;
import com.miniproj.persistence.PointLogDAO;

// Service 단에서 해야할 작업
// 1) Controller  에서 넘겨진 파라메터를 처리한 후 (비지니스 로직에 의해(트랜잭션 처리를 통해))
// 2) DB 작업 이라면 DAO단 호출 ...
// 3) DAO 단에서 반환된 값을 Controller 단으로 넘겨줌

@Service // 아래의 클래스가 서비스 객체임을 컴파일러에 공지 (알려준다)
public class HBoardServiceImpl implements HBoardService {

	private static Logger logger = LoggerFactory.getLogger(HBoardServiceImpl.class);
	
	@Autowired
	private HBoardDAO bDao;
	@Autowired
	private PointLogDAO pDao;
	
	@Override
	public List<HBoardVO> getAllBoard() throws Exception {
		logger.info("HBoardServiceImpl.........");
		
		
		// DAO 단 호출
		List<HBoardVO> lst = bDao.selectAllBoard();
		return lst;
	}

	@Override
	public boolean saveBoard(HBoardDTO newBoard) throws Exception {
		// 1) newBoard를 ( 새로넘겨진 게시글) DAO 단을 통해 insert 해본다. -insert close
		if (bDao.insertNewBoard(newBoard)==1) {
		// 2) 1)번에서 insert 가 성공했을 때 글 작성자의 point를 부여한다. -(select) close - insert close 참고로 commit은 데이터를 영구하게 저장하기 위함
			System.out.println(pDao.insertPointLog(new PointLogDTO(newBoard.getWriter(), "글작성", 0)));

		// 3) 작성자의 userpoint 값 update close
		
		//위처럼 우리가 이전 만든 경우처럼 closeAll이 매번 경우에 있었듯 클로즈가 되면 중간에 두번째 인서트가 안되면 롤백이 안된다. 이전에 클로즈 하면서 커밋이 된거니깐
		//즉 colseAll 도 커밋이 된다. 그럼 우리도 마이바티스 맴버다오 임플 예제 처럼 sqlsession도 크로즈까지 해준다.해결하려면 자동 커밋을 꺼야하는데 스프링 컨테이너가 이런걸 도와준다.
		// 다시말해 클로즈 안하고 sql 문장이 다 완료 되어야지만 클로즈한다 올 오어 낫띵 @Transactonal (propagation = ,isola, ) 이걸 넣어주는 방식이면 된다. 커리문 두개이상 나오면 트랜잭션 처리를 해야한다.
		//DML 문장(인서트 업데이트 딜리트) 이런 문장 2개 이상나오면 무조건 트랜잭션 처리한다.
		}
		
		return false; 
	}

}
