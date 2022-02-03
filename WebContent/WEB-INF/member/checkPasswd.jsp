<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>

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
	<!-- 비밀번호 확인 -->
	<div class="updateMyInfo_wrapper">
		<div class="updateMyInfoGuide_wrapper">
			<div class="updateMyInfoGuide">		
				회원정보 수정		
			</div>
		</div>
		
		<div class="checkPasswd_wrapper">
			<div class="checkPasswdInfo1">
				회원정보 수정을 하시려면 비밀번호를 입력하셔야 합니다.
			</div>
			<div class="checkPasswdInfo2">
				회원님의 개인정보 보호를 위한 본인 확인절차이오니,<br>
				STORE 로그인 시 사용하시는 비밀번호를 입력해 주세요.
			</div>
			<form name="checkPassForm">
				<div class="checkPasswdInput">
					<input type="password" name="password" value="" placeholder="비밀번호를 입력해 주세요.">				
				</div>		
				<div class="checkPasswdBtn">	
					<button type="button" id="checkPasswd" class="btn btn-danger">확인</button>
				</div>
			</form>
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
$(function(){
	$('#checkPasswd').on('click', function() { //비밀번호 확인
		var $inputPasswd = $('input[name=password]');
		if($inputPasswd.val() == ""){
			alert('비밀번호를 입력해 주세요.');
			$inputPasswd.focus();
			return;
		}
		checkPassForm.method = "post";
		checkPassForm.action = "${path }/member_servlet/checkPasswdProc.do";		
		checkPassForm.submit();
	});
	
  	$('.headerLoginArea').mouseover(function(){
    	$('#memberMenuDrop').css('display', 'block');
  	});
 	$('.headerLoginArea').mouseout(function(){
    	$('#memberMenuDrop').css('display', 'none');
  	});
});
</script>

</body>
</html>