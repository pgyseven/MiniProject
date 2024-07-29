<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>회원 가입 페이지</title>
</head>
<body>
	<c:import url="../header.jsp" />

	<div class="container">
		<h1>회원가입페이지</h1>

		<form method="post" action=""></form>
			<div class="mb-3 mt-3">
				<label for="userId" class="form-label">아이디: </label> <input
					type="text" class="form-control" id="userId"
					placeholder="아이디를 입력하세요..." name="userId" />
			</div>

			<div class="mb-3 mt-3">
				<label for="userPwd1" class="form-label">패스워드: </label> <input
					type="password" class="form-control" id="userPwd1"
					placeholder="비밀번호를 입력하세요..." name="userPwd" />
			</div>

			<div class="mb-3 mt-3">
				<label for="userPwd1" class="form-label">패스워드 확인: </label> <input
					type="password" class="form-control" id="userPwd2"
					placeholder="비밀번호를 확인하세요..." />
			</div>

			<div class="mb-3 mt-3">
				<label for="userEmail" class="form-label">이메일: </label> 
				<input type="text" class="form-control" id="userEmail" name="userEmail" />
			</div>

<div class="form-check">
  <input type="radio" class="form-check-input" id="radio1" name="optradio" value="option1" checked>남성
  <label class="form-check-label" for="radio1"></label>
</div>
<div class="form-check">
  <input type="radio" class="form-check-input" id="radio2" name="optradio" value="option2">여성
  <label class="form-check-label" for="radio2"></label>
</div>

			<div class="mb-3 mt-3">
				<label for="mobile" class="form-label">휴대전화: </label> <input
					type="text" class="form-control" id="mobile"
					placeholder="전화번호를 입력하세요..." name="userMobile" />
			</div>

			<div class="mb-3 mt-3">
				<label for="memberProfile" class="form-label">회원 프로필: </label> <input
					type="file" class="form-control" id="userProfile"
					name="memberProfile" />
					
					
			</div>


			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="agree"
					name="agree" value="Y" /> <label class="form-check-label">회원
					가입 조항에 동의합니다</label>
			</div>

			<!-- form 태그는 항상 submit / reset 버튼과 함께 사용 -->
			<input type="submit" class="btn btn-success" value="회원가입" /> <input
				type="reset" class="btn btn-danger" value="취소" />
		</form>

	</div>

	<c:import url="../footer.jsp" />
</body>
</html>