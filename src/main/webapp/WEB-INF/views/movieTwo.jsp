<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link
   href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
   rel="stylesheet">
<script
   src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
   // 8344c161e851343f33ceb78f3de3fc62
   // 기본적인 박스오피스를 가져올 날짜는 현재날짜 - 1일을 가져오게 한다
   let now = new Date();
   console.log(now);
   now.setDate(now.getDate() - 1);
      // 2024. 7. 14. => 20240714 형식으로 변환
   let targetDt = toTargetDt(now.toLocaleDateString());
   
   $(function(){
      getMovieApi(targetDt);

      $('#selecDate').change(function(){
         // alert('선택한 태그의 값이 변경됨 : ' + $(this).val());
         let selectDate = new Date($(this).val());

         let targetDt = toTargetDt(selectDate.toLocaleDateString());
         console.log(targetDt);
         getMovieApi(targetDt);
      });
   });

   function toTargetDt(now) {
      let dateArr = now.split('.');
      let targetDt = '';
      for (let i = 0; i < 3; i++) {
         targetDt = dateArr[0].trim();
         if (parseInt(dateArr[1]) < 10) {
            targetDt += '0' + dateArr[1].trim();
         } else {
            targetDt += dateArr[1].trim();
         }
         if (parseInt(dateArr[2]) < 10) {
            targetDt += '0' + dateArr[2].trim();
         } else {
            targetDt += dateArr[2].trim();
         }
         
      }

      console.log('변환된 값 : ' + targetDt);
      return targetDt;
   }



   function getMovieApi(targetDt) {
      let baseUrl = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=212b91c38ff2a760ae151153c78d580f&targetDt=" + targetDt;
      $.ajax({
         url : baseUrl,             // 데이터가 송수신될 서버의 주소
         type : 'GET',             // 통신 방식 : GET, POST, PUT, DELETE, PATCH   
         dataType : 'json',         // 수신 받을 데이터의 타입 (text, xml, json)
         success : function (data) {     // 비동기 통신에 성공하면 자동으로 호출될 callback function
            console.log(data);
            outputMovie(data);
         }

      });
   }


   function outputMovie(data) {
      $('.title').html(data.boxOfficeResult.boxofficeType);
      $('.outputDate').html("집계 일자 : " + data.boxOfficeResult.showRange);

      let output = '<div class="list-group">';
      $.each(data.boxOfficeResult.dailyBoxOfficeList, function(i, e){
         console.log(e);
         output += '<a href="#" class="list-group-item list-group-item-action">' + e.movieNm + '</a>';
      });

      output += "</div>";

      $('.boxOffice').html(output);
   }
   
</script>
</head>
<body>
   <div class="container">
      <c:import url="./header.jsp" />

      <div class="content">
         <h1>movie.jsp</h1>

         <h5 class="title"></h5>
         <h6 class="outputDate"></h6>

         <div style="margin-top: 15px; margin-bottom: 15px;">
            <input type="date" class="form-control" id="selecDate">
         </div>

         <div class="boxOffice">
            
         </div>
      </div>

      <c:import url="./footer.jsp" />
   </div>
</body>
</html>