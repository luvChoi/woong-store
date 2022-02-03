<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../_include/inc_header.jsp" %>

<div class="orderView_wrapper">	
	<div class="orderViewTitle">
		<span>주문 상세보기</span>
	</div>
	
	<div class="orderViewInfo_wrapper">
		<div class="orderViewInfo">
			<span>주문일자</span><span><fmt:formatDate value="${dto.order_date }" pattern="yyyy.MM.dd"/></span>
			<span class="orderDivision">|</span>
			<span>주문번호</span><span class="text-danger">${dto.order_no }</span>
			<c:if test="${dto.status == '구매확정' }">
				<button type="button" class="shadow-none bg-light rounded">주문내역 삭제</button>
			</c:if>
		</div>
	</div>
	
	<!-- 상세보기 테이블 -->	
	<table class="orderViewTB">
		<tr class="orderViewTBhead">
			<td class="orderViewNo">상품주문번호</td> 
			<td colspan="2" class="orderViewProdInfo">상품정보</td>
			<td class="orderViewTotPrice">상품금액(수량)</td>
			<td class="orderViewShip">배송비/문의</td>
			<td colspan="2" class="orderViewStatus">진행상태</td>
		</tr>
		
		<c:set var="totOrderPrice" value="${totOrderPrice = 0 }" />
		<c:set var="totSalePrice" value="${totSalePrice = 0 }" />
		<c:set var="totDeliveryCharge" value="${totDeliveryCharge = 0 }" />	
		<c:set var="count" value="${count = 0 }" />
				
		<c:forEach var="prodDto" items="${dto.orderProdList }">
		<c:set var="infoThumImg" value="${fn:split(prodDto.info_thumbImg, '|')[0] }"/>
		<c:set var="thumImg" value="${fn:split(infoThumImg, ',')[1] }"/>
		<tr class="orderViewTBbody">
			<td>${prodDto.cart_no }</td>
			<td class="orderViewProdImg">
				<a href="${path }/store_servlet/view.do?no=${prodDto.product_no }">
					<img src="${path }/attach/product_img/${thumImg }" class="orderViewProdImg_img">
				</a>
			</td>
			<td class="orderViewMakerName">
				<div class="orderViewProdMaker">${prodDto.product_maker }</div>
				<div>
					<a href="${path }/store_servlet/view.do?no=${prodDto.product_no }" class="orderViewProdName">
						${prodDto.product_name }
					</a>
				</div>
			</td>
			<td>
				<div><fmt:formatNumber value="${prodDto.selling_price }" pattern="#,###"/> 원</div>
				<div class="text-secondary">(${prodDto.volume_order }개)</div>
			</td>
			<c:if test="${count == 0 }">
			<td rowspan="${fn:length(dto.orderProdList) }">
				<div>무료</div>
				<button type="button" onClick="inquiry(${dto.order_no })">문의하기</button>
			</td>
			</c:if>
			<td>${prodDto.status }</td>
			
			<c:if test="${prodDto.status == '결제완료' }">
			<td>
				<button type="button" onClick="orderCancel('${prodDto.cart_no }');">주문취소</button>
			</td>
			</c:if>
			<c:if test="${prodDto.status == '취소완료' }">
			<td>
				<button type="button" onClick="infoCancel('${prodDto.cart_no }');">취소상세정보</button>
			</td>
			</c:if>
			
		</tr>
		<c:set var="totOrderPrice" value="${totOrderPrice = totOrderPrice + prodDto.selling_price }" />
		<c:set var="totSalePrice" value="${totSalePrice = totSalePrice + prodDto.selling_price * (prodDto.sale_percent / 100 ) }" />				
		<c:set var="totDeliveryCharge" value="${totDeliveryCharge = totDeliveryCharge + prodDto.delivery_charge }" />
		<c:set var="count" value="${count = count + 1 }" />				
		</c:forEach>
	</table>
	
	<div class="orderViewPayInfoTitle">
		주문/결제 금액 정보
	</div>
	<table class="orderViewPayInfoTB">
		<tr>
			<td>상품금액</td>
			<td>
				<fmt:formatNumber value="${totOrderPrice }" pattern="#,###"/> 원
			</td>
			<td rowspan="3">
				<span>주문금액</span>
				<fmt:formatNumber value="${totOrderPrice +  totDeliveryCharge - totSalePrice}" pattern="#,###"/> 원
			</td>
		</tr>
		<tr>
			<td>배송비</td>
			<td>
				+ <fmt:formatNumber value="${totDeliveryCharge }" pattern="#,###"/> 원						
			</td>
		</tr>
		<tr>
			<td>할인금액</td>
			<td>
				- <fmt:formatNumber value="${totSalePrice }" pattern="#,###"/> 원						
			</td>
		</tr>				
	</table>
	
	<form name="orderSujungForm">
	<div class="orderSujungShipTitle">
		<div>배송지 정보</div>
		<button type="button" onClick="sujungAddr();" class="btn btn-primary">배송지 정보변경</button>
	</div>	
	<table class="orderViewShipTB">
		<tr>
			<td>수령인</td>
			<td><input type="text" name="name" value="${dto.name }" class="form-control w-25" placeholder="수령인"></td>
		</tr>
		<tr>
			<td>연락처</td>
			<td><input type="text" name="phone" value="${dto.phone }" class="form-control w-25" placeholder="연락처 (-없이 번호만)"></td>
		</tr>
		<tr>
			<td class="orderViewShipAddr">배송지</td>
			<td class="orderSujungShipAddr">
				<div>
					<input type="text" name="addr_no" id="sample3_postcode" value="${dto.addr_no }" placeholder="우편번호" class="form-control w-25">
					<input type="button" onclick="sample3_execDaumPostcode()" value="우편번호 찾기" class="btn btn-outline-primary btn-sm">
				</div>
				<div>
					<input type="text" name="addr1" id="sample3_address" value="${dto.addr1 }" placeholder="주소" class="form-control w-50">
				</div>
				<div class="orderSujungAddr23">
					<input type="text" name="addr2" id="sample3_detailAddress" value="${dto.addr2 }" placeholder="상세주소" class="form-control">
					<input type="text" name="addr3" id="sample3_extraAddress" value="${dto.addr3 }" placeholder="참고항목" class="form-control">
				</div>
				<div id="wrap" style="display:none;border:1px solid;width:500px;height:400px;margin:-200px auto auto 450px;position:absolute;background-color: white; overflow: hidden;z-index:4;">
					<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:relative;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
				</div>
			</td>
		</tr>
		<tr>
			<td>배송메모</td>
			<td><input type="text" name="request_term" value="${dto.request_term }" placeholder="요청사항을 직접 입력해 주세요." class="tbShipMemo form-control w-50"></td>
		</tr>
	</table>
	<input type="hidden" name="ordere_no" value="${dto.order_no }"> 
	</form>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
