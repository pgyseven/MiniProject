<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<html>
<head>
<title>상세보기</title>
</head>
<body>
	<div class="container">
		<c:import url="../header.jsp"></c:import>

		<div class="content">
			<h1>게시글 상세 페이지</h1>

			<c:forEach var="board" items="${boardDetailInfo}">

				<div class="boardInfo">
					<div class="mb-3">
						<label for="boardNo" class="form-label">글 번호</label> <input
							type="text" class="form-control" id="boardNo"
							value="${board.boardNo}" readonly>
					</div>
					<div class="mb-3">
						<label for="title" class="form-label">글 제목</label> <input
							type="text" class="form-control" id="title"
							value="${board.title}" readonly>
					</div>
					<div class="mb-3">
						<label for="writer" class="form-label">작성자</label> <input
							type="text" class="form-control" id="writer"
							value="${board.writer}(${board.email})" readonly>
					</div>
					
					<div class="mb-3">
						<label for="writer" class="form-label">작성일</label> <input
							type="text" class="form-control" id="postDate"
							value="${board.postDate}" readonly>
					</div>
					
					<div class="mb-3">
						<label for="writer" class="form-label">조회수</label> <input
							type="text" class="form-control" id="readCount"
							value="${board.readCount}" readonly>
					</div>
					<!-- readonly는 수정 불가 -->
					
					
					<div class="mb-3">
						<label for="content" class="form-label">내용</label>
						<textarea class="form-control" id="content" rows="5" readonly>
						${board.content}
						</textarea>
					</div>
				</div>
				<div class="fileList" style="padding : 15px">
				<c:forEach var="file" items="${board.fileList}">
					<c:choose>
					<c:when test="${file.thumbFileName != null }">
					<div>
						<img src="/resources/boardUpFiles/${file.newFileName }" />
						</div>
					</c:when>
					<c:otherwise>
					<div>
					<a href="/resources/boardUpFiles/${file.newFileName }">
						<img src="/resources/images/noimage.png" />
						${file.newFileName }
						</a>
						</div>
					</c:otherwise>
					</c:choose>
				</c:forEach>
				</div>
		</div>

		</c:forEach>
		
		<div calss="btns">
		<button type="button" class="btn btn-info" onclick="">답글달기</button>
		<button type="button" class="btn btn-primary" onclick="location.href='/hboard/listAll';">글수정</button>
		<button type="button" class="btn btn-danger" onclick="">글삭제</button>
		<button type="button" class="btn btn-info" onclick="location.href='/hboard/listAll';">리스트페이지로</button>
		</div>
		<c:import url="../footer.jsp"></c:import>
	</div>
</body>
</html>
