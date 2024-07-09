<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<div class="container">  <!-- 여백에 조정 될거임 -- header 좌우 여백 생김 --> 
<c:import url="./header.jsp"></c:import> <!-- 경로에 있는 파일을 가져와서 넣어라 그리고 상대적 경로니깐 같은 위치에 있는 헤더 가져오는거라 -->

<div class="content"><h1>home.jsp</h1></div>
<c:import url="./footer.jsp"></c:import>  <!--  ./ 현재 경로의  -->
</div>
</body>
</html>
