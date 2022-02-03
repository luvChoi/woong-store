<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@include file="../_include/inc_header.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>

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
	<div class="whatFind_wrapper">
		<div class="findGuide_wrapper">
			<a href="#" class="findIdGuide">아이디 찾기</a>
			<a href="${path }/main_servlet/findPasswd.do" class="findPassWdGuide">비밀번호 찾기</a>
		</div>
		<form name="findForm">
			<div class="findInfoInput">
				<input type="text" name="name" value="" placeholder="이름">
				<input type="date" name="birth" value="" min="1900-01-01" max="2022-01-01" >
				<input type="text" name="phone" value="" placeholder="휴대전화 (-없이 번호만)">
				<button type="button" onClick="findId();" id="findBtn" class="btn btn-outline-danger">아이디 찾기</button>
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
	var findItem = '${findItem }';
	if(findItem == 'id') {		
		$('a.findIdGuide').css({
			'color': '#dc3545',
			'font-weight': 'bold',
			'border-bottom': '3px solid #dc3545'
		});		
	}	
	var $birthInput = $('input[name=birth]');
	$birthInput.on('change', function() {
		if($birthInput.val() == ""){
			$birthInput.css({
				'color':'gray',
				'font-weight':'normal'
			});
		} else {
			$birthInput.css({
				'color':'black',
				'font-weight':'bold'
			});
		}
	});	
	
	$('#findBtn').on('click',function() {
		var $nameInput = $('input[name=name]');
		var $birthInput = $('input[name=birth]');
		var $phoneInput = $('input[name=phone]');
		
		if($nameInput.val().trim() == "") {
			alert('이름을 입력해 주세요.');
			$nameInput.val('');
			$nameInput.focus();
			return;
		}
		if($.isNumeric($nameInput.val())) { // $.isNumeric : 숫자일 때 true, 숫자아닐 때 false
			alert('이름은 문자로 입력해 주세요.');
			$nameInput.val('');
			$nameInput.focus();
			return;
		}
		if($birthInput.val().trim() == "") {
			alert('생년월일을 입력해 주세요.');
			$birthInput.val('');
			$birthInput.focus();
			return;
		}		
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
		findForm.method = "post";
		findForm.action = "${path }/main_servlet/findIdResult.do";
		findForm.submit();		
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
