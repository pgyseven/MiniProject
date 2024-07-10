package com.miniproj.persistence;

import java.util.List;

import com.miniproj.model.HBoardVO;

public interface HBoardDAO {
	
	//게시판의 전체 리스트를 가져오는 메서드
	List<HBoardVO>selectAllBoard(); //여기 퍼블릭 안쓴 이유 원래는 public abstrat 앱스트릭트는 생략되어도 그렇게 된다 없으면 퍼블릭이란것
    // 몸체가 없는 추상 메서드
}
