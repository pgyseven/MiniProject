<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비동기 데이터 통신을 이용하여 xml 파일을 전송받아 파싱하여 출력해 보자</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
	<div class="container">
		<!-- 여백에 조정 될거임 -- header 좌우 여백 생김 -->
		<c:import url="./header.jsp"></c:import>
		<!-- 경로에 있는 파일을 가져와서 넣어라 그리고 상대적 경로니깐 같은 위치에 있는 헤더 가져오는거라 -->

		<div class="content">
			<h1>news.jsp</h1>
		</div>
		<c:import url="./footer.jsp"></c:import>
		<!--  ./ 현재 경로의  -->
</body>
</html>