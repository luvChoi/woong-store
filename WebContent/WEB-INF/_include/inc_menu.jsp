<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../_include/inc_header.jsp" %>

<!-- Header -->
<header>
	<div class="header">				
		<div class="member">
			<ul>
				<c:if test="${servletStr == 'store' }">
				<li><a href="javascript:searchDisplay();" class="searchIcon">
					<img id="memberSearch" src="../_resources/images/search.png" class="opacity-75">					
				</a></li>
				</c:if>
								
				<!-- 비로그인 -->
				<c:if test="${cookMemberNo == null || cookMemberNo == 0 }">
				<li id="loginMenu">
					<a href="${path }/main_servlet/login.do" class="before_login ms-1">
						<img id="memberUser" src="../_resources/images/user.png">
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
				</li>
				</c:if>
				<!-- 로그인 후 -->
				<c:if test="${cookMemberNo > 0 }">
				<li id="memberMenu">
					<a href="${path }/member_servlet/myPage.do" class="after_login ms-1">
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
				</li>
				</c:if>		
				
				<li class="position-relative">
					<a href="${path }/cart_servlet/list.do" class="ms-1 me-2 text-decoration-none">						
						<img id="memberCart" src="../_resources/images/cart.png">
						<c:if test="${sessionScope.cookCartCnt > 0 }">
							<span class="badge bg-danger position-absolute bottom-50 start-50 rounded-pill">${sessionScope.cookCartCnt }</span>
						</c:if>
					</a>
				</li>
			</ul>
		</div>
	</div>
</header>

<div id="nav">
	<div class="logo">
		<h2><a href="${path }/main_servlet/main.do" class="text-decoration-none">
			ST<img src="../_resources/images/homeTag.png" style="height: 50px; width: 50px; margin-bottom: 10px;">RE
		</a></h2>
	</div>
	<nav class="menu">
		<ul class="nav nav-pills my-auto">
			<li class="nav-item">
		  		<a class="nav-link" href="${path }/store_servlet/allProduct.do">전체 제품</a>
		  	</li>		  	
		  	<li class="nav-item">
		  		<a class="nav-link" href="${path }/store_servlet/prodDisplay.do?sort=best">베스트</a>
		  	</li>		  	
		  	<li class="nav-item">
		  		<a class="nav-link" href="${path }/store_servlet/prodDisplay.do?sort=new">신상</a>
		  	</li>
		  	<c:if test="${cookMemberNo == null || cookMemberNo == 0 }">
				<li class="nav-item">
		  			<a class="nav-link" href="${path }/help_servlet/helpGuide.do">고객센터 안내</a>
		  		</li>
			</c:if>
		  	
		  	<c:if test="${cookMemberNo > 0 }">  
			  	<li class="nav-item dropdown">
				    <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" href="#" role="button" aria-expanded="false">고객센터</a>
				    <ul class="dropdown-menu" style="margin-left: 20px;">
						<li><a class="dropdown-item" href="${path }/help_servlet/helpGuide.do">고객센터 안내</a></li>
						<c:if test="${cookMemberNo > 0 }">
				      		<li><a class="dropdown-item" href="${path }/help_servlet/inquiryAnswer.do">문의/답변</a></li>
				      	</c:if>			      	
				    </ul>
			  	</li>
		  	</c:if>
		 </ul>		    
	</nav>
	 
	<div class="searchDiv" style="display: none;">
		<div id="headerSearchArea" class="d-flex align-middle my-3">
		    <input type="text" id="searchInput" placeholder="검색어를 입력하세요. (예: 제품명)" class="form-control form-control-sm" >
		    <button type="button" id="searchBtn" class="btn btn-danger btn-sm" >검 색</button>
	    </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
function searchDisplay() {
	display = $('.searchDiv').css('display');
	if(display == 'none') {
		$('.searchDiv').show();
	} else if(display == 'block') {
		$('.searchDiv').hide();
	}
}

$(function(){
	$('#loginMenu').mouseover(function(){
    	$('#menuDrop').css('display', 'block');
  	});
  	$('#loginMenu').mouseout(function(){
    	$('#menuDrop').css('display', 'none');
  	});
  	
  	$('#memberMenu').mouseover(function(){
    	$('#memberMenuDrop').css('display', 'block');
  	});
 	$('#memberMenu').mouseout(function(){
    	$('#memberMenuDrop').css('display', 'none');
  	});
 	
 	//검색
 	$('#searchBtn').on('click', function(){
 		var searchWord = $('#searchInput').val();
 		var searchLength = searchWord.trim().length;
 		if(searchLength == 0) {
 			alert('검색어를 입력하세요. (예: 제품명)');
 		} else if(searchLength > 0) {
 			window.location.href = "${path }/store_servlet/searchResult.do?searchWord=" + searchWord;
 		}
 	});
 	
});

</script>