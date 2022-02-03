<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../_include/inc_header.jsp" %>

<div class="nav_title">
	<span class="ms-1" id="span_1">
		<a href="${path }/store_servlet/allProduct.do" class="text-decoration-none me-2">홈</a> > 
		<a href="${path }/store_servlet/allProduct.do?classification=${dto.classification }" class="text-decoration-none mx-2">${dto.classification }</a> >
		<span class="ms-2">${dto.no }</span>
	</span>
</div>

<div class="border-bottom mb-3" id="view_area">
	<!-- 이미지 영역 -->
	<c:set var="infoImgArr" value="${fn:split(dto.info_thumbImg, '|') }" />
	<c:choose>
		<c:when test="${infoImgArr[0] != '-' }">
			<c:set var="infoThumbImg1" value="${fn:split(infoImgArr[0], ',')[1] }" />	
		</c:when>
		<c:otherwise>
			<c:set var="infoThumbImg1" value="_no_img.png" />
		</c:otherwise>	
	</c:choose>	
	<c:choose>
		<c:when test="${infoImgArr[1] != '-' }">
			<c:set var="infoThumbImg2" value="${fn:split(infoImgArr[1], ',')[1] }" />	
		</c:when>
		<c:otherwise>
			<c:set var="infoThumbImg2" value="_no_img.png" />
		</c:otherwise>	
	</c:choose>	
	<c:choose>
		<c:when test="${infoImgArr[2] != '-' }">
			<c:set var="infoThumbImg3" value="${fn:split(infoImgArr[2], ',')[1] }" />	
		</c:when>
		<c:otherwise>
			<c:set var="infoThumbImg3" value="_no_img.png" />
		</c:otherwise>	
	</c:choose>	
	
	<div class="img_wrapper">		
		<c:if test="${dto.info_thumbImg != '-|-|-' }">
		<div class="imgList">		
			<ul class="ps-0">
			<c:if test="${infoThumbImg1 != '_no_img.png' }">
				<li class="my-3">
					<a href="#" onClick="chnImg('chnImg_1');"><img id="chnImg_1" src="${path }/attach/product_img/${infoThumbImg1 }"></a>
				</li>
			</c:if>	
			<c:if test="${infoThumbImg2 != '_no_img.png' }">
				<li class="my-3">
					<a href="#" onClick="chnImg('chnImg_2');"><img id="chnImg_2" src="${path }/attach/product_img/${infoThumbImg2 }"></a>					
				</li>
			</c:if>	
			<c:if test="${infoThumbImg3 != '_no_img.png' }">
				<li class="my-3">
					<a href="#" onClick="chnImg('chnImg_3');"><img id="chnImg_3" src="${path }/attach/product_img/${infoThumbImg3 }"></a>
				</li>
			</c:if>
			</ul>
		</div>
		</c:if>
		<div class="thumbImg">
			<img id="thumbImg" src="${path }/attach/product_img/${infoThumbImg1 }">
		</div>
	</div>
	
	<!-- 주문 영역 -->
	<div id="order_wrapper">
		<div id="order_area">
			<!-- 상품명 -->
			<div class="d-flex align-items-center h-25">	
				<span class="fs-3 fw-bolder">${dto.name }</span>			
			</div>
			
			<!-- 할인적용가 -->					
			<div id="priceArea" class="d-flex align-items-center h-25 mb-3">			
				<div class="col-5 text-center">
					<span class="fs-6 fw-bold">할인적용가</span>
				</div>
				<div class="col-7">
					<div class="me-5">				
						<div class="d-flex justify-content-end text-muted text-decoration-line-through fs-6 fw-bold">
							<fmt:formatNumber value="${dto.selling_price }" pattern="#,###" /> 원
						</div>
						<div class="d-flex justify-content-end fs-5 fw-bold">
							<c:set var="salePrice" value="${dto.selling_price * (100 - dto.sale_percent) / 100 }" />
							<fmt:formatNumber value="${salePrice }" pattern="#,###" /> 원<br>
						</div>
					</div>
				</div>
			</div>
			<!-- 수량 & 버튼-->
			<div id="orderVolArea" class="d-flex flex-column h-50 my-3">	
				<div class="d-flex align-items-center p-2 row col">
					<div class="col-5 text-center">
						<span class="fs-6 fw-bold">수량</span>
					</div>
					<div class="col-6 text-end">					
						<button type="button" id="btnD" onClick="upDown('d');" class="btn btn-primary d-inline me-0" style="width: 40px;">-</button>
						<input type="text" id="volume_order" value="1" class="form-control align-middle text-center d-inline mx-0" style="width: 60px;">
						<button type="button" id="btnU" onClick="upDown('u');" class="btn btn-primary d-inline ms-0" style="width: 40px;">+</button>								
					</div>
					<div class="col-1"></div>		
				</div>
				<div class="d-flex align-items-center p-2 row col">
					<div class="col-5 text-center">
						<span class="fs-6 fw-bold">제품금액 합계</span>
					</div>
					<div class="col-6 text-end fs-4 fw-bold">						
						<span id="tot_price"><fmt:formatNumber value="${salePrice }" pattern="#,###" /></span>&nbsp;원
					</div>
					<div class="col-1"></div>
				</div>
				<hr>
				<div class="p-2 row col">
					<div class="d-flex align-items-baseline justify-content-center">
						<a href="#" onClick="cart();">
							<img src="../_resources/images/cart.png" style="height: 35px; width: 35px">						
						</a>
						<button type="button" onClick="order();" class="btn btn-danger rounded-pill btn-lg col-9 ms-3">주문하기</button>																
					</div>
				</div>	
			</div>				
		</div>
	</div>	
