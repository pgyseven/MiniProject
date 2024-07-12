package com.miniproj.persistence;

public interface MemberDAO {
	// 유저의 userpoint를 수정하는 메서드
	int updateUserPoint(String userId) throws Exception;
}
