<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오늘의 날씨</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js">

</script>

<script>
	let apiKey = '78b5042686fed414f4e8721787f72530';
    let baseUrl = 'https://api.openweathermap.org/data/2.5/weather?appid=' + apiKey + "&q=seoul&unit=metric";

$(function(){
    getWeatherData();
});
    function getWeatherData() {
        $.ajax({   //자바스크립에서는  {}는 객체로 여긴다.
            url : baseUrl,    //데이터가 송수신될 서버의 주소
            type : 'GET',     // 통신방식 : GET, POST, PUT, DELETE, PATCH
            dataType : 'json',       // 수신받을 데이터의 타입(text,xml,json)
                                    // 서버에 보낼게 있으면 date 속성을 추가하면된다.
            success : function(data) { // 이런 형식은 이름 없는 함수 즉 익명함수 에나니머스 펑션 성공하면 호출되게! 했으니깐 이름이 필요가 없음 비동기 통신에 성공하면 자동으로 호출될 callback function
                console.log(data);
            }, error : function() {  // 비동기 통신에 실패하면 자동으로 호출될 callback function

            }, complete : function() { //통신이 성공/ 실패 여부에 상관없이 마지막에 호출될 callback function
                
            }
        });


    }



</script>
</head>
<body>
	<div class="container">
		<c:import url="./header.jsp"></c:import>

		<div class="content">
			<h1>오늘의 날씨</h1>
			<div class="weatherInfo"></div>
		</div>

		<c:import url="./footer.jsp"></c:import>
</body>
</html>