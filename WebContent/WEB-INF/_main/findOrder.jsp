<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@include file="../_include/inc_header.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비회원 주문/배송조회</title>

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
	<div class="nonMemberOrder_wrapper">
		<div class="nonMemberOrderTitle">
			<span>주문/배송 조회</span>
		</div>
		<form name="findOrderForm">
			<div class="findOrderInput">
				<input type="text" name="orderNo" value="" placeholder="주문번호">
				<input type="text" name="phone" value="" placeholder="휴대전화 (-없이 번호만)">
				<div class="findOrderBtn">
					<button type="button" id="findOrder" class="btn btn-outline-danger">주문/배송 조회</button>
					<button type="button" id="logIn" class="btn btn-outline-primary">로그인</button>
				</div>
			</div>
		</form>
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
	$('#findOrder').on('click',function() {
		var $orderNoInput = $('input[name=orderNo]');
		var $phoneInput = $('input[name=phone]');
		
		if($orderNoInput.val().trim() == "") {
			alert('주문번호를 입력해주세요.');
			$orderNoInput.val('');
			$orderNoInput.focus();
			return;
		}
		if(isNaN($orderNoInput.val())) {
			alert('주문번호는 숫자로 입력해주세요.');
			$orderNoInput.val('');
			$orderNoInput.focus();
			return;
		}
		var $phoneInput = $('input[name=phone]');
		if($phoneInput.val().trim() == "") {
			alert('휴대전화를 입력하세요.');
			$('input[name=phone]').focus();
			return;
		}	
		phoneChk = $phoneInput.val().replace(/\-/g, '');	
		if(isNaN(phoneChk)) {
			alert('휴대전화는 숫자로 입력해주세요.');
			$('input[name=phone]').val('');
			$('input[name=phone]').focus();
			return;
		}
		if(phoneChk.length < 10 || phoneChk.length > 11) {
			alert('휴대전화는 10~11자리입니다.');
			$('input[name=phone]').val('');
			$('input[name=phone]').focus();
			return;
		}
		
		findOrderForm.method = "post";
		findOrderForm.action = "${path }/main_servlet/findOrderResult.do";
		findOrderForm.submit();	
	});
	
	$('#logIn').on('click',function() {
		window.location.href = "${path }/main_servlet/login.do?go=orderList";
	});
	
	//휴대전화 '-' 추가
	$('input[name=phone]').on('change', function() {		
		var $phone =$('input[name=phone]');
		var phoneVal = $phone.val();		
		phoneVal = phoneVal.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");		  
		$('input[name=phone]').val(phoneVal);
	});
});
</script>

</body>
</html>