<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@include file="../_include/inc_header.jsp" %>

<div class="my-3">
	<span class="text-dark fs-5 fw-bold ms-1 me-2">제품구매</span>
	<span class="text-secondary fs-5"> | </span>	
	<span class="text-secondary fs-5 ms-2"> 장바구니</span>
</div>

<!--<c:if test="${!(sessionScope.cookCartCnt == 0 || sessionScope.cookCartCnt == null)}"> -->
<div class="cart_list border-top border-dark border-1">
	<!-- 헤더 -->
	<div class="cart_list_title row border-bottom border-dark border-1 mx-auto">
		<div class="col-1 d-flex align-items-center justify-content-center">
			<div class="form-check my-3">
				<input type="checkbox" name="cartSelectAll" id="cartSelectAll" class="form-check-input align-middle" checked>
			</div>
		</div>
		<div class="col-5">
			<div class="d-flex align-items-center justify-content-center my-3 px-0">
				<span class="fw-bold">상품정보</span>
			</div>
		</div>
		<div class="col-3">
			<div class="d-flex align-items-center justify-content-center my-3 px-0">
				<span class="fw-bold">옵션</span>
			</div>			
		</div>
		<div class="col-2">
			<div class="d-flex align-items-center justify-content-center my-3 px-0">
				<span class="fw-bold">상품금액</span>
			</div>
		</div>
		<div class="col-1">
			<div class="d-flex align-items-center justify-content-center my-3 px-0">
				<span class="fw-bold me-1">배송비</span>
				<!-- <a href="#" id="info_delivery">
					<img src="../_resources/images/info_delivery.png" style="height: 20px; width: 20px;">					
				</a> -->
			</div>
		</div>
	</div>
	
	<!-- 레코드 -->
	<c:set var="k" value="${k = 0 }" />
	<c:set var="totSellingPrice" value="${totSellingPrice = 0 }" />
	<c:set var="totDeliveryPrice" value="${totDeliveryPrice = 0 }" />
	<c:set var="totSalePrice" value="${totSalePrice = 0 }" />
	<c:set var="totOrderPrice" value="${totOrderPrice = 0 }" />
	<c:forEach var="dto" items="${list }">	
	<c:set var="info_thum" value="${fn:split(dto.info_thumbImg, '|')[0] }" />
	<c:set var="prodImg" value="${fn:split(info_thum, ',')[1] }" />	
	<div class="cart_list row border-bottom border-1 mx-auto">
		<div class="col-1 d-flex align-items-center justify-content-center">
			<div class="form-check my-3">
				<input type="checkbox" name="cartSelect" id="cartSelect" value="${dto.cart_no }" class="form-check-input align-middle" checked>
			</div>
		</div>
		<div class="col-5 border-end">
			<div class="d-flex align-items-center justify-content-center my-3 px-0">		
				<div class="cart_prodImg d-flex align-items-center">
					<a href="${path }/store_servlet/view.do?no=${dto.product_no }" class="text-decoration-none">
						<img src="${path }/attach/product_img/${prodImg }" >
					</a>
				</div>
				<div class="cart_prodInfo d-flex flex-column justify-content-center ms-3">
					<div class="d-flex align-items-center">
						<span id="prod_maker" class="text-secondary text-decoration-underline">${dto.product_maker }</span>
					</div>
					<div class="my-1">
						<a href="${path }/store_servlet/view.do?no=${dto.product_no }" class="text-decoration-none">
							<span id="prod_name" class="fw-bold">${dto.product_name }</span>
						</a>
					</div>
					<div>
					<c:set var="discount_price" value="${dto.selling_price * (dto.sale_percent + add_sale) / 100 }" />
						<span id="prod_purPrice" class="me-1">
							<b><fmt:formatNumber value="${dto.selling_price - discount_price}" pattern="#,###"/>원</b>
						</span>
						<span id="befor_sale" class="text-secondary text-decoration-line-through">
							<fmt:formatNumber value="${dto.selling_price }" pattern="#,###"/>
						</span>
					</div>
				</div>
				<div class="cart_delete">
					<a href="#" onclick="clearOne('${dto.cart_no }');" class="d-flex justify-content-end opacity-50">
						<img src="../_resources/images/x_button.png" style="height: 15px; width: 15px;">
					</a>
				</div>
			</div>
		</div>
		<div class="col-3 border-end d-flex flex-column align-items-center justify-content-center">
			<div class="d-flex align-items-end border-bottom text-center w-100 h-50 pb-2">	
				<span class="text-secondary ms-3 me-2">제품수 : </span><b><fmt:formatNumber value="${dto.volume_order }" pattern="#,###"/>개</b>				
			</div>
						
			<div class="d-flex align-items-center w-100 h-50">
				<div class="d-flex justify-content-center mx-3">				
					<ul class="nav align-items-center pagination pagination-sm">
				  		<li class="page-item">
				  			<a href="javascript:upDown()" id="btnD" onClick="upDown('d', '${k }');" style="width: 33px;" class="page-link text-center text-secondary" >-</a>
				    	</li>
				    	<li class="page-item">
				    		<input type=text id="volume_order_${k }" value="${dto.volume_order }" style="width: 40px;" class="page-link text-center text-dark">
				    	</li>
				    	<li class="page-item">
				    		<a href="javascript:upDown()" id="btnU" onClick="upDown('u', '${k }');" style="width: 33px;" class="page-link text-center text-secondary" >+</a>
				    	</li>				    	
					</ul>
					<a href="#" onClick="volUpdate('${dto.cart_no}', '${dto.volume_order }', '${k }');" type="button" class="btn btn-outline-secondary btn-sm ms-2">수량변경</a>
				</div>																			
			</div>
		</div>
		<div class="col-2 border-end d-flex flex-column align-items-center justify-content-center">
			<div class="px-0 my-2">
				<span>
					<b><fmt:formatNumber value="${(dto.selling_price - discount_price) * dto.volume_order}" pattern="#,###"/>원</b>
				</span>
			</div>
			<div class="px-0">
				<a href="javascript:orderOne()" onClick="orderOne('${dto.cart_no }');" class="btn btn-outline-danger btn-sm">주문하기</a>
			</div>		
		</div>
		<div class="col-1 d-flex flex-column align-items-center justify-content-center">
			<div class="mt-2 mb-1 px-0">
			<c:set var="delivery_price" value="0" />
				<c:if test="${delivery_price == 0}">
					<span class="fw-bold">무료</span>
				</c:if>
				<c:if test="${delivery_price != 0}">
					<span class="me-1">${delivery_price }</span>원
				</c:if>
			</div>
			<div class="delivery_guide text-secondary text-center">
				배송지역에 따라 배송비가 추가될 수 있습니다.
			</div>
		</div>
	</div>
	<input type="hidden" id="selling_price_${k }" value="${dto.selling_price }">
	<input type="hidden" id="delivery_price_${k }" value="${delivery_price }">
	<input type="hidden" id="discount_price_${k }" value="${discount_price }">	
	<input type="hidden" id="order_price_${k }" value="${(dto.selling_price - discount_price) * dto.volume_order + delivery_price }">
	<c:set var="k" value="${k = k + 1 }" />
	<c:set var="totSellingPrice" value="${totSellingPrice = totSellingPrice + dto.selling_price }" />
	<c:set var="totDeliveryPrice" value="${totDeliveryPrice = totDeliveryPrice + delivery_price }" />
	<c:set var="totSalePrice" value="${totSalePrice = totSalePrice + discount_price }" />
	<c:set var="totOrderPrice" value="${totOrderPrice = totOrderPrice + (dto.selling_price - discount_price) * dto.volume_order + delivery_price  }" />
	</c:forEach>
	<!-- 선택삭제 -->
	<div class="cart_select_delete row border-bottom border-1 mx-auto">
		<div class="col-1 d-flex align-items-center justify-content-center">
			<div class="form-check my-3">
				<input type="checkbox" name="prodSelectAll" id="prodSelectAll" class="form-check-input align-middle" checked>
			</div>
		</div>
		<div class="col-11">
			<div class="d-flex align-items-center my-3 px-0">
				<a href="#" onClick="selectProdSakje();" class="btn btn-light border-secondary ms-3">선택상품 삭제</a>
			</div>
		</div>
	</div>
	<!-- 주문금액 계산 -->
	<div class="cart_calc_price row border-bottom border-1 mx-auto px-0">
		<div class="container col-6 d-flex flex-column align-items-center justify-content-center border-end my-3">
			<div class="row text-center w-100">
				<div class="col-1"></div>
				<div class="col-3">총 상품금액</div>
				<div class="col-1"></div>		
				<div class="col-2">배송비</div>
				<div class="col-1"></div>
				<div class="col-3">할인예상금액</div>
				<div class="col-1"></div>		
			</div>
			<!-- 주문금액 -->
			<div class="row text-center w-100">
				<div class="col-1"></div>
				<div class="col-3">
					<span id="tot_sellingPrice" class="fw-bold align-middle">
						<fmt:formatNumber value="${totSellingPrice }" pattern="#,###" /> 원					
					</span>
				</div>		
				<div class="col-1 align-middle">
					<span class="text-secondary fs-5">+</span>
				</div>		
				<div class="col-2">
					<span id="tot_deliveryPrice" class="fw-bold align-middle">
						<fmt:formatNumber value="${totDeliveryPrice }" pattern="#,###" /> 원
					</span>
				</div>		
				<div class="col-1">
					<span class="text-secondary fs-5">-</span>
				</div>		
				<div class="col-3">
					<span id="tot_discoutedPrice" class="text-danger fw-bold align-middle">					
						<fmt:formatNumber value="${totSalePrice }" pattern="#,###" /> 원
					</span>
				</div>
				<div class="col-1"></div>	
			</div>		
		</div>
		<div class="col-6 d-flex align-items-center justify-content-center">
			<div class="row w-100">
				<div class="col text-end">
					<span class="fs-4 fw-bold">총 주문금액</span>
				</div>
				<div class="col">
					<span id="tot_orderPrice" class="text-primary fs-4 fw-bold">
						<fmt:formatNumber value="${totOrderPrice }" pattern="#,###" /> 원
					</span>
				</div>
			</div>	
		</div>
	</div>
