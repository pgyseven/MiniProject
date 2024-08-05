package com.miniproj.controller.member;

import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.miniproj.model.MemberVO;
import com.miniproj.model.MyResponseWithoutData;
import com.miniproj.service.member.MemberService;
import com.miniproj.util.SendMailService;
import com.mysql.cj.util.StringUtils;

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
	      
	      System.out.println(userProfile.getOriginalFilename());
	      
	      // 1) 회원 데이터를 db에 저장(프로필 파일이름 : 유저아이디.유저가 올린 파일의 확장자)
	      // 2) 가입한 회원에게 100포인트 부여
	      // 3) 업로드한 프로필 사진이 있다면 파일 저장
	      // (게시판 첨부 파일 : 저장경로에 년월일 폴더를 생성 ->  중복된이름인지 검사해서 새로운 파일이름
	      // -> 이미지인지 아닌짐 검사 이미지면 base64, 썸네일 저장
	      // 회원 프로필 파일 : 저장경로에 -> 파일 이름 : 유저아이디.유저가 올린 파일의 확장자(이러면 유니크할거다) -> 저장 -> base64, 썸네일 저장
	      
	      
	      // 4) 홈으로 이동
	      
	      //(프로필 파일이름 : 유저아이디.유저가 올린 파일의 확장자) - 유저가 프로필 파일을 업로드 했을 떄
	      String tmpUserProfileName = userProfile.getOriginalFilename();
	      if(StringUtils.isNullOrEmpty(tmpUserProfileName)) {
	    	  String ext = tmpUserProfileName.substring(tmpUserProfileName.lastIndexOf(".") + 1);
		      registMember.setUserImg(registMember.getUserId() + "." + ext);
		      
	      }
	      
	      System.out.println("회원가입 진행~~~~~~~~~~~~~~~~" + registMember.toString());
	      
	      
	      mService.saveMember(registMember);
	      
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
	
	//스프링은 지가 혼자 알아서 싱글톤으로 객체 하나만 가지고 돌려 쓸 수 있도록 해줌 회사가서 스프링 같은거 안쓰는데서 new 다오 임플 이런거 하면 안됨
	@RequestMapping(value = "/callSendMail")
	public ResponseEntity<String> sendMailAuthCode(@RequestParam("tmpUserEmail") String tmpUserEmail, HttpSession session) { //리스폰스 엔티티는 담으면 제이슨으로 변하고 큰데이터를 주기 편하나 지금 같이 간단히 보낼때는 스트링으로
		String authCode = UUID.randomUUID().toString();
		System.out.println(tmpUserEmail + "로 " + authCode + "를 보내자~");
		
		String result = "";
		
		try {
			//new SendMailService().sendMail(tmpUserEmail, authCode); // 실제 메일 발송 이것만 주석하면 안보내짐
			session.setAttribute("authCode", authCode); // 인증 코드를 세션 객체에 저장
			
			result = "success";
			
			
		}  catch (Exception e) {
			
			e.printStackTrace();
			result = "fail";
		}
	
		return new ResponseEntity<String>(result, HttpStatus.OK);
		
	}
	
	@RequestMapping("/checkAuthCode")
	public ResponseEntity<String> checkAuthCode(@RequestParam("tmpUserAuthCode") String tmpUserAuthCode, HttpSession session){
		System.out.println(tmpUserAuthCode + "와 세션에 있는 인증 코드가 같은지 비교하자.");
		
		String result = "fail";
		
		if (session.getAttribute("authCode") != null ) {
			String sesAuthCode = (String)session.getAttribute("authCode");
			
			if(tmpUserAuthCode.equals(sesAuthCode)) {
				result = "success";
			}
		}
		return new ResponseEntity<String>(result, HttpStatus.OK);
	}
	@RequestMapping("/clearAuthCode")
	   public ResponseEntity<String> clearCode(HttpSession session) {
	      if (session.getAttribute("authCode") != null) {
	         session.removeAttribute("authCode");  // attribute 속성을 지운다...
	      }
	      
	      return new ResponseEntity<String>("success", HttpStatus.OK);
	   }
}
