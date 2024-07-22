package com.miniproj.service.hboard;

import java.util.List;

import com.miniproj.model.BoardDetailInfo;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;

public interface HBoardService   //클래스와 동급이다 클래스를 디자인하기 위해서 먼저 만드는것 중괄호 없는 추상메서드만 만들수 있음 추상클래스와 인터페이스도 상속 가능 
{ // 추상 형체가 없다 이것도 저것도 될 수 있다. 자바의 부모는 object다 이것도 형체가 없다.  여기를 상속 받아서 bean grahp 처럼 구현 부모가 뭐냐에 따라 ! 부모가 동물이냐 식물이냐에 따라 자식이 결정되듯
   // 게시판 전체 리스트 조회
   public List<HBoardVO> getAllBoard() throws Exception;
   
   // 게시판 글 작성 
   boolean saveBoard(HBoardDTO newBoard) throws Exception;
   
   // 게시판 상세 보기
   public List<BoardDetailInfo> read(int boardNo) throws Exception;
   
   
   // 게시판 글 수정
   
   
   // 게시판 글 삭제
}
