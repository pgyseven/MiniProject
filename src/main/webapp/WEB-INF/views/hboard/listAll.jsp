<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(function(){

		showModalAccordingToStatus();

		timediffPostDate(); // 함수 호출

		// 클래스가 modalCloseBtn 태그를 클릭하면 실행되는 함수  
		    $('.modalCloseBtn').click(function(){  // onclick과 같은 함수 click
		    	$("#myModal").hide(); //태그를 화면에서 감춤
		    }); // 클릭하면 이 함수가 실행된다. 

		


	}); // 웹 문서가 로딩 완료되면 현재의 함수를 실행하도록 한다 window.onload = function 웹브라우즈 로딩이 완료되면 실행해라라는 즉 웹문서 로딩이 완료후 실행되어라
	

	// 데이터 로딩 상태에 따라 모달창을 띄우는 함수
	function showModalAccordingToStatus(){
		let status = '${param.status}'; // url 주소창에서 status 쿼리스트링 값을 가져와 변수 저장
		console.log(status); //자바스크릅트에러는 크롬등 창에서 콘솔을 보아라

		if (status == 'success') {
			//글 저장 성공 모달창을 띄움
			$('.modal-body').html('<h5>글 저장 성공하였습니다.</h5>');
			$('#myModal').show();  //제이커리문

		} else if (status == 'fail') { //참고로 경우의 수 -1 개의 if 문을 만들어야 하는거 잊지마라 마지막에 else
			//글 저장 실패 모달창을 띄움
			$('.modal-body').html('<h5>글 저장 실패하였습니다.</h5>');
			$('#myModal').show();  //제이커리문
		}

			//게시글을 불러올때 예외가 발생했거나 데이터가 없을때
		let except = '${exception}'
		// boardList = '${boardList}'; 이렇게 하고 아래 if 문을 if (boardList == '') 이렇게 하면 글 내용에 자바스크립트 허용 안하는 문구 있다고 에러뜸
		if (except == 'error') {
			$('.modal-body').html('<h5>게시글이 없거나 문제가 발생해 데이터를 불러오지 못했습니다.</h5>');
			$('#myModal').show();  //제이커리문

		}

	}




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

			<!-- choose if와 else 합친거랑 생각해라 when 이 if -->
			<c:choose>
				<c:when test="${boardList != null}">
					<table class="table table-hover">
						<thead>
							<tr>
								<th>#</th>
								<th>title</th>
								<th>writer</th>
								<th>postDate</th>
								<th>readCount</th>
<!-- 								<th>ref</th>
								<th>step</th>
								<th>refOrder</th> -->
							</tr>
						</thead>
						<tbody>
							<c:forEach var="board" items="${boardList}">
								<tr onclick="location.href='/hboard/viewBoard?boardNo=${board.boardNo}';" class="table-primary">
									<td>${board.boardNo}</td>
									<td>
									<c:forEach var="i" begin="1" end="${board.step }"> <!-- step 이란걸 주면 증감의 정도도 설정 가능 -->
									<img src="/resources/images/reply.png" />
									</c:forEach>
									${board.title}</td>
									
									<td>${board.writer}</td>
									<td class="postDate">${board.postDate}</td>
									<td>${board.readCount}</td>
<%-- 									<td>${board.ref}</td>
									<td>${board.step}</td>
									<td>${board.refOrder}</td> --%>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:when>
				
				
				<%-- <c:when test="${boardList == null and exception == 'error'}">
				           <!-- The Modal -->
               <div class="modal" id="myModal" style="display: block;">
                  <div class="modal-dialog">
                     <div class="modal-content">

                        <!-- Modal Header -->
                        <div class="modal-header">
                           <h4 class="modal-title">MiniProject</h4>
                           <button type="button" class="btn-close modalCloseBtn" data-bs-dismiss="modal"></button>
                        </div>

                        <!-- Modal body -->
                        <div class="modal-body">문제가 발생하여 데이터를 가져오지 못했습니다!</div>

                        <!-- Modal footer -->
                        <div class="modal-footer">
                           <button type="button" class="btn btn-danger modalCloseBtn"
                              data-bs-dismiss="modal">Close</button>
                        </div>

                     </div>
                  </div>
               </div>
            </c:when> --%>
            
            
         </c:choose>



		</div>
		<div>
			<button type="button" class="btn btn-primary"
				onclick="location.href='/hboard/saveBoard';">글 저장</button>
		</div>

				           <!-- The Modal -->
						   <div class="modal" id="myModal" style="display: none;">
							<div class="modal-dialog">
							   <div class="modal-content">
		  
								  <!-- Modal Header -->
								  <div class="modal-header">
									 <h4 class="modal-title">MiniProject</h4>
									 <button type="button" class="btn-close modalCloseBtn" data-bs-dismiss="modal"></button>
								  </div>
		  
								  <!-- Modal body -->
								  <div class="modal-body"></div>
		  
								  <!-- Modal footer -->
								  <div class="modal-footer">
									 <button type="button" class="btn btn-danger modalCloseBtn"
										data-bs-dismiss="modal">Close</button>
								  </div>
		  
							   </div>
							</div>
						 </div>

		<c:import url="./../footer.jsp"></c:import>

	</div>
</body>
</html>