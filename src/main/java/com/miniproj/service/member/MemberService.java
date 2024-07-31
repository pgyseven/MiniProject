package com.miniproj.service.member;

public interface MemberService {
	// 아이디 중복 여부 검사 메서드
	boolean idIsDuplicate(String tmpUserId) throws Exception;
}
