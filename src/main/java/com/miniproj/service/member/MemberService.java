package com.miniproj.service.member;

import com.miniproj.model.MemberVO;

public interface MemberService {
	// 아이디 중복 여부 검사 메서드
	boolean idIsDuplicate(String tmpUserId) throws Exception;
	
	// 회원가입하는 메서드
	boolean saveMember(MemberVO registMember) throws Exception;
	
	
}
