<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../_include/inc_header.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문/배송조회 결과</title>

<link rel="stylesheet" type="text/css" href="../_resources/css/main.css" >
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
			
			<!-- 결제금액 계산 -->
			<c:set var="totOrderPrice" value="${totOrderPrice = 0 }" />
			<c:set var="totSalePrice" value="${totSalePrice = 0 }" />
			<c:set var="totDeliveryCharge" value="${totDeliveryCharge = 0 }" />
			
			<!-- 환불금액 계산 -->
			<c:set var="totRefundPrice" value="${totRefundPrice = 0 }" />
			<c:set var="totRefundSale" value="${totRefundSale = 0 }" />
			<c:set var="totRefundDeliverFee" value="${totRefundDeliverFee = 0 }" />
			
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
				
				<c:set var="totRefundPrice" value="${totRefundPrice = totRefundPrice + prodDto.selling_price * prodDto.volume_order }" />
				<c:set var="totRefundSale" value="${totRefundSale = totRefundSale + prodDto.selling_price * prodDto.volume_order * (prodDto.sale_percent / 100 ) }" />				
				<c:set var="totRefundDeliverFee" value="${totRefundDeliverFee = totRefundDeliverFee + prodDto.delivery_charge }" />
				</c:if>
				
			</tr>
			<c:set var="totOrderPrice" value="${totOrderPrice = totOrderPrice + prodDto.selling_price * prodDto.volume_order }" />
			<c:set var="totSalePrice" value="${totSalePrice = totSalePrice + prodDto.selling_price * prodDto.volume_order * (prodDto.sale_percent / 100 ) }" />				
			<c:set var="totDeliveryCharge" value="${totDeliveryCharge = totDeliveryCharge + prodDto.delivery_charge }" />
			<c:set var="count" value="${count = count + 1 }" />
			</c:forEach>
		</table>
		
		<!-- 주문/결제 금액 정보 -->
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
		
		<!-- 환불금액 금액 정보 -->
		<c:if test="${totRefundPrice > 0 }">
		<div class="orderViewRefundInfoTitle">
			환불금액 금액 정보
		</div>
		<table class="orderViewRefundInfoTB">
			<tr>
				<td>└ 취소상품 금액 합계</td>
				<td>
					<fmt:formatNumber value="${totRefundPrice }" pattern="#,###"/> 원
				</td>
				<td rowspan="3">
					<span>최종 환불금액</span>
					<fmt:formatNumber value="${totRefundPrice +  totRefundDeliverFee - totRefundSale}" pattern="#,###"/> 원
				</td>
			</tr>
			<tr>
				<td>└ 취소 배송비 합계</td>
				<td>
					<fmt:formatNumber value="${totRefundDeliverFee }" pattern="#,###"/> 원						
				</td>
			</tr>
			<tr>
				<td>└ 상품/주문할인 취소</td>
				<td>
					(-) <fmt:formatNumber value="${totRefundSale }" pattern="#,###"/> 원						
				</td>
			</tr>				
		</table>	
		</c:if>	
		
		<!-- 배송지 정보 -->
		<div class="orderViewShipTitle">
			배송지 정보
		</div>	
		<table class="orderViewShipTB">
			<tr>
				<td>수령인</td>
				<td>${dto.name }</td>
			</tr>
			<tr>
				<td>연락처</td>
				<td>${dto.phone }</td>
			</tr>
			<tr>
				<td class="orderViewShipAddr">배송지</td>			
				<td>
					<div>${dto.addr_no }</div>
					<div>
						${dto.addr1 }
						<c:if test="${dto.addr2 != '-' }">
							${dto.addr2 }
						</c:if>
					</div>
					<div>
						<c:if test="${dto.addr3 != '-' }" >
							${dto.addr3 }
						</c:if>
					</div>						
				</td>
			</tr>
			<tr>
				<td>배송메모</td>
				<td>${dto.request_term }</td>
			</tr>
		</table>	
	</div>
</div>
<div class="findOrderResultBlank">
	
</div>

<!-- footer -->
<div class="footer-wrapper">
	<%@include file="../_include/inc_footer.jsp" %>
</div>


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
</script>