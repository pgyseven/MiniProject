<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>박스오피스</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script>
   
    let now = new Date();
    let formattedDate = now.toISOString().slice(0, 10).replace(/-/g, '');
    let boxApiKey = '212b91c38ff2a760ae151153c78d580f';
    let boxBaseUrl = 'https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=' + boxApiKey + '&targetDt=' + formattedDate;

    function boxOffice() {
        $.ajax({
            url: boxBaseUrl,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                console.log(data);
                outputBoxOffice(data);
            },
            error: function() {
                console.error('Failed to fetch box office data');
            }
        });
    }

    function outputBoxOffice(data) {
        $.each(data.boxOfficeResult.dailyBoxOfficeList, function(index, item) {
            $('.rank' + index).html(item.rank);
            $('.movieNm' + index).html(item.movieNm);
            fetchMovieImage(item.movieNm, index);
        });
    }

    function fetchMovieImage(movieName, index) {
        let apiKey = 'ec0feabd27fc416bb6711d62663597be'; // Bing Image Search API 키
        let searchUrl = 'https://api.bing.microsoft.com/v7.0/images/search?q=' + encodeURIComponent(movieName) + '&count=1';

        $.ajax({
            url: searchUrl,
            type: 'GET',
            headers: {
                'Ocp-Apim-Subscription-Key': apiKey
            },
            dataType: 'json',
            success: function(data) {
                if (data.value && data.value.length > 0) {
                    let imageUrl = data.value[0].contentUrl;
                    $('.movieImg' + index).html('<img src="' + imageUrl + '" alt="' + movieName + ' 이미지" width="100" onerror="this.onerror=null;this.src=\'/path/to/default/image.jpg\';" />');
                } else {
                    $('.movieImg' + index).html('<img src="/path/to/default/image.jpg" alt="이미지 없음" width="100" />');
                }
            },
            error: function() {
                console.error('Failed to fetch movie image');
                $('.movieImg' + index).html('<img src="/path/to/default/image.jpg" alt="이미지 없음" width="100" />');
            }
        });
    }
</script>
</head>
<body>
    <div class="container">
        <c:import url="./header.jsp"></c:import>

        <div class="content">
            <div id="boxoffice"></div>
            <h1><span id="showRange"></span> 일별 박스오피스</h1>
            <div>순위</div>

            <c:forEach var="i" begin="0" end="9">
                <div>
                    <span class="rank${i}"></span> <span class="movieNm${i}"></span> <span class="movieImg${i}"></span>
                </div>
            </c:forEach>
        </div>

        <c:import url="./footer.jsp"></c:import>
    </div>
</body>
</html>
