package com.miniproj.persistence;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAOImpl implements MemberDAO {

	@Autowired
	private SqlSession ses;
	
	private static String NS = "com.miniproj.mapper.membermapper";
	//스태틱하지 않은건 객체가 있어야 호출해야함
	//static은 공유 그클래스에서 만들어진 객체들이 다 공유한다는 의미에서
	
	@Override
	public int updateUserPoint(String userId) throws Exception {
		
		return ses.insert(NS + ".updateUserPoint", userId);
	}

	@Override
	public int selectDuplicateId(String tmpUserId) throws Exception {
		
		return ses.selectOne(NS + ".selectUserId", tmpUserId);
	}

}
