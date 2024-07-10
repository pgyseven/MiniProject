<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(function(){
		
		timediffPostDate(); // 함수 호출

		


	}); // 웹 문서가 로딩 완료되면 현재의 함수를 실행하도록 한다 window.onload = function 웹브라우즈 로딩이 완료되면 실행해라라는 즉 웹문서 로딩이 완료후 실행되어라
	
	//게시글의 작성일을 얻어와 2시간 이내에 작성한 글이라면 new.png 이미지를 제목 앞에 붙여 출력한다.
	function timediffPostDate(){
		$(".postDate").each(function(i, e){
			//console.log(i + '번째 태그 : ' + $(e).html() );
			let postDate = new Date($(e).html()); // 글 작성일 저장 (Date 객체로 변환 후)
			let curDate = new Date(); // 현재 날짜 현재 시간 객체 생성
			console.log(postDate, curDate);
			// 아래의 시간 차이는 timestamp 값(1970년 1월1일0시0분0초 부터 지금까지 흘러온 시간을 정수로 표현한값) 타임 스탬프는 정수값으로 나오며 ms 단위로 나온다. 
			// 단위는 ms 이므로 시간 차이로 바꾸면  / 밀리를 시간으로 하려면 / 1000 / 60 / 60  씩 해서 초를 분으로 분을 초로 이런식으로 /24로 붙이면 하루 단위
			let diff = (curDate - postDate) / 1000 / 60 / 60 ;  // 시간 차이
			console.log(diff);

			let title = $(e).prev().prev().html(); // e는 td 태그는 자체다 prev는 이전 태그 이렇게 하면 타이틀 태그 자체 쉽게 이해하기 위해 .html은 해당 값~ 이라고 이해
			//html() 이너 html 속성에 아무것도 없으면 getter와 같고 있으면 setter와 같다 아래 처럼 html(output + title)
			console.log(title);

			if(diff < 2) { // 2시간 이내에 작성한 글 이라면...
				// 글 제목 앞에 new 이미지 태그를 넣어 출력
				let output = "<span><img src='/resources/images/new.png' width='50px' /></span>";
				$(e).prev().prev().html(output + title);
				
			}

		});
	}
</script>
</head>
<body>
	<div class="container">

		<c:import url="./../header.jsp"></c:import>


		<div class="content">
			<h1>계층형 게시판 전체 리스트 페이지</h1>

			

			<table class="table table-hover">
				<thead>
					<tr>
						<th>#</th>
						<th>title</th>
						<th>writer</th>
						<th>postDate</th>
						<th>readCount</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="board" items="${boardList}">
						<tr class="table table-hover">
							<td>${board.boardNo}</td>
							<td>${board.title}</td>
							<td>${board.writer}</td>
							<td class="postDate">${board.postDate}</td>
							<td>${board.readCount}</td>
							
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	<div>
	<button type="button" class="btn btn-primary">글 저장</button>
	</div>
	
		<c:import url="./../footer.jsp"></c:import>

	</div>
</body>
</html>