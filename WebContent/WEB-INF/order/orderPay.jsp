<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../_include/inc_header.jsp" %>

<div class="order_wrapper">
	<div class="row my-3">
		<div class="d-flex justify-content-start col-6">
			<span class="text-dark fs-4 fw-bold ms-1 me-2">주문 / 결제</span>
		</div>
		<div class="d-flex justify-content-end col-6 my-auto">
			<span class="me-2" style="font-weight: bold; color: #C8C8C8;">장바구니</span>
			<span class="text-dark fw-bold"> >&nbsp;&nbsp;주문/결제&nbsp;&nbsp;></span>
			<span class="ms-2" style="font-weight: bold; color: #C8C8C8;">완료</span>
		</div>	
	</div>

	<!-- 주문내역 -->
	<table class="orderTable shadow-sm p-3 mb-1 bg-body rounded">
  		<thead>
	  		<tr>
	  			<td class="orderProdInfo">상품정보</td>
	  			<td class="orderProdMaker">제조사</td>
	  			<td class="orderDeliveryFee">배송비</td>
	  			<td class="orderVolume">수량</td>
	  			<td class="orderProdSale">할인</td>
	  			<td class="orderProdPrice">상품금액(할인포함)</td>
	  		</tr>
  		</thead>
  		  		
  		<tbody>
  		<c:set var="orderCartNo" value="${orderCartNo = '' }" />
  		<c:set var="totOrderPrice" value="${totOrderPrice = 0 }" />  		
  		<c:set var="totSellingPrice" value="${totSellingPrice = 0 }" />
		<c:set var="totDeliveryPrice" value="${totDeliveryPrice = 0 }" />
		<c:set var="totSalePrice" value="${totSalePrice = 0 }" />
  		
  		<c:forEach var="dto" items="${orderProdList }">
  		<c:set var="infoThumImg" value="${fn:split(dto.info_thumbImg, '|')[0] }" />
  		<c:set var="thumImg" value="${fn:split(infoThumImg, ',')[1] }" />
	   		<tr>	  			
	  			<td class="orderProdInfoTd">	
	  				<img id="orderProdImg" src="${path }/attach/product_img/${thumImg }" >	  			
	  				<div class="orderProdInfoArea">
	  					<div id="prodMaker">
	  						${dto.product_maker }
	  					</div>
	  					<div id="prodName">
	  						${dto.product_name }
	  					</div>
	  					<div id="prodPrice">
		  					<c:set var="discount_price" value="${dto.selling_price * (dto.sale_percent + dto.add_sale) / 100 }" />
							<span class="afterPrice">
								<fmt:formatNumber value="${dto.selling_price - discount_price}" pattern="#,###"/>원
							</span>
							<span class="beforePrice">
								<fmt:formatNumber value="${dto.selling_price }" pattern="#,###"/>원
							</span>
						</div>	
	  				</div>
	  			</td>
	  			<td>${dto.product_maker }</td>
	  			<td>무료</td>
	  			<td>${dto.volume_order } EA</td>
	  			<td>(-) <fmt:formatNumber value="${discount_price * dto.volume_order }" pattern="#,###"/>원</td>
	  			<td class="orderPriceBody">
	  				<span class="totBeforePrice">
	  					<fmt:formatNumber value="${dto.selling_price * dto.volume_order }" pattern="#,###"/>원
	  				</span><br>
	  				<span class="totAfterPrice">
	  					<fmt:formatNumber value="${(dto.selling_price - discount_price) * dto.volume_order }" pattern="#,###"/>원
	  				</span>
	  			</td>
	  		</tr>
	  		
	  		<c:set var="orderCartNo" value="${orderCartNo},${dto.cart_no }"  />
	  		<c:set var="totSellingPrice" value="${totSellingPrice = totSellingPrice + (dto.selling_price * dto.volume_order) }" />
			<c:set var="totDeliveryPrice" value="${totDeliveryPrice = totDeliveryPrice + delivery_price }" />
			<c:set var="totSalePrice" value="${totSalePrice = totSalePrice + (discount_price * dto.volume_order) }" />
			<c:set var="totOrderPrice" value="${totOrderPrice = totOrderPrice + (dto.selling_price - discount_price) * dto.volume_order + delivery_price  }" />
		  	</c:forEach>
	  	</tbody>	  
	</table>
	
	<!-- 배송지 정보 -->
	<div class="orderInfo_wrapper">
		<div class="shippingAddr_wrapper shadow-sm p-3 mb-1 bg-body rounded">
			<div class="shippingAddr">
				<div class="shipTitle">배송지정보</div>
				<div>
					<span class="selectAddr">배송지 선택</span>
					<c:if test="${!(memberInfo.no == null || memberInfo.no == '0') }">
						<input type="radio" name="selectAddr" value="home" id="radioHome"> 집
					</c:if>					
					<input type="radio" name="selectAddr" value="inputAddr" id="radioInputAddr" class="inputAddr"> 직접 입력							
				</div>
				
				<!-- 집주소 -->
				<div class="shippingAddrInfo">
					<div><hr></div>				
					<div>${memberInfo.name } (집)</div>
					<div>${memberInfo.phone }</div>
					<div>
						(${memberInfo.addr_no }) ${memberInfo.addr1 }  ${memberInfo.addr2 }
						<c:if test="${memberInfo.addr3 != '-' }" >						
							${memberInfo.addr3 }
						</c:if>
					</div>
					<div class="shipMemo">
						<span>배송메모</span>
						<input type="text" placeholder="요청사항을 직접 입력합니다." class="form-control w-75">
					</div>
				</div>
				
				<!-- 주소입력 -->
				<form name="orderForm">
				<table class="addrInputTable" style="display: none;">
					<tr>
						<th>수령인</th>
						<td><input type="text" name="name" id="" value="${memberInfo.name }" class="tbShipInfoName form-control w-75" placeholder="수령인"></td>
					</tr>
					<tr>
						<th>연락처</th>
						<td><input type="text" name="phone" id="" value="${memberInfo.phone }" class="tbShipInfoPhone form-control w-75" placeholder="휴대전화 (-없이 번호만)"></td>
					</tr>
					<tr class="tbShipAddr">
						<th>배송지 주소</th>
						<td>
							<div>
								<input type="text" name="addr_no" id="sample3_postcode" value="${memberInfo.addr_no }" placeholder="우편번호" class="form-control w-25">
								<input type="button" onclick="sample3_execDaumPostcode()" value="우편번호 찾기" class="btn btn-outline-primary btn-sm w-25">
							</div>
							<div>
								<input type="text" name="addr1" id="sample3_address" value="${memberInfo.addr1 }" placeholder="주소" class="form-control">
							</div>
							<div>
								<input type="text" name="addr2" id="sample3_detailAddress" value="${memberInfo.addr2 }" placeholder="상세주소" class="form-control w-50">
								<input type="text" name="addr3" id="sample3_extraAddress" value="${memberInfo.addr3 }" placeholder="참고항목" class="form-control w-50">
							</div>
							<div id="wrap" style="display:none;border:1px solid;width:500px;height:400px;margin:-200px auto auto 450px;position:absolute;background-color: white; overflow: hidden;z-index:4;">
								<img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:relative;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
							</div>
						</td>
					</tr>
					<tr>
						<th>배송메모</th>
						<td><input type="text" name="request_term" placeholder="요청사항을 직접 입력해 주세요." class="tbShipMemo form-control"></td>
					</tr>
				</table>
				<input type="hidden" name="orderCartNo" value="${orderCartNo }" >
				<c:if test="${orderCartNo == ',0' }">
					<input type="hidden" name="product_no" value="${product_no }" >
					<input type="hidden" name="volume_order" value="${volume_order }" >
					<input type="hidden" name="add_sale" value="${add_sale }" >
				</c:if>
				</form>
			</div>
		</div>		
		
		<!-- 결제상세 -->
		<div class="payInfo_wrapper shadow-sm p-3 mb-1 bg-body rounded">
			<div class="payInfo">
				<div class="payInfoTitle">결제상세</div>				
				<table class="payInfoTb">					
					<tr>
						<th>주문금액</th>
						<th>
							<span><fmt:formatNumber value="${totOrderPrice }" pattern="#,###"/> 원</span>
						</th>
					</tr>
					<tr>
						<td><span>ㄴ</span> 상품금액</td>
						<td>
							<fmt:formatNumber value="${totSellingPrice }" pattern="#,###"/> 원
						</td>
					</tr>
					<tr>
						<td><span>ㄴ</span> 배송비</td>
						<td>
							+ <fmt:formatNumber value="${totDeliveryPrice }" pattern="#,###"/> 원						
						</td>
					</tr>
					<tr>
						<td><span>ㄴ</span> 할인금액</td>
						<td>
							- <fmt:formatNumber value="${totSalePrice }" pattern="#,###"/> 원						
						</td>
					</tr>
					<tr>
						<td colspan="2"><hr></td>
					</tr>
					<tr class="totPayPrice">
						<th>계좌 간편결제</th>
						<th>
							<fmt:formatNumber value="${totOrderPrice }" pattern="#,###"/> 원
						</th>
					</tr>
				</table>			
			</div>
			<div class="payBtn">
				<button type="button" onClick="order();" class="btn btn-danger btn-lg">결제하기</button>
			</div>		
		</div>
	</div>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
