<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	
	<script>
		function validBoard() { //$function은 로드가 다되고 실행되는데 여기서 사용을 안하는 이유는 페이지가 다 뜨고 클릭을 해야 함수가 작동하기에 $function이 필요 없다.
			let result = false;
			let title =  $('#title').val();
			console.log(title);

			if (title == '' || title.length < 1 || title == null) { // || or
				// 제목을 입력하지 않았을때
				alert("제목은 반드시 입력하셔야 합니다.");
				$('#title').focus();
			} else {

				// 제목을 입력했을 때
				result = true;
			}
			
			// 유효성 검사 하는 자바스크립트에서는 마지막에 boolean 타입의 값을 반환하여
			// 데이터가 백엔드 단으로 넘어갈지 말지늘 결정해줘야 한다.
			return true;
		}

	</script>
</head>
<body>
	<div class="container">
		<c:import url="./../header.jsp"></c:import>
		<h2>게시글 작성</h2>
		<form action="saveBoard" method="POST">   <!-- 데이터 양이 많으니 포스트 방식으로 보낸다 만약 겟방식이면 url에 쿼리 스트링 형식으로 보내진다. 그러면 내용때문에 url의 길이 제한 때문에 문제 생긴다 정확히 2083자까지만 가능하다. --> 
			<div class="mb-3">
				<label for="title" class="form-label">글제목</label> <input type="text"
					class="form-control" id="title" name="title" placeholder="글제목을 입력하세요">
			</div>
			<div class="mb-3">
				<label for="author" class="form-label">작성자</label> <input
					type="text" class="form-control" id="writer" name="writer"
					placeholder="작성자를 입력하세요">
			</div>
			<div class="mb-3">
				<label for="content" class="form-label">내용</label>
				<textarea class="form-control" id="content" name="content" rows="5"
					placeholder="내용을 입력하세요"></textarea>
			</div>
			<button type="submit" class="btn btn-primary" onclick="return validBoard();">저장</button> <!-- 이벤트 캔슬링과 같다 리턴해오는 값에 따라서 서밋을 할지 말지!!!return validBoard()뒤에서 가저온 함수를 리턴으로 보낸다 위에서 return 값을 false로하면 결국 false 가 가니깐 즉 서밋하면 false가 가서 너 그기능 하지마! 이게 되는 거임 true 면 할 행동을 하게됨 -->
		</form>
		
		<c:import url="./../footer.jsp"></c:import>
	</div>

</body>
</html>