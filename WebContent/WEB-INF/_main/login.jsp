<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>

<link rel="stylesheet" type="text/css" href="../_resources/css/login.css" >

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">

</head>
<body>

<%@include file="../_include/inc_header.jsp" %>

<form name="form">
<div class="loginFlame" >
	<div class="inputFlame" >
		<div class="tagArea" >
			<div class="h-25"></div>
			<div class="h-75 d-flex justify-content-center align-items-center" id="loginLogo">
				<a href="${path }/main_servlet/main.do" id="logoLink" class="text-decoration-none text-dark ">
					ST<img id="logo" src="../_resources/images/homeTag.png">RE
				</a>
			</div>
		</div>		
		<div class="idArea" >
			<div class="idTag">ID</div>
			<div class="idInput"><input class="form-control" type="text" name="id" value="${id }"></div>
			<c:if test="${!(go == null || go == '') }">
				<input type="hidden" name="go" value="${go }">
			</c:if>		
		</div>
		<div class="passwdArea" >
			<div class="passTag">PASSWORD</div>
			<div class="passInput"><input class="form-control" type="password" name="passwd"></div>
		</div>
		<div class="btnArea mb-3" >			
			<button type="button" class="btn btn-dark" id="loginBtn" onClick="login();">L O G I N</button>			
		</div>
		<div class="d-flex justify-content-center">
			<a href="${path }/main_servlet/findId.do" id="addArea" class="text-decoration-none text-secondary me-2">아이디&nbsp;&nbsp;·</a>
			<a href="${path }/main_servlet/findPasswd.do" id="addArea" class="text-decoration-none text-secondary me-2">비밀번호 찾기</a>
			<span id="addArea" class="text-secondary">|</span>
			<a href="${path }/member_servlet/join.do" id="addArea" class="text-decoration-none text-secondary ms-2">회원가입</a>
		</div>
	</div>
</div>
</form>

<script>
function login() {
	if(document.form.id.value == ""){
		alert('ID를 입력해주세요');
		form.id.focus();
		return;
	}
	if(document.form.passwd.value == ""){
		alert('PASSWORD를 입력해주세요');
		form.passwd.focus();
		return;
	}
	form.method = "post";
	form.action = "${path}/main_servlet/loginProc.do";
	form.submit();
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>