function order() {
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
	orderForm.method = "post";
	orderForm.action = "${path }/order_servlet/orderProc.do";
	orderForm.submit();
}
$(function() {
	var memberNo = ${memberInfo.no };
	
	if(memberNo == null || memberNo == '0') {
		$('.shippingAddrInfo').hide();
		$('#radioInputAddr').attr('checked', true);
		$('#radioInputAddr').css('margin-left', '0');		
		
		$(".addrInputTable").show();
		$(".shippingAddrInfo").hide();
		$(".addrInputTable").show();
		$("input[name=name]").val('');
		$("input[name=phone]").val('');
		$("input[name=addr_no]").val('');
		$("input[name=addr1]").val('');
		$("input[name=addr2]").val('');
		$("input[name=addr3]").val('');
	} else {
		$('#radioHome').attr('checked', true);
	}
	
	$("input[name=selectAddr]").change(function() {
		if($(this).val() == 'home') {
			$(".shippingAddrInfo").show();
			$(".addrInputTable").hide();
			$("input[name=name]").val('${memberInfo.name }');
			$("input[name=phone]").val('${memberInfo.phone }');
			$("input[name=addr_no]").val('${memberInfo.addr_no }');
			$("input[name=addr1]").val('${memberInfo.addr1 }');
			$("input[name=addr2]").val('${memberInfo.addr2 }');
			$("input[name=addr3]").val('${memberInfo.addr3 }');
		} else if($(this).val() == 'inputAddr') {
			$(".shippingAddrInfo").hide();
			$(".addrInputTable").show();
			$("input[name=name]").val('');
			$("input[name=phone]").val('');
			$("input[name=addr_no]").val('');
			$("input[name=addr1]").val('');
			$("input[name=addr2]").val('');
			$("input[name=addr3]").val('');
		}
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