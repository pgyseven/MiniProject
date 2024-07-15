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
    let baseUrl = 'https://api.openweathermap.org/data/2.5/weather?appid=' + apiKey + "&q=seoul&units=metric";

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
                outputWeather(data)

            }, error : function() {  // 비동기 통신에 실패하면 자동으로 호출될 callback function

            }, complete : function() { //통신이 성공/ 실패 여부에 상관없이 마지막에 호출될 callback function
                
            }
        });


    }
//날씨 json data를 parsing 하여 출력
function outputWeather(data){
    let cityName = data.name;
    $('#cityName').html(cityName);
    let dt = new Date(data.dt).toLocaleString();  //우리나라 시간형식으로 문자열로 바꿔줌
    $('#outputTime').html("출력시간 : " + dt);
    $('.curWeather').html(data.weather[0].main);
    $('.curTemp').html(data.main.temp);

    $('.temp_max').html(data.main.temp_max);
    $('.temp_min').html(data.main.temp_min);
    $('.sppedDeg').html("풍속 : " + data.wind.speed + " 풍향 : " +  data.wind.deg);
    $('.sunrise').html(new Date(data.sys.sunrise).toLocaleString()); 
    $('.sunset').html(new Date(data.sys.sunset).toLocaleString());

    $('.weatherIcon').html("<img src = 'https://openweathermap.org/img/wn/" + data.weather[0].icon + "@5x.png'/>");

    $('#showRange').html(data);


}

</script>



</head>
<body>
	<div class="container">
		<c:import url="./header.jsp"></c:import>

		<div class="content">
			<h1><span id="cityName"></span> 지역의 오늘 날씨</h1>
            <div id="outputTime"></div>
			<div class="weatherInfo">
                <div class="curWeather"></div>
                <div class="curTemp"></div>
                <div class="weatherIcon"></div>
                <h2> 상세 날씨 (description)</h2>
                <div class="temp_max"></div>
			    <div class="temp_min"></div>
                <div class="sppedDeg"></div>
                <div class="sunrise"></div>
                <div class="sunset"></div>
            </div>

		</div>

		<c:import url="./footer.jsp"></c:import>
</body>
</html>