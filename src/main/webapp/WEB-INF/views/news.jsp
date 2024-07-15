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
	<script>

		function getNewsData() {
			$.ajax({
         url : 'https://mbn.co.kr/rss/enter/',             // 데이터가 송수신될 서버의 주소
         type : 'GET',             // 통신 방식 : GET, POST, PUT, DELETE, PATCH   
         dataType : 'xml',         // 수신 받을 데이터의 타입 (text, xml, json)
         success : function (data) {     // 비동기 통신에 성공하면 자동으로 호출될 callback function
            console.log(data);
			outputNews(data);
            
         }

      });
   }
function outputNews(data) {
	// getElementById //id 속성으로 태그(단수)를 업어오는 메서드 
	// getElementsByClassName() // class 속성으로 태그(복수)를 얻어오는 메서드

	let channel = data.getElementsByTagName('channel')[0];  //태그명으로 태그를 업어오는(복수) 메서드 / 태그이름을 주면 그 태그를 얻어온다. / 복수는 배열로 담아온다. 
	console.log(channel);
	//xml 에서의 문자열 주석처리 한것을 다시 처리해야 출력됨
	//let title = channel.getElementsByTagName('title')[0].innerHTML.replace("<![CDATA[","");
	let title = channel.getElementsByTagName('title')[0].textContent; //참고로 웹브라우저 버전에 따라서 낮으면 안보일수 있다.
	//title = title.replace("]]>","")
	$('.title').html(title); //innerHTML 대신 textContent로 받아와도 된다. <![CDATA[MBN : 연예기사]]> 지금 이게 주석 처리된거라 그냥은 안보임 replace 치환하다
	

	let newsLink = channel.getElementsByTagName('link')[0].innerHTML;

	//$('#newsLink');아래랑 같은거다 그래서 제이쿼리가 편한거다.
	//document.getElementById('newsLink')

	$('#newsLink').attr('href', newsLink);
let description = removeCDATA(channel.getElementsByTagName('description')[0].innerHTML);
$('.desc').html(description);

let items = channel.getElementsByTagName('item');
console.log(items); //배열이 보일것임
// $.each와 부트스트랩의 list group을 이용하여 출력하여 보시오

let output = '';
$.each(items, function(i, e){

    output += '<div class="card">';
	let title =	removeCDATA($(e).children().eq(0).html()); //jquery 인덱스는 eq로 쓴다.
	output += `<div class="card-body" data-bs-toggle="collapse" data-bs-target="#demo\${i}">\${title}</div>`; //타이틀은 자바 스크립트임 el 아님 \이걸 붙이는건 자바에서 실행안되고 자바 스크립트에서 실행되게 백틱으로 묶어주는게 새로나옴 백틱은 1옆에 특수 기호 이렇게 할수 있지만  output += '<div class="card-body">' + title+ '</div>' 
	let desc = removeCDATA($(e).children().eq(3).html());
	output += `<div id="demo\${i}" class="collapse">\${desc}</div>`;
	output += '<div>'

		$('.newsList').html(output);
});




}

function removeCDATA(str){
str = str.replace("<![CDATA[","");
return str.replace("]]>","");

}


$(function(){

	getNewsData();
});

	</script>
	<style>
		.collapse {
			padding : 8px;
			font-size: 0.8em;
		}
	</style>
</head>
<body>
	<div class="container">

		<c:import url="./header.jsp"></c:import>
	
		<div class="content">
			<h1>news.jsp</h1>
			<a id='newsLink'><h3 class="title"></h3></a>
			<h6 class="desc"></h6>
			<div class="newsList"></div>

		
</div>

		
		<c:import url="./footer.jsp"></c:import>
	
</body>
</html>