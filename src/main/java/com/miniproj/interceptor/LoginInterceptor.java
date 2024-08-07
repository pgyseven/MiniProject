package com.miniproj.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.miniproj.model.MemberVO;
import com.mysql.cj.util.StringUtils;

//직겁 로그인을 하는 동작과정을 인터셉터로 구현 / 지금 우린 리퀘스트 매핑의 벨류는 같고 전송 방식만 다른경우 있는데 인터셉터는 포스트인지 겟인지 구분하는 다른 기능은 없다 그러나
// get 방식으로 요청된건지, post 방식으로 요청되어서 인터셉터가 동작하는지를 구분해야한다.
public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
	
		System.out.println("loginIntercepror 의 prehandel호출 ~~~~~~~~~~~~~");
		// 이미 로그인이 되어있는 경우에는 로그인 페이지를 보여줄 필요가 없다.
		// 로그인이 되어 있지 않은 경우에만 로그인 페이지를 보여줘야 한다.
		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		
		
		
		

		if (request.getMethod().toUpperCase().equals("POST")) { // POST 방식으로 호출 했을 때만 실행되도록
			System.out.println("loginIntercepror 의 posthandle호출 ~~~~~~~~~~~~~");
			super.postHandle(request, response, handler, modelAndView);
			Map<String, Object> model = modelAndView.getModel();
			MemberVO loginMember = (MemberVO) model.get("loginMember");
			if (loginMember != null) {
				System.out.println("[loginIntercepror... postHandle() : 로그인 성공]");
				// 세션에 로그인한 유저의 정보를 넣어주었다..
				HttpSession ses = request.getSession();
				ses.setAttribute("loginMember", loginMember);
				//홈
				//response.sendRedirect("/"); // 이건 그닥 좋은 방법이 아니다. 이건 뷰만 호출하는 형식이다 즉 리다이렉트라는 이름과 다르게 포워딩이 아니라 컨트롤러단을 거치지 않고 이동시킴 그럼 c:이 문법 자체를 못이해해서 에러남

//				if(ses.getAttribute("destPath") != null) { //사실 무조건 넣어서 널일 가능성 거의 없다 하지만 이렇게 한다고 하신다.
//					response.sendRedirect((String)ses.getAttribute("destPath")); 
//				}else {
//					response.sendRedirect("/");
//				}
				
				Object tmp = ses.getAttribute("destPath");
				response.sendRedirect((tmp == null) ? "/" : (String)tmp);
			} else {
				System.out.println("[loginIntercepror... postHandle() : 로그인 실패]");
				response.sendRedirect("/member/login?status=fail"); // 시스템 아웃보다 우선 순위가 높다
			} 
		}
	}
	
}
