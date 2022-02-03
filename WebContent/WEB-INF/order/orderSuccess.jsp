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
			<span style="font-weight: bold; color: #C8C8C8;"> >&nbsp;&nbsp;주문/결제&nbsp;&nbsp;></span>
			<span class="text-dark fw-bold ms-2">완료</span>
		</div>	
	</div>	
	
	<!-- 결제정보 -->
	<div class="orderInfo_wrapper">	
		<!-- 배송지 & 결제 -->
		<div class="shipAndPay_wrapper">
			<div class="successTitle">				
				<span>주문이 정상적으로 완료</span>되었습니다.				
			</div>
			<div class="successShipInfo">
				<table class="successShipInfoTB">
					<tr>
						<th>주문번호</th>
						<td class="successOrderNo">${dto.order_no }</td>
					</tr>
					<tr>
						<th>배송지정보</th>
						<td>						
							<div>${dto.name }</div>
							<div>${dto.phone }</div>							
							<div>(${dto.addr_no }) ${dto.addr1 } 
								<c:if test="${dto.addr2 != '-' }" >
									${dto.addr2 }
								</c:if>
							</div>							
							<c:if test="${dto.addr3 != '-' }" >
								<div>${dto.addr3 }</div>
							</c:if>										
						</td>
					</tr>
				</table>
			</div>			
		</div>
		
		<!-- 상품 정보 -->
		<div class="successProdInfo_wrapper">
			<div class="successProdInfo">
			<c:set var="totOrderPrice" value="${totOrderPrice = 0 }" />
			<c:set var="totSalePrice" value="${totSalePrice = 0 }" />
			<c:set var="totDeliveryCharge" value="${totDeliveryCharge = 0 }" />			
				<table class="successProdInfoTB">
				<c:forEach var="prodDto" items="${dto.orderProdList }">
				<c:set var="infoThumImg" value="${fn:split(prodDto.info_thumbImg, '|')[0] }"/>
				<c:set var="thumImg" value="${fn:split(infoThumImg, ',')[1] }"/>
					<tr>
						<td class="successProdImg">
							<img src="${path }/attach/product_img/${thumImg }">
						</td>
						<td class="successProdInfo">
							<div class="successProdMaker">${prodDto.product_maker }</div>
							<div>${prodDto.product_name }</div>
							<div><fmt:formatNumber value="${prodDto.selling_price * prodDto.volume_order * (100 - prodDto.sale_percent) / 100}" pattern="#,###"/> 원</div>
						</td>
					</tr>
				<c:set var="totOrderPrice" value="${totOrderPrice = totOrderPrice + prodDto.selling_price * prodDto.volume_order }" />
				<c:set var="totSalePrice" value="${totSalePrice = totSalePrice + prodDto.selling_price * prodDto.volume_order * (prodDto.sale_percent / 100 ) }" />				
				<c:set var="totDeliveryCharge" value="${totDeliveryCharge = totDeliveryCharge + prodDto.delivery_charge }" />				
				</c:forEach>
				</table>
			</div>
			<div class="successPayInfo">
				<table class="successPayInfoTb">					
					<tr>
						<th>주문금액</th>
						<th>
							<span><fmt:formatNumber value="${totOrderPrice +  totDeliveryCharge - totSalePrice}" pattern="#,###"/> 원</span>
						</th>
					</tr>
					<tr>
						<td><span>ㄴ</span> 상품금액</td>
						<td>
							<fmt:formatNumber value="${totOrderPrice }" pattern="#,###"/> 원
						</td>
					</tr>
					<tr>
						<td><span>ㄴ</span> 배송비</td>
						<td>
							+ <fmt:formatNumber value="${totDeliveryCharge }" pattern="#,###"/> 원						
						</td>
					</tr>
					<tr>
						<td><span>ㄴ</span> 할인금액</td>
						<td>
							- <fmt:formatNumber value="${totSalePrice }" pattern="#,###"/> 원						
						</td>
					</tr>					
				</table>
			</div>
		</div>
	</div>
</div>