</div>

<!-- 버튼 area -->
<div class="cart_btn_area d-flex align-items-center justify-content-center">
	<div class="my-5 mx-auto">
		<button id="orderBtn" onClick="bestList();" type="button" class="btn btn-light btn-lg border-secondary border-1 me-1">쇼핑 계속하기</button>
		<button id="orderBtn" onClick="selectOrder();" type="button" class="btn btn-danger btn-lg ms-1">주문하기</button>		
	</div>	
</div>
<!--</c:if>-->

<form name="cartListForm">
	<input type="hidden" name="orderCartNoArr" id="orderCartNoArr" value="">
	<input type="hidden" name="cart_no" value="">
	<input type="hidden" name="volume_order" value="">
</form>
<!-- 장바구니 안내 -->
<c:if test="${sessionScope.cookCartCnt == 0 || sessionScope.cookCartCnt == null}">
<div class="border-top border-dark border-1 d-flex align-items-center justify-content-center">
	<div style="margin-top: 100px;">
		<span class="text-secondary fw-bold">장바구니에 담긴 제품이 없습니다.</span>
	</div>
</div>
</c:if>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
function bestList() {
	location.href = "${path }/store_servlet/bestList.do";
}

function selectOrder() {
	var selectCartNo = "";
	$("input[name=cartSelect]").each(function(index) {
		if($(this).is(":checked") == true) {
			selectCartNo += "," + $(this).val();
		}
	});
	selectCartNo = selectCartNo.substring(1);
	$("#orderCartNoArr").val(selectCartNo);
	
	if($("input[name=cartSelect]:checked").length > 0) {
		cartListForm.method = "post";
		cartListForm.action = "${path }/order_servlet/orderPay.do";
		cartListForm.submit();
	}
}

