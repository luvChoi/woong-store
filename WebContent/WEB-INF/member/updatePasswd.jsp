<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>

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
	<div class="updatePassword_wrapper">
		<div class="updateMyInfoGuide_wrapper">
			<div class="updateMyInfoGuide">
				비밀번호 변경
			</div>
		</div>
		
		<div class="updatePass_wrapper">
			<div class="updatePassGuide">
				<span class="text-primary">안전한 비밀번호로 내정보를 보호</span>하세요. <br>
				<span class="text-danger">· 이전에 사용한 적 없는 비밀번호</span>가 안전합니다.
			</div>
			
			<form name="updatePasswdForm">
				<div class="updatePassInput">			
					<input type="password" name="beforePasswd" id="beforePasswd" placeholder="현재 비밀번호">
					<input type="password" name="afterPasswd" id="afterPasswd" placeholder="새 비밀번호">
					<input type="password" name="afterPasswdChk" id="afterPasswdChk" placeholder="새 비밀번호 확인">
					
					<input type="hidden" name="no" value="${dto.no }">					
				</div>
			</form>
			
			<div class="updatePassBtn">
				<button type="button" id="checkBtn">확 인</button>
				<button type="button" id="cancelBtn">취 소</button>
			</div>						
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
	$('#checkBtn').on('click', function() { //확인버튼		
		var $beforePasswd = $('#beforePasswd');
		var $afterPasswd = $('#afterPasswd');
		var $afterPasswdChk = $('#afterPasswdChk');
		
		if($beforePasswd.val() == ""){
			alert('현재 비밀번호를 입력해 주세요.');
			$beforePasswd.focus();
			return;
		}
		if($afterPasswd.val() == ""){
			alert('새 비밀번호를 입력해 주세요.');
			$afterPasswd.focus();
			return;
		}
		if($afterPasswdChk.val() == ""){
			alert('새 비밀번호 확인을 입력해 주세요.');
			$afterPasswdChk.focus();
			return;
		}
		if($afterPasswd.val() != $afterPasswdChk.val()){
			alert('새 비밀번호가 일치하지 않습니다.');
			$afterPasswdChk.val('');
			$afterPasswd.select();
			return;
		}
		updatePasswdForm.method = "post";
		updatePasswdForm.action = "${path }/member_servlet/updatePasswdProc.do";
		updatePasswdForm.submit();		
	});
	
	$('#cancelBtn').on('click', function() { //취소버튼
		window.location.href = "${path }/member_servlet/myPage.do";		
	});
});
</script>

</body>
</html>