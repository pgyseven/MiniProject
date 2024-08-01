package com.miniproj.controller.member;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.miniproj.model.MemberVO;
import com.miniproj.model.MyResponseWithoutData;
import com.miniproj.service.member.MemberService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor //생성자를 만들때 필요할때 받아온다. 스프링이 얘를 불러와서 mService; 하고나서 MemberController
public class MemberController {

	private final MemberService mService;
	
	@RequestMapping("/register")
	public void showRegisterForm() {
		
	}
	@RequestMapping(value="/register", method = RequestMethod.POST)
	   public void registerMember(MemberVO registMember, @RequestParam("userProfile") MultipartFile userProfile) {
	      System.out.println("회원가입 진행~~~~~~~~~~~~~~~~" + registMember.toString());
	      System.out.println(userProfile.getOriginalFilename());
	   }
	
	
	
	@RequestMapping(value="/isDuplicate", method = RequestMethod.POST, produces = "application/json; charset=UTF-8;")
	public ResponseEntity<MyResponseWithoutData> idIsDuplicate(@RequestParam("tmpUserId") String tmpUserId) {
		
		System.out.println(tmpUserId + "  가 중복되는지 확인");
		
		
		MyResponseWithoutData json = null;
		ResponseEntity<MyResponseWithoutData> result = null;
		
		try {
			
			if(mService.idIsDuplicate(tmpUserId)) {
				//아이디가 중복된다.
				json = new MyResponseWithoutData(200, tmpUserId, "duplicate");
				
				
			}else {
				// 아이디가 중복되지 않는다.
				json = new MyResponseWithoutData(200, tmpUserId, "not duplicate");
			}
			result = new ResponseEntity<MyResponseWithoutData>(json, HttpStatus.OK);
			
		} catch (Exception e) {
			
			e.printStackTrace();
			result = new ResponseEntity<>(json, HttpStatus.CONFLICT);
		}
		return result;
	}
	
	
	
	
	
	
	
	
}