function orderOne(value) {
	$("#orderCartNoArr").val(value);
	cartListForm.method = "post";
	cartListForm.action = "${path }/order_servlet/orderPay.do";
	cartListForm.submit();
}

function clearOne(value) { //장바구니 하나 삭제
	$("#orderCartNoArr").val(value);
	cartListForm.method = "post";
	cartListForm.action = "${path }/cart_servlet/clearProc.do";
	cartListForm.submit();
}

function selectProdSakje() { //선택 장바구니 삭제
	var selectCartNo = "";
	$("input[name=cartSelect]").each(function(index) {
		if($(this).is(":checked") == true) {
			selectCartNo += "," + $(this).val();
		}
	});
	selectCartNo = selectCartNo.substring(1);
	$("#orderCartNoArr").val(selectCartNo);
	
	if($("input[name=cartSelect]:checked").length > 0) {
		cartListForm.method = "post";
		cartListForm.action = "${path }/cart_servlet/clearProc.do";
		cartListForm.submit();
	}
}

function volUpdate(value1, value2, value3) { //수량 변경
	var volOrder = $("#volume_order_"+value3).val();
	if(volOrder != value2) {
		cartListForm.cart_no.value = value1;
		cartListForm.volume_order.value = volOrder;
		
		cartListForm.method = "post";
		cartListForm.action = "${path }/cart_servlet/updateProc.do";
		cartListForm.submit();
	}	
}

