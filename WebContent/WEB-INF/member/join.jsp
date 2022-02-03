<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<link rel="stylesheet" type="text/css" href="../_resources/css/login.css" >
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
</head>

<body class="join_page">
<!-- header -->
<div class="findHeader_wrapper">
	<%@include file="../_include/inc_myPageHeader.jsp" %>
</div>

<!-- section -->
<div class="section-wrapper">
	<div class="join_wrapper">	
		<form name="joinForm" >
			<div class="mb-3 mx-auto">
				<label for="member_id" class="form-label"><b>아이디</b></label>
			  	<input type="text" name="id" id="member_id" class="form-control" placeholder="아이디">
			</div>
			
			<div class="mb-3 mx-auto">
				<label for="member_passwd" class="form-label"><b>비밀번호</b></label>
			  	<input type="password" name="passwd" id="member_passwd" class="form-control" placeholder="비밀번호">
			</div>
			
			<div class="mb-3 mx-auto">
				<label for="member_passwdChk" class="form-label"><b>비밀번호 재확인</b></label>
			  	<input type="password" name="passwdChk" id="member_passwdChk" class="form-control" placeholder="비밀번호 재확인">
			</div>
			
			<div class="mb-3 mx-auto">
				<label for="member_name" class="form-label"><b>이름</b></label>
			  	<input type="text" name="name" id="member_name" class="form-control" placeholder="이름">
			</div>
			
			<div class="mb-3 mx-auto">
				<label for="member_birth" class="form-label"><b>생년월일</b></label>
			  	<input type="date" name="birth" id="member_birth" min="1900-01-01" max="2022-01-01" class="form-control" >
			</div>
			
			<div class="mb-3 mx-auto">
				<label for="member_email" class="form-label"><b>이메일</b></label>
			  	<input type="email" name="email" id="member_email" class="form-control" placeholder="이메일">
			</div>
			
			<div class="mb-3 mx-auto">
				<label for="member_gender" class="form-label"><b>성별</b></label>
				<select name="gender" id="member_gender" class="form-select mb-3">
					<option value="" selected>성별</option>
					<option value="남자">남자</option>
					<option value="여자">여자</option>
				</select>
			</div>
			
			<div class="mb-3 mx-auto">
				<label for="member_phone" class="form-label"><b>휴대전화</b></label>
				<div class="row mx-auto">
				  	<input type="text" name="phone" id="member_phone" class="form-control" placeholder="휴대전화 (-없이 번호만)">			  	
			  	</div>
			</div>
			
			<div class="joinAddrDiv">		
				<label for="sample3_postcode" class="form-label"><b>주소</b></label>
				<div id="wrap" style="display:none;border:1px solid;width:500px;height:400px;margin:-100px 510px;position:absolute;background-color: white; overflow: hidden;z-index:4;">
					<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
				</div>
				<div class="addrNoArea">
					<input type="text" name="addr_no" id="sample3_postcode" value="${dto.addr_no }" placeholder="우편번호" class="form-control" >
					<input type="button" id="searchAddrBtn" onclick="sample3_execDaumPostcode()" value="우편번호 찾기" class="btn btn-outline-primary" >
				</div>
				<div class="addr1Area">
					<input type="text" name="addr1" id="sample3_address" value="${dto.addr1 }" placeholder="주소" class="form-control" >
				</div>					
				<div class="addr23Area">
					<input type="text" name="addr2" id="sample3_detailAddress" value="${dto.addr2 }" placeholder="상세주소" class="form-control" >
					<input type="text" name="addr3" id="sample3_extraAddress" value="${dto.addr3 }" placeholder="참고항목" class="form-control" >
				</div>
			</div>	
			<div class="d-grid mx-auto mt-4">
			  	<button type="button" id="submitJoinBtn" class="btn btn-danger rounded-pill">가입하기</button>
			</div>
		</form>
	</div>
</div>

<!-- footer -->
<div class="footer-wrapper">
	<%@include file="../_include/inc_footer.jsp" %>
</div>

