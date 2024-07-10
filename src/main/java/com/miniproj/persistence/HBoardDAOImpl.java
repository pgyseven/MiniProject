package com.miniproj.persistence;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.miniproj.model.HBoardVO;

@Repository //아래의 클래스가 DAO 객체임을 명시
public class HBoardDAOImpl implements HBoardDAO {
// Impl 구현하다 implement
	
	//루트다시 컨텍스트 아래 소스에 써둔 sqlsession 불러오는것
	@Autowired
	private SqlSession ses;
	
	private static String NS = "com.miniproj.mapper.hboardmapper";
	
	@Override
	public List<HBoardVO> selectAllBoard() {
		System.out.println("여기는 HBoard ...................");
		
		List<HBoardVO> list = ses.selectList(NS + ".getAllHBoard");
		
//		for(HBoardVO b : list) {
//			System.out.println(b.toString());
//		}
		return list;
		
		
		
		
	}

}