function upDown(value1, value2) { //수량 변경 버튼
	var vol = $("#volume_order_"+value2).val();
	
	if(value1 == 'd') {
		if(vol > 1) {
			vol--;
		}
	}
	if(value1 == 'u') {
		vol++;
	}
	$("#volume_order_"+value2).val(vol);
}

$("input[type=checkbox]").change(function() { //체크박스 변경 시 주문금액 변경
	var tot_sellingPrice = 0;
	var tot_deliveryPrice = 0;
	var tot_discoutedPrice = 0;
	var tot_orderPrice = 0;
	
	var totSellingPrice = document.getElementById('tot_sellingPrice');
	var totDeliveryPrice = document.getElementById('tot_deliveryPrice');
	var totDiscoutedPrice = document.getElementById('tot_discoutedPrice');
	var totOrderPrice = document.getElementById('tot_orderPrice');
	
	$("input[name=cartSelect]").each(function(index) {
		if($(this).is(":checked") == true) {
			tot_sellingPrice += parseInt($("#selling_price_"+index).val());
			tot_deliveryPrice += parseInt($("#delivery_price_"+index).val());
			tot_discoutedPrice += parseInt($("#discount_price_"+index).val());
			tot_orderPrice += parseInt($("#order_price_"+index).val());
		}
	});	
	$("#tot_sellingPrice").text(tot_sellingPrice);
	$("#tot_deliveryPrice").text(tot_deliveryPrice);
	$("#tot_discoutedPrice").text(tot_discoutedPrice);
	$("#tot_orderPrice").text(tot_orderPrice);
	
	totSellingPrice.textContent = totSellingPrice.textContent.replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " 원";
	totDeliveryPrice.textContent = totDeliveryPrice.textContent.replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " 원";
	totDiscoutedPrice.textContent = totDiscoutedPrice.textContent.replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " 원";
	totOrderPrice.textContent = totOrderPrice.textContent.replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " 원";	
});

$("#cartSelectAll").click(function() {
	if($("#cartSelectAll").prop("checked")) {
		$("input[type=checkbox]").prop("checked", true);		
	} else {
		$("input[type=checkbox]").prop("checked", false);			
	}	
});

$("#prodSelectAll").click(function() {	
	if($("#prodSelectAll").prop("checked")) {
		$("input[type=checkbox]").prop("checked", true);		
	} else {
		$("input[type=checkbox]").prop("checked", false);			
	}	
});

$("input[name=cartSelect]").click(function() {
	var checkSelect = 0;
	$("input[name=cartSelect]").each(function(index) {
		if($(this).is(":checked") == true) {
			checkSelect++;
		}	
	});
	if($("input[name=cartSelect]").length != checkSelect) {	
		$("#cartSelectAll").prop("checked", false);
		$("#prodSelectAll").prop("checked", false);		
	} else {
		$("#cartSelectAll").prop("checked", true);
		$("#prodSelectAll").prop("checked", true);
	}
});
</script>