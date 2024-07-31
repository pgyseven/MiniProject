package com.miniproj.service.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.miniproj.persistence.MemberDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor // final한 멤버 mDao에게 생성자를 통해 객체를 주입하는 방식
public class MemberServiceImpl implements MemberService {
	//@Autowired //자동주입
	private final MemberDAO mDao; //final 상수 불변 private final MemberDAO mDao; 이렇게만 쓰면 초기화 안된다고 에러뜸 그래서 위에서 @RequiredArgsConstructor
	
	
//	public void setMemberDAO(MemberDAO mdao) {
//		this.mDao = mdao; //세터를 이용해서 필요한걸 주입해서 DAO 단을 테스트 하기도 한다.
//	}
	
	@Override
	public boolean idIsDuplicate(String tmpUserId) throws Exception {
		boolean result = false;
		 if(mDao.selectDuplicateId(tmpUserId) == 1) {
			 result = true; // 중복된다.
		 }
		
		
		return result;
	}

}
