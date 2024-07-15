<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<nav class="navbar navbar-expand-sm navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="javascript:void(0)">MiniProject</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mynavbar">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="mynavbar">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link" href="/hboard/listAll">계층형 게시판</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="javascript:void(0)">댓글형 게시판</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="javascript:void(0)">회원가입</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/weather">오늘의 날씨</a>
        </li>
         <li class="nav-item">
          <a class="nav-link" href="/movie">박스 오피스 이미지</a>
        </li>
         <li class="nav-item">
          <a class="nav-link" href="/movieTwo">박스 오피스</a>
        </li>
      </ul>
      <form class="d-flex">
        <input class="form-control me-2" type="text" placeholder="Search">
        <button class="btn btn-primary" type="button">Search</button>
      </form>
    </div>
  </div>
</nav>
</body>
</html>