package com.miniproj.persistence;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;

@Repository //아래의 클래스가 DAO 객체임을 명시
public class HBoardDAOImpl implements HBoardDAO {
// Impl 구현하다 implement
   
   //루트다시 컨텍스트 아래 소스에 써둔 sqlsession 불러오는것
   @Autowired
   private SqlSession ses;
   
   private static String NS = "com.miniproj.mapper.hboardmapper";
   
   
   // throws : 현재 메서드에서 예외가 발생하면 현재 메서드를 호출한 곳에서 예외처리를 하도록 미뤄두는 키워드
   @Override
   public List<HBoardVO> selectAllBoard() throws Exception {
      System.out.println("여기는 HBoard DaoImpl ...................");
      
      List<HBoardVO> list = ses.selectList(NS + ".getAllHBoard");
      
//      for(HBoardVO b : list) {
//         System.out.println(b.toString());
//      }
      return list;
      
      
      
      
   }


   @Override
   public int insertNewBoard(HBoardDTO newBoard) {
      
      return ses.insert(NS + ".saveNewBoard", newBoard);
   }


   @Override
   public int getMaxBoardNo() throws Exception {
      
      return ses.selectOne(NS + ".getMaxNo");
   }


   @Override
   public int insertBoardUpFile(BoardUpFilesVODTO upFile) throws Exception {
      System.out.println("BoardUpFilesVODTO 여기서 예외가 나오는지 확인하기 위한 프린트");
      return ses.insert(NS + ".saveUpFile", upFile);
   }


   @Override
   public HBoardVO selectBoardByBoardNo(int boardNo) throws Exception {
      
      return ses.selectOne(NS + ".selectBoardByBoardNo", boardNo);
   }


@Override
public List<BoardUpFilesVODTO> selectBoardUpFilesByBoardNo(int boardNo) throws Exception { //인터페이스가 아닌 이 페이지에서는 추상클래스는 추상 메서드와 구현된 메서드도 가질 수 있다. 즉위에서 엡스트릭스로!!! 해두면 에러는 안날거다.
	return ses.selectList(NS + ".selectBoardUpFiles", boardNo);
	
}

}
