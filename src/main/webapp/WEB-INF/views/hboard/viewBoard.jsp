<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
   <title>상세보기</title>
</head>
<body>
   <div class="container"> <!-- margin을 넣은거 -->
      <c:import url="../header.jsp"></c:import>
      
      <div class="content">
         <h1>게시글 상세 페이지</h1>
         
         <div>${boardDetailInfo}</div>
         
      </div>
      
      <c:import url="../footer.jsp"></c:import>
   </div>
</body>
</html>
