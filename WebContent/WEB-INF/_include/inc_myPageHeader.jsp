<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../_include/inc_header.jsp" %>

<div class="findHeader_wrapper">
	<div class="findHeader">
		<div class="findHeaderLogo">
			<a href="${path }/main_servlet/main.do" id="logoLink" class="text-decoration-none text-dark ">
				ST<img id="logo" src="../_resources/images/homeTag.png">RE
			</a>
			<c:if test="${cookMemberNo > 0 }">
				<a href="${path }/member_servlet/myPage.do" class="myPageLink">내정보</a>
			</c:if>
		</div>
		
		<!-- 로그인 전 -->
		<c:if test="${cookMemberNo == null || cookMemberNo == 0 }">
		<div class="headerBeforeLogin">
			<a href="${path }/main_servlet/login.do">
				<img class="headerLoginIcon" src="../_resources/images/user.png">
			</a>
			<div id="menuDrop" class="dropdown_menu shadow-sm" style="display: none;">
				<div class="dropdown-item text-center my-2">
					<a href="${path }/main_servlet/login.do" class="text-decoration-none text-dark">로그인</a>
				</div>
				<div class="dropdown-item text-center">
					<a href="${path }/member_servlet/join.do" class="text-decoration-none text-dark">회원가입</a>
				</div>
				<div><hr class="dropdown-divider"></div>			
				<div class="dropdown-item text-center mb-2">
					<a href="${path }/main_servlet/findOrder.do" class="text-decoration-none text-dark">주문 / 배송조회</a>
				</div>
			</div>
		</div>
		</c:if>
		
		<!-- 로그인 후 -->
		<c:if test="${cookMemberNo > 0 }">
		<div class="headerAfterLogin">
			<a href="${path }/member_servlet/myPage.do" id="memberMenu">
				<img id="memberUser" src="../_resources/images/userAfterLogin.png">
			</a>
			<div id="memberMenuDrop" class="dropdown_menu shadow-sm" style="display: none;">
				<div class="dropdown-item text-center my-2">
					<a href="${path }/main_servlet/logout.do" class="text-decoration-none text-dark">로그아웃</a>
				</div>						
				<div><hr class="dropdown-divider"></div>			
				<div class="dropdown-item text-center mb-2">
					<a href="${path }/order_servlet/orderList.do" class="text-decoration-none text-dark">주문 / 배송조회</a>
				</div>
			</div>
		</div>
		</c:if>
	</div>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
$(function(){
	$('.headerBeforeLogin').mouseover(function(){
    	$('#menuDrop').css('display', 'block');
  	});
 	$('.headerBeforeLogin').mouseout(function(){
    	$('#menuDrop').css('display', 'none');
  	});
 	
  	$('.headerAfterLogin').mouseover(function(){
    	$('#memberMenuDrop').css('display', 'block');
  	});
 	$('.headerAfterLogin').mouseout(function(){
    	$('#memberMenuDrop').css('display', 'none');
  	});
});
</script>