</div>

<form name="viewForm">
<div id="desc_area">	
	<div class="border-bottom mb-1" style="height: 50px;" >
		<span class="fs-3 fw-bold">상세설명</span>
		<input type="hidden" name="product_no" value="${dto.no }">
		<input type="hidden" name="volume_order" value="1">
		<input type="hidden" name="add_sale" value="0" > <!-- 추가 할인있을 경우 대비 -->
	</div>
	<div>
		<span class="fs-5">${dto.description }</span>
	</div>
</div>
</form>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
  
<script>
$(function() {
	$('#chnImg_1').css('border', '#000000 solid 1px');
	
	$('input[id=volume_order]').on('change', function() {
		var orderVolume = $('#volume_order').val();
		if($.isNumeric(orderVolume)) {
			if(orderVolume > 0) {
				var totPrice = ${salePrice } * orderVolume;
				totPrice = addComma(String(totPrice));
				$('#tot_price').text(totPrice);
			}
		}
	});
});

function cart() {
	viewForm.method = "post";
	viewForm.action = "${path }/cart_servlet/chugaProc.do";
	viewForm.submit();
}

function order() {
	viewForm.method = "post";
	viewForm.action = "${path }/order_servlet/orderPay.do";
	viewForm.submit();
}

function chnImg(number) {	
	var imgList = document.getElementById(number).src;
	document.getElementById('thumbImg').src = imgList;
	
	if(number == 'chnImg_1'){
		document.getElementById('chnImg_1').style.border = "#000000 solid 1px";
		document.getElementById('chnImg_2').style.border = "#E2E2E2 solid 1px";
		document.getElementById('chnImg_3').style.border = "#E2E2E2 solid 1px";
	}
	if(number == 'chnImg_2'){
		document.getElementById('chnImg_1').style.border = "#E2E2E2 solid 1px";
		document.getElementById('chnImg_2').style.border = "#000000 solid 1px";
		document.getElementById('chnImg_3').style.border = "#E2E2E2 solid 1px";
	}
	if(number == 'chnImg_3'){
		document.getElementById('chnImg_1').style.border = "#E2E2E2 solid 1px";
		document.getElementById('chnImg_2').style.border = "#E2E2E2 solid 1px";
		document.getElementById('chnImg_3').style.border = "#000000 solid 1px";
	}
}

function upDown(value1) {
	var calcPrice = document.getElementById('tot_price');					
	var vol = document.getElementById('volume_order');
	
	if(value1 == 'd') {
		if(vol.value > 1) {
			vol.value--;			
			calcPrice.textContent = ${salePrice } * vol.value;
		}
	}
	if(value1 == 'u') {
		vol.value++;
		calcPrice.textContent = ${salePrice } * vol.value;
	}
	calcPrice.textContent = addComma(calcPrice.textContent);
	viewForm.volume_order.value = vol.value;
}

function addComma(value){
    value = value.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    return value; 
}

</script>