<script>
$(function(){
	$('#submitJoinBtn').on('click', function(){
		if($('input[name=id]').val().trim() == "") {
			alert('아이디를 입력해 주세요.');
			$('input[name=id]').val('');
			$('input[name=id]').focus();
			return;
		}
		if($.isNumeric($('input[name=id]').val())) {
			$('input[name=id]').after('<div class="updateInfoGuide">아이디는 문자로 입력해 주세요.</div>');
			$('input[name=id]').val('');
			$('input[name=id]').focus();
			return;
		}
		if($('input[name=passwd]').val().trim() == "") {
			alert('비밀번호를 입력해 주세요.');
			$('input[name=passwd]').val('');
			$('input[name=passwd]').focus();
			return;
		}
		if($('input[name=passwdChk]').val().trim() == "") {
			alert('비밀번호 재확인을 입력해 주세요.');
			$('input[name=passwdChk]').val('');
			$('input[name=passwdChk]').focus();
			return;
		}		
		if($('input[name=passwdChk]').val() != $('input[name=passwd]').val()) {
			alert('비밀번호가 일치하지 않습니다.');
			$('input[name=passwdChk]').val('');
			$('input[name=passwd]').select();
			$('input[name=passwd]').focus();
			return;
		}		
		if($('input[name=name]').val().trim() == "") {
			alert('이름을 입력해 주세요.');
			$('input[name=name]').val('');
			$('input[name=name]').focus();
			return;
		}
		if($.isNumeric($('input[name=name]').val())) {
			$('input[name=name]').after('<div class="updateInfoGuide">이름은 문자로 입력해 주세요.</div>');
			$('input[name=name]').val('');
			$('input[name=name]').focus();
			return;
		}
		if($('input[name=birth]').val().trim() == "") {
			alert('생년월일을 입력해 주세요.');
			$('input[name=birth]').val('');
			$('input[name=birth]').focus();
			return;
		}
		if($('input[name=email]').val().trim() == "") {
			alert('이메일을 입력해 주세요.');
			$('input[name=email]').val('');
			$('input[name=email]').focus();
			return;
		}
		if($.isNumeric($('input[name=email]').val())) {
			$('input[name=email]').after('<div class="updateInfoGuide">이메일은 문자로 입력해 주세요. (예. 홍길동@구글.com)</div>');
			$('input[name=email]').val('');
			$('input[name=email]').focus();
			return;
		}
		if($('select[name=gender]').val() == "") {
			alert('성별을 선택해 주세요.');
			$('select[name=gender]').focus();
			return;
		}				
		var $phoneInput = $('input[name=phone]');
		if($phoneInput.val().trim() == "") {
			alert('휴대전화를 입력하세요.');
			$('input[name=phone]').focus();
			return;
		}		
		var phoneChk = $phoneInput.val().replace(/\-/g, '');	
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
		if($('input[name=addr_no]').val().trim() == "") {
			alert('우편번호를 입력해 주세요.');
			$('input[name=addr_no]').val('');
			$('input[name=addr_no]').focus();
			return;
		}
		if($('input[name=addr1]').val().trim() == "") {
			alert('주소를 입력해 주세요.');
			$('input[name=addr1]').val('');
			$('input[name=addr1]').focus();
			return;
		}		
		if($.isNumeric($('input[name=addr1]').val())) {
			alert('주소는 문자로 입력해 주세요.');
			$('input[name=addr1]').val('');
			$('input[name=addr1]').focus();
			return;
		}
		if($('input[name=addr2]').val().trim() == "") {
			alert('상세주소를 입력해 주세요.');
			$('input[name=addr2]').val('');
			$('input[name=addr2]').focus();
			return;
		}		
		if($.isNumeric($('input[name=addr2]').val())) {
			alert('상세주소는 문자로 입력해 주세요.');
			$('input[name=addr2]').val('');
			$('input[name=addr2]').focus();
			return;
		}
		document.joinForm.method = "post";
		document.joinForm.action = "${path }/member_servlet/joinProc.do";
		document.joinForm.submit();	
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

<script>
// 우편번호 찾기 찾기 화면을 넣을 element
var element_wrap = document.getElementById('wrap');

function foldDaumPostcode() {
    // iframe을 넣은 element를 안보이게 한다.
    element_wrap.style.display = 'none';
}

function sample3_execDaumPostcode() {
    // 현재 scroll 위치를 저장해놓는다.
    var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
    new daum.Postcode({
        oncomplete: function(data) {
            // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("sample3_extraAddress").value = extraAddr;
            
            } else {
                document.getElementById("sample3_extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('sample3_postcode').value = data.zonecode;
            document.getElementById("sample3_address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("sample3_detailAddress").focus();

            // iframe을 넣은 element를 안보이게 한다.
            // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
            element_wrap.style.display = 'none';

            // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
            document.body.scrollTop = currentScroll;
        }        
    }).embed(element_wrap);

    // iframe을 넣은 element를 보이게 한다.
    element_wrap.style.display = 'block';
}
</script>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</body>
</html>
