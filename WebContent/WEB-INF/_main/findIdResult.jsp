<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@include file="../_include/inc_header.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기결과</title>

<link rel="stylesheet" type="text/css" href="../_resources/css/login.css" >
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
</head>

<body>
<!-- Header -->
<div class="findHeader_wrapper">
	<%@include file="../_include/inc_myPageHeader.jsp" %>
</div>

<!-- section -->
<div class="section-wrapper">
	<div class="findIdResult_wrapper">
		<div class="findIdResultGuide_wrapper">
			<div class="findIdResult">아이디 찾기</div>
		</div>
			
		<div class="findIdInfo">
			<c:choose>
				<c:when test="${dto.no > 0 }" >
				<div class="findResultComent">고객님의 정보와 일치하는 아이디 목록입니다.</div>
				<div class="findIdResultInfo_wrapper">
					<div class="findIdResultInfo1">
						<form name="toGoLogin">
							<input type="radio" name="id" value="${dto.id }"> <span>${dto.id }</span>
							<input type="hidden" name="phone" value="${dto.phone }">
						</form>
					</div>
					<div class="findIdResultInfo2">가입: ${dto.regi_date }</div>
				</div>
				</c:when>
				<c:otherwise>
				<div class=findIdResultNoComent>
					입력하신 정보와 맞는 아이디가 없습니다.
				</div>
				</c:otherwise>
			</c:choose>
		</div>
		
		<div class="findResultBtnGroup">
			<c:choose>
				<c:when test="${dto.no > 0 }" >
					<button type="button" id="btnLogin" class="btn btn-outline-dark">로그인하기</button>
					<button type="button" id="btnFindPasswd" class="btn btn-danger">비밀번호 찾기</button>
				</c:when>
				<c:otherwise>
					<button type="button" id="btnFindId" class="btn btn-outline-dark">아이디 찾기</button>
					<button type="button" id="btnGoHome" class="btn btn-danger">홈으로</button>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

<!-- footer -->
<div class="footer-wrapper">
	<%@include file="../_include/inc_footer.jsp" %>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(function() {
	$('#btnLogin').on('click', function() { //로그인하기
		var checkVal = $('input[name=id]').prop('checked');
		if(checkVal == false) {
			alert('아이디를 선택해 주세요.');
		} else {
			toGoLogin.method = "post";
			toGoLogin.action = "${path }/main_servlet/login.do";
			toGoLogin.submit();
		}
	});
	$('#btnFindPasswd').on('click', function() { //비밀번호 찾기
		var checkVal = $('input[name=id]').prop('checked');
		if(checkVal == false) {
			alert('아이디를 선택해 주세요.');
		} else {
			toGoLogin.method = "post";
			toGoLogin.action = "${path }/main_servlet/findPasswdResult.do";
			toGoLogin.submit();
		}
	});
	
	$('#btnFindId').on('click', function() { //아이디 찾기
		window.location.href = "${path }/main_servlet/findId.do";
	});
	$('#btnGoHome').on('click', function() { //홈으로
		window.location.href = "${path }/main_servlet/main.do";
	});
});

</script>
</body>
</html>