<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>

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
	<!-- 회원정보 수정 -->
	<div class="updateMyInfo_wrapper">
		<div class="updateMyInfoGuide_wrapper">
			<div class="updateMyInfoGuide">		
				회원정보 수정		
			</div>
		</div>
		
		<!-- 회원정보 테이블 -->
		<div class="myInfoTB_wrapper">
			<table class="myInfoTB">
				<tr>
					<td>아이디</td>
					<td>${dto.id }</td>
				</tr>
				<tr>
					<td>이름</td>
					<td>${dto.name }</td>				
				</tr>
				<tr>
					<td>생년월일</td>
					<td>${dto.birth }</td>				
				</tr>
				<tr>
					<td>성별</td>
					<td>${dto.gender }</td>
				</tr>
				<tr>
					<td>이메일</td>
					<td>${dto.email }</td>				
				</tr>
				<tr>
					<td>휴대전화</td>
					<td>${dto.phone }</td>				
				</tr>
				<tr>
					<td>주소</td>
					<td class="addrInput">
						(${dto.addr_no }) ${dto.addr1 }<br>
						${dto.addr2 }
						<c:if test="${dto.addr3 != '-'}" >${dto.addr3 }</c:if>
					</td>				
				</tr>			
			</table>				
		</div>
		
		<!-- 정보수정 테이블 -->
		<form name="updateInfoForm">
			<div class="updateInfoTB_wrapper" style="display: none;">
				<input type="hidden" name="id" value="${dto.id }" >
				<table class="myInfoTB">
					<tr>
						<td>아이디</td>
						<td>${dto.id }</td>
					</tr>
					<tr>
						<td>이름</td>
						<td>
							<input type="text" name="name" value="${dto.name }" placeholder="이름">
						</td>				
					</tr>
					<tr>
						<td>생년월일</td>
						<td>
							<input type="date" name="birth" value="${dto.birth }" min="1900-01-01" max="2022-01-01" >
						</td>				
					</tr>
					<tr>
						<td>성별</td>
						<td class="genderTd">
							<input type="radio" name="gender" value="남자" class="me-1" >남자
							<input type="radio" name="gender" value="여자" class="ms-2 me-1">여자
						</td>				
					</tr>
					<tr>
						<td>이메일</td>
						<td>
							<input type="email" name="email" value="${dto.email }" placeholder="이메일">
						</td>				
					</tr>
					<tr>
						<td>휴대전화</td>
						<td>
							<input type="text" name="phone" value="${dto.phone }" placeholder="휴대전화 (-없이 번호만)">
						</td>				
					</tr>
					<tr>
						<td>주소</td>
						<td class="addrInput">
							<div id="wrap" style="display:none;border:1px solid;width:500px;height:400px;margin:-100px 400px;position:absolute;background-color: white; overflow: hidden;z-index:4;">
								<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
							</div>
							<div class="addrNoArea">
								<input type="text" name="addr_no" id="sample3_postcode" value="${dto.addr_no }" placeholder="우편번호">
								<input type="button" id="searchAddrBtn" onclick="sample3_execDaumPostcode()" value="우편번호 찾기">
							</div>
							<div class="addr1Area">
								<input type="text" name="addr1" id="sample3_address" value="${dto.addr1 }" placeholder="주소">
							</div>					
							<div class="addr23Area">
								<input type="text" name="addr2" id="sample3_detailAddress" value="${dto.addr2 }" placeholder="상세주소">
								<input type="text" name="addr3" id="sample3_extraAddress" value="${dto.addr3 }" placeholder="참고항목">
							</div>
						</td>				
					</tr>			
				</table>			
			</div>
		</form>	
	</div>
	<div class="updateInfoBtn_wrapper">
		<div class="myInfoBtnDiv">
			<button type="button">정보 수정</button>
		</div>	
		<div class="updateInfoBtnDiv" style="display: none;">
			<button type="button" id="update" >확인</button>
			<button type="button" id="return">취소</button>
		</div>	
	</div>
</div>

<!-- footer -->
<div class="footer-wrapper">
	<%@include file="../_include/inc_footer.jsp" %>
</div>

<script>
$(function(){
	//정보수정 전환
	$('.myInfoBtnDiv button').on('click', function(){
		$('.myInfoTB_wrapper').hide();
		$('.myInfoBtnDiv button').hide();
		
		$('.updateInfoTB_wrapper').show();
		$('.updateInfoBtnDiv').show();		
	});
	
	//정보수정 취소
	$('#return').on('click', function(){
		$('.myInfoTB_wrapper').show();
		$('.myInfoBtnDiv button').show();
		
		$('.updateInfoTB_wrapper').hide();
		$('.updateInfoBtnDiv').hide();
	});
	
	//정보수정 변경
	$('#update').on('click', function(){
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
			$('input[name=email]').after('<div class="updateInfoGuide">이메일은 문자로 입력해 주세요.</div>');
			$('input[name=email]').val('');
			$('input[name=email]').focus();
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
		if(confirm('정보를 수정하시겠습니까?')){
			updateInfoForm.method = "post";
			updateInfoForm.action = "${path }/member_servlet/updateMyInfoProc.do";
			updateInfoForm.submit();
		}
	});	
	
	//성별 체크
	$('input[name=gender]').each(function() {
		var myGender = "${dto.gender }";
		if($(this).val() == myGender) {
			$(this).prop('checked', true);
		}
	});
	
	//휴대전화 '-' 추가
	$('input[name=phone]').on('change', function() {		
		var $phone =$('input[name=phone]');
		var phoneVal = $phone.val();		
		phoneVal = phoneVal.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");		  
		$('input[name=phone]').val(phoneVal);
	});
	
	//메뉴드롭
  	$('.headerLoginArea').mouseover(function(){
    	$('#memberMenuDrop').css('display', 'block');
  	});
 	$('.headerLoginArea').mouseout(function(){
    	$('#memberMenuDrop').css('display', 'none');
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