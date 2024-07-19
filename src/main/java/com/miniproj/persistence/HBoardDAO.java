package com.miniproj.persistence;

import java.util.List;

import com.miniproj.model.BoardUpFilesVODTO;
import com.miniproj.model.HBoardDTO;
import com.miniproj.model.HBoardVO;

public interface HBoardDAO  {
	
	//게시판의 전체 리스트를 가져오는 메서드
	List<HBoardVO>selectAllBoard() throws Exception; //여기 퍼블릭 안쓴 이유 원래는 public abstrat 앱스트릭트는 생략되어도 그렇게 된다 없으면 퍼블릭이란것
    // 몸체가 없는 추상 메서드
	
	//게시글을 저장하는 메소드
	int insertNewBoard(HBoardDTO newBoard) throws Exception;
	
	//최근 저장된 글의 글번호를 얻어오는 메서드
	int getMaxBoardNo() throws Exception;
	
	// 업로드된 첨부파일을 저장하는 쿼리문
	int insertBoardUpFile(BoardUpFilesVODTO upFile) throws Exception;
	
	//글번호 게시글을 가져오는 쿼리문
	HBoardVO selectBoardByBoardNo(int boardNo) throws Exception;
	
	//글번호로 게시글의 파일을 가져오는 쿼리문
	List<BoardUpFilesVODTO> selectBoardUpFilesByBoardNo (int boardNo) throws Exception;
}
