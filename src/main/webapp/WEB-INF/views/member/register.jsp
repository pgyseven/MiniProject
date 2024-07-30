<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	
	
	<script language="javascript">
function getAddr(){
	// 적용예 (api 호출 전에 검색어 체크) 	
	if (!checkSearchedWord(document.form.keyword)) {
		return ;
	}

	$.ajax({
		 url :"https://business.juso.go.kr/addrlink/addrLinkApiJsonp.do"  //인터넷망
		,type:"post"
		,data:$("#form").serialize()
		,dataType:"jsonp"
		,crossDomain:true
		,success:function(jsonStr){
			$("#list").html("");
			var errCode = jsonStr.results.common.errorCode;
			var errDesc = jsonStr.results.common.errorMessage;
			if(errCode != "0"){
				alert(errCode+"="+errDesc);
			}else{
				if(jsonStr != null){
					makeListJson(jsonStr);
					 $("#list").css('display', 'block');
				}
			}
		}
	    ,error: function(xhr,status, error){
	    	alert("에러발생");
	    }
	});
}

function makeListJson(jsonStr){
	var htmlStr = "";
	htmlStr += "<table><tr><th>도로명</th><th>지번주소</th><th>우편번호</th></tr>";
	$(jsonStr.results.juso).each(function(){
		htmlStr += "<tr onclick='selectAddress(\"" + this.roadAddr + "\")'>";
		htmlStr += "<td>"+this.roadAddr+"</td>";
		htmlStr += "<td>"+this.jibunAddr+"</td>";
		htmlStr += "<td>"+this.zipNo+"</td>";
		htmlStr += "</tr>";
	});
	htmlStr += "</table>";
	$("#list").html(htmlStr);
}

function selectAddress(address) {
    $("#address").val(address);
    $("#list").css('display', 'none')

}

//특수문자, 특정문자열(sql예약어의 앞뒤공백포함) 제거
function checkSearchedWord(obj){
	if(obj.value.length >0){
		//특수문자 제거
		var expText = /[%=><]/ ;
		if(expText.test(obj.value) == true){
			alert("특수문자를 입력 할수 없습니다.") ;
			obj.value = obj.value.split(expText).join(""); 
			return false;
		}
		
		//특정문자열(sql예약어의 앞뒤공백포함) 제거
		var sqlArray = new Array(
			//sql 예약어
			"OR", "SELECT", "INSERT", "DELETE", "UPDATE", "CREATE", "DROP", "EXEC",
             		 "UNION",  "FETCH", "DECLARE", "TRUNCATE" 
		);
		
		var regex;
		for(var i=0; i<sqlArray.length; i++){
			regex = new RegExp( sqlArray[i] ,"gi") ;
			
			if (regex.test(obj.value) ) {
			    alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex, "");
				return false;
			}
		}
	}
	return true ;
}

function enterSearch() {
	var evt_code = (window.netscape) ? ev.which : event.keyCode;
	if (evt_code == 13) {    
		event.keyCode = 0;  
		getAddr(); //jsonp사용시 enter검색 
	} 
}
</script>
	
	
<title>회원 가입 페이지</title>
</head>
<body>
	<c:import url="../header.jsp" />

	<div class="container">
		<h1>회원가입페이지</h1>

		<form method="post" action=""></form>
			<div class="mb-3 mt-3">
				<label for="userId" class="form-label">아이디: </label> <input
					type="text" class="form-control" id="userId"
					placeholder="아이디를 입력하세요..." name="userId" />
			</div>

			<div class="mb-3 mt-3">
				<label for="userPwd1" class="form-label">패스워드: </label> <input
					type="password" class="form-control" id="userPwd1"
					placeholder="비밀번호를 입력하세요..." name="userPwd" />
			</div>

			<div class="mb-3 mt-3">
				<label for="userPwd1" class="form-label">패스워드 확인: </label> <input
					type="password" class="form-control" id="userPwd2"
					placeholder="비밀번호를 확인하세요..." />
			</div>

			<div class="mb-3 mt-3">
				<label for="userEmail" class="form-label">이메일: </label> 
				<input type="text" class="form-control" id="userEmail" name="userEmail" />
			</div>

<div class="form-check">
  <input type="radio" class="form-check-input" id="radio1" name="optradio" value="option1" checked>남성
  <label class="form-check-label" for="radio1"></label>
</div>
<div class="form-check">
  <input type="radio" class="form-check-input" id="radio2" name="optradio" value="option2">여성
  <label class="form-check-label" for="radio2"></label>
</div>

			<div class="mb-3 mt-3">
				<label for="mobile" class="form-label">휴대전화: </label> <input
					type="text" class="form-control" id="mobile"
					placeholder="전화번호를 입력하세요..." name="userMobile" />
			</div>

			<div class="mb-3 mt-3">
				<label for="memberProfile" class="form-label">회원 프로필: </label> <input
					type="file" class="form-control" id="userProfile"
					name="memberProfile" />
					
					
			</div>
			
			<form name="form" id="form" method="post">
<input
					type="hidden" class="form-control" id="currentPage"
					placeholder="현재 페이지 번호를 입력하세요..." name="currentPage" value="1" />
		

		<input
					type="hidden" class="form-control" id="countPerPage"
					placeholder="페이지당 출력할 개수를 입력하세요..." name="countPerPage" value="10" />
			

		<input
					type="hidden" class="form-control" id="resultType"
					placeholder="검색결과 형식을 입력하세요..." name="resultType" value="json" />
		

			<input
					type="hidden" class="form-control" id="confmKey"
					placeholder="승인키를 입력하세요..." name="confmKey" value="devU01TX0FVVEgyMDI0MDcyOTE2MzQxMTExNDk3Mjg="/>

			<div class="mb-3 mt-3">
				<label for="keyword" class="form-label">주소: </label> <input
					type="text" class="form-control" id="keyword"
					placeholder="키워드를 입력하세요..." name="keyword" onkeydown="enterSearch();"/>
			</div>


	
		 <div class="mb-3 mt-3">
				<input type="button" onClick="getAddr();" value="주소검색하기"/>
			</div>
	
	<div class="mb-3 mt-3">
				<label for="userAdress" class="form-label">상세 주소</label> 
				<input type="text" class="form-control" id="address" name="address" />
			</div>
	
	<div id="list" ></div><!-- 검색 결과 리스트 출력 영역 -->
</form>
			


			<div class="form-check">
				<input class="form-check-input" type="checkbox" id="agree"
					name="agree" value="Y" /> <label class="form-check-label">회원
					가입 조항에 동의합니다</label>
			</div>

			<!-- form 태그는 항상 submit / reset 버튼과 함께 사용 -->
			<input type="submit" class="btn btn-success" value="회원가입" /> <input
				type="reset" class="btn btn-danger" value="취소" />
		</form>

	
	
	


</div>

	<c:import url="../footer.jsp" />
</body>
</html>