function orderCancel(value1) { //주문 취소
	window.open('${path}/popup_servlet/requestCancel.do?orderProductNo=' + value1, '취소요청' + value1, 'width=520px,height=700px');
}

function infoCancel(value1) { //취소 정보
	window.open('${path}/popup_servlet/infoCancel.do?orderProductNo=' + value1, '취소정보' + value1, 'width=520px,height=700px');
}

function inquiry(value1) { //문의하기
	window.open('${path}/popup_servlet/inquiry.do?orderNo=' + value1, '문의하기' + value1, 'width=520px,height=700px');
}

function sujungAddr() {
	if($('input[name=name]').val().trim() == "") {
		alert('수령인을 입력하세요.');
		$('input[name=name]').focus();
		return;
	}
	if($.isNumeric($('input[name=name]').val())) {
		alert('수령인은 문자로 입력해 주세요.');
		$('input[name=name]').val('');
		$('input[name=name]').focus();
		return;
	}
	
	var $phoneInput = $('input[name=phone]');	
	if($phoneInput.val().trim() == "") {
		alert('연락처를 입력하세요.');
		$('input[name=phone]').focus();
		return;
	}	
	phoneChk = $phoneInput.val().replace(/\-/g, '');	
	if(isNaN(phoneChk)) {
		alert('연락처는 숫자로 입력해주세요.');
		$('input[name=phone]').val('');
		$('input[name=phone]').focus();
		return;
	}
	if(phoneChk.length < 10 || phoneChk.length > 11) {
		alert('연락처는 10~11자리입니다.');
		$('input[name=phone]').val('');
		$('input[name=phone]').focus();
		return;
	}
	
	if($('input[name=addr_no]').val().trim() == "") {
		alert('우편번호를 입력하세요.');
		$('input[name=addr_no]').focus();
		return;
	}
	if(isNaN($('input[name=addr_no]').val())) {
		alert('우편번호은 숫자만으로 입력해주세요.');
		$('input[name=addr_no]').val('');
		$('input[name=addr_no]').focus();
		return;
	}
	if($('input[name=addr1]').val().trim() == "") {
		alert('주소를 입력하세요.');
		$('input[name=addr1]').focus();
		return;
	}	
	orderSujungForm.method = "post";
	orderSujungForm.action = "${path }/order_servlet/orderSujungAddrProc.do";
	orderSujungForm.submit();	
}

$(function(){
	//휴대전화 '-' 추가
	$('input[name=phone]').on('change', function() {		
		var $phone =$('input[name=phone]');
		var phoneVal = $phone.val();
		phoneVal = phoneVal.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");		  
		$('input[name=phone]').val(phoneVal);
	});
});

</script>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
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
