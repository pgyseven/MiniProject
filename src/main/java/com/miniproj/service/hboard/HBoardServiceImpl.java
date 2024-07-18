package com.miniproj.service.hboard;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.miniproj.controller.hboard.HBoardController;
import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;
import com.miniproj.model.PointLogDTO;
import com.miniproj.persistence.HBoardDAO;
import com.miniproj.persistence.MemberDAO;
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
	@Autowired
	private MemberDAO mDao;

	@Override
	public List<HBoardVO> getAllBoard() throws Exception {
		logger.info("HBoardServiceImpl.........");

		// DAO 단 호출
		List<HBoardVO> lst = bDao.selectAllBoard();
		return lst;
	}

	/*
	 * 프로퍼게이션 전파 퍼저 나간다. 각각의 쿼리문에서 단일 작업이 아니라 하나의 논리적 작업 단위로 묶었지안냐 saveboard라는걸로
	 * 그럼 커넥션 한번 클로즈를 한번 해줘야하지 안냐 그게 전파 속성이고reqired 필요하다면 오픈한걸 2~3번에서 전파해서 쓴다.
	 * 프로퍼게이션 propagation transaction 검색하기 다른 속성 알 수 있다 리콰이어드나 리콰이어드 뉴를 제일 많이씀
	 * 
	 * 이솔레이션 데이터 베이스에 데이터 화장실 1개인경우 이게 이솔레이션 속성 한사람이 다써야 다음 사람 쓴다 쓰는동안 화장실문이 닫힌거처럼
	 * 락걸린거 디폴트는 게시판을글 누군가가 수정하고 있는데 그 하나의 데이터에 다른 사람이 댓글이나 다른 작업을 못하게 즉 커밋같은걸 못하게
	 * 하나의 스레드가 뭔가를 작업할때 다른이가 못들어가게 다른 옵션으로는 커밋이 안되도 접근 가능하게 언커밋 데이터 불안대신 빠름
	 * 안정성을 위해 거의 디폴트 쓴다 
	 * 추가적으로 스레드 was thred 검색 공부 클라이언트 들어올때 스레드가 발생하며 여기에 소스코드 들어가고 메모리가 할당됨
	 * 동시의 여러개의 스레드가 하나의 자원에 접근할때 그걸 어떻게 처리할건지가 이솔레이션 리드 언커밋은 나이키 100원 판매 이런거 다수가 들어와 경품 이벤트 근데 에러 많이 보일것
	 * 
	 * 
	 * 롤백하면 생기는 아이콘은 제어가 끼어들어간다. 
	 * rollbackFor 언제 롤백할거냐 익셉션 객체가 발생하면
	 * 롤백을 한다. 진행하던게 예외 처리 나오면 객체 생성된거고 그 위에껄 롤백 3번재꺼가 그러면 위에 두개까지 롤백임 그리고 디비는 에러가
	 * 없다 예외가 나는것이다.
	 * 
	 * 아래에서 에러가 보이면 내가 만든 파일명을 찾아라 스피링이 같이 돌아가기때문에 그게 에러라서 스프링도 에러난것
	 */
	@Override
	@Transactional(propagation =Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)  
	public boolean saveBoard(HBoardDTO newBoard) throws Exception {
		boolean result = false; //지역변수는 항상 초기값 있어야 정상 작동
		
		// 1) newBoard를 ( 새로넘겨진 게시글) DAO 단을 통해 insert 해본다. -insert close
		if (bDao.insertNewBoard(newBoard) == 1) {
			//1-2) 위에서 저장된 게시글의 pk(boardNo)를 가져와야 한다.select
			int newBoardNo = bDao.getMaxBoardNo();
			//System.out.println("방금 저장된 글 번호 : " + newBoardNo);
			//1-2) 첨부된 파일이 있다면... 첨부 파일 또한 저장한다...insert
			for (BoardUpFilesVODTO file : newBoard.getFileList()) { // newBoard.getFileList() 사이즈가 0이면 즉 없으면 첨부된게 포문이 안도니깐 이프문 필요 없음
				file.setBoardNo(newBoardNo);
				bDao.insertBoardUpFile(file); // 여기서도 여러개의 파일이 하나라도 안들어가면 트랜잭션이란 애로 롤백위에 한다고 했으니 롤백
				
			}
			
			// 2) 1)번에서 insert 가 성공했을 때 글 작성자의 point를 부여한다. -(select) close - insert close
			// 참고로 commit은 데이터를 영구하게 저장하기 위함
			if (pDao.insertPointLog(new PointLogDTO(newBoard.getWriter(), "글작성", 0)) == 1) {

				// 3) 작성자의 userpoint 값 update 글작성한 것에 대한 기존 유저의 포인트를 플러스나 마이너스 하여 넣어줘야한다. close
				if( mDao.updateUserPoint(newBoard.getWriter()) == 1 ) {
					result = true;
				}
			}
			// 위처럼 우리가 이전 만든 주석의 경우처럼 close 즉 closeAll이 매번 경우에 있었듯 클로즈가 되면 중간에 두번째 인서트가 안되면
			// 롤백이 안된다. 이전에 클로즈 하면서 커밋이 된거니깐
			// 즉 colseAll 도 커밋이 된다. 그럼 우리도 마이바티스 맴버다오 임플 예제 처럼 sqlsession도 크로즈까지 해준다.해결하려면
			// 자동 커밋을 꺼야하는데 스프링 컨테이너가 이런걸 도와준다.
			// 다시말해 클로즈 안하고 sql 문장이 다 완료 되어야지만 클로즈한다 올 오어 낫띵 @Transactonal (propagation =
			// ,isola, ) 이걸 넣어주는 방식이면 된다. 커리문 두개이상 나오면 트랜잭션 처리를 해야한다.
			// DML 문장(인서트 업데이트 딜리트) 이런 문장 2개 이상나오면 무조건 트랜잭션 처리한다.
		}

		return result;
	}

	@Override
	public void read(int boardNo) throws Exception {
		//게시글 조회를 한다... select(첨부파일이 있다면 첨부파일도 조회한다. select)
		System.out.println(bDao.selectBoardByBoardNo(boardNo).toString());
		// 해당 글번호의 조회수를 증가한다. update
		
	}

}
