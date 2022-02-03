<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@include file="../_include/inc_header.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기결과</title>

<link rel="stylesheet" type="text/css" href="../_resources/css/login.css" >
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
</head>

<body>
<!-- header -->
<div class="findHeader_wrapper">
	<%@include file="../_include/inc_myPageHeader.jsp" %>
</div>

<!-- section -->
<div class="section-wrapper">
	<div class="findPasswdResult_wrapper">
		<div class="findPasswdResultGuide_wrapper">
			<div class="findPasswdResult">
				<c:choose>
					<c:when test="${result == 1 }" >비밀번호 재설정</c:when>
					<c:otherwise>비밀번호 찾기</c:otherwise>
				</c:choose>
			</div>
		</div>
			
		<div class="findPasswdInfo">
			<c:choose>
				<c:when test="${result == 1 }" >
				<div class="findResultComent">
					비밀번호를 변경해 주세요.<br>
					다른 아이디나 사이트에서 사용한 적 없는 안전한 비밀번호로 변경해주세요.
				</div>
				
				<!-- 비밀번호 재설정 -->
				<form name="updatePassForm">
					<div class="updatePasswd_wrapper">
						<div class="updateIdInfo">
							STORE 아이디 : <span>${dto.id }</span>
						</div>
						<div class="updatePass">
							<input type="password" name="passwd" id="passwd" value="" placeholder="새 비밀번호">
						</div>
						<div class="updatePassChk">
							<input type="password" name="passwdChk" id="passwdChk" value="" placeholder="새 비밀번호 확인">
						</div>
						<input type="hidden" name="id" value="${dto.id }">
					</div>				
				</form>
				<div class="updatePasswdGuide">
					· 영문, 숫자, 특수문자를 함께 사용하면 보다 안전합니다.<br>
					· 다른 사이트와 다른 STORE 아이디만의 비밀번호를 만들어 주세요.
				</div>		
				</c:when>
				
				<c:otherwise>
				<div class=findIdResultNoComent>
					입력하신 아이디 또는 휴대폰 번호가 일치하지 않습니다.
				</div>
				</c:otherwise>
			</c:choose>
		</div>
		
		<div class="findResultBtnGroup">
			<c:choose>
				<c:when test="${result == 1 }" >
					<button type="button" id="btnUpdatePasswd" class="btn btn-outline-dark">확인</button>
				</c:when>
				<c:otherwise>
					<button type="button" id="btnFindPasswd" class="btn btn-light">비밀번호 찾기</button>
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
	$('#btnUpdatePasswd').on('click', function() { //비밀번호 재설정
		var $passwd = $('#passwd');
		var $passwdChk = $('#passwdChk');
		
		if($passwd.val().trim() == "") {
			alert('새 비밀번호를 입력해주세요.');
			$passwd.focus();
			return;
		}
		if($passwdChk.val().trim() == "") {
			alert('새 비밀번호 확인을 입력해주세요.');
			$passwdChk.focus();
			return;
		}
		if($passwd.val() != $passwdChk.val()) {
			alert('입력하신 새 비밀번호가 일치하지 않습니다.');
			$passwdChk.val('');
			$passwd.focus();
			return;
		}
		updatePassForm.method = "post";
		updatePassForm.action = "${path }/main_servlet/updatePassProc.do";
		updatePassForm.submit();		
	});	
	
	$('#btnFindPasswd').on('click', function() { //비밀번호 찾기
		window.location.href = "${path }/main_servlet/findPasswd.do";
	});
	$('#btnGoHome').on('click', function() { //홈으로
		window.location.href = "${path }/main_servlet/main.do";
	});
});

</script>
</body>
</html>