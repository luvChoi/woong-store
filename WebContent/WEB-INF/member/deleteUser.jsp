<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원탈퇴</title>

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
	<div class="deleteUser_wrapper">
		<div class="updateMyInfoGuide_wrapper">
			<div class="updateMyInfoGuide">
				회원탈퇴		
			</div>
		</div>
		
		<div class="deleteUserGuide_wrapper">
			<div class="deleteUserGuide">
				<div class="guide1">
					회원탈퇴를 신청하기 전에 안내 사항을 꼭 확인해주세요!
				</div>
				<div class="guide2">
					· &nbsp;사용하고 계신 아이디( <span class="text-danger">${dto.id }</span> )의
					정보는 탈퇴할 경우 복구가 불가능합니다.					
				</div>
				<div class="guide3">
					· &nbsp;탈퇴 후 회원정보 및 서비스 이용기록은 모두 삭제됩니다.<br>
					<div>회원정보 및 기타 이용기록은 모두 삭제되며, 삭제된 데이터는 복구되지 않습니다.</div>
				</div>
			</div>
			
			<form name="deleteUserForm">
				<div class="deleteUserPassInput">			
					<div>비밀번호 확인</div>
					<input type="hidden" name="no" value="${dto.no }">
					<input type="password" name="password" id="password" placeholder="비밀번호">																			
				</div>
			</form>
			
			<div class="deleteUserBtn">
				<button type="button" id="deleteUserBtn">확 인</button>
				<button type="button" id="deleteCancelBtn">취 소</button>
			</div>								
		</div>
		<div class="deleteUserBotBorder"></div>
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
	$('#deleteUserBtn').on('click', function() { //확인버튼		
		var $password = $('#password');
	
		if($password.val() == ""){
			alert('비밀번호를 입력해 주세요.');
			$password.focus();
			return;
		}
		
		deleteUserForm.method = "post";
		deleteUserForm.action = "${path }/member_servlet/deleteUserProc.do";
		deleteUserForm.submit();
	});
	
	$('#deleteCancelBtn').on('click', function() { //취소버튼
		window.location.href = "${path }/member_servlet/myPage.do";		
	});
});
</script>

</body>
</html>