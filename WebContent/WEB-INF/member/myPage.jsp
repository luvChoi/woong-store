<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>

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
	<div class="myPage_wrapper">
		<div class="myPageTitle_wrapper">
			<span>${dto.name }</span> 님 안녕하세요.
		</div>
		<div class="memberInfo_wrapper">
			<div class="myInfo_update">
				<div class="myInfoTitle">
					내정보
				</div>
				<div class="myInfoGuide">
					안전한 정보 보호를 위해 등록된 연락처의 일부만 보여드립니다. 이름 및 정확한 연락처는 수정 화면에서 확인 가능합니다.
				</div>
				<div class="myInfoView">
					<table class="myInfoViewTB">
						<tr>
							<td>이메일</td>
							<td>${dto.email }</td>
						</tr>
						<tr>
							<td>휴대전화</td>
							<td>${dto.phone }</td>
						</tr>
					</table>
				</div>
				<div class="myInfoBtnArea">
					<a href="${path }/member_servlet/checkPasswd.do" class="btn btn-secondary">수정</a>
				</div>
			</div>
			
			<div class="myPass_update">
				<div class="myPassTitle">
					비밀번호
				</div>
				<div class="myInfoGuide">
					주기적인 비밀번호 변경을 통해 개인정보를 안전하게 보호하세요.
				</div>
				<div class="myPassUpdateLink">	
					<a href="${path }/member_servlet/updatePasswd.do" >변경하기</a>
				</div>
			</div>
		</div>
		<div class="memberWithdraw_wrapper">
			<a href="${path }/member_servlet/deleteUser.do" >회원탈퇴 바로가기</a>
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