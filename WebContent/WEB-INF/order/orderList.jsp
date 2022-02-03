<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../_include/inc_header.jsp" %>

<div class="orderList_wrapper">	
	<div class="orderListTitle">
		<span>주문 / 배송조회</span>
	</div>	
	<div class="orderSearch">
		<div class="orderSearchTitle">
			<span>조회기간</span>
		</div>	
		<div class="orderSearchArea">
			<div class="searchList btn-group">
				<button id="oneWeek" onClick="oneWeek();">1주일</button>
				<button id="oneMon" onClick="oneMon();">1개월</button>
				<button id="threeMon" onClick="threeMon();">3개월</button>
				<button id="sixMon" onClick="sixMon();">6개월</button>
			</div>
			<form name="orderForm" class="orderForm">
			<div class="searchPeriod">
				<input type="date" name="searchStart" id="searchStart" value="${searchStart }" class="form-control" >
				<span>~</span>
				<input type="date" name="searchEnd" id="searchEnd" value="${searchEnd }" class="form-control" >
				<button type="button" onClick="orderSearch();" class="btn btn-danger">조회</button>				
			</div>
			</form>
		</div>
	</div>
	
	<c:choose>
		<c:when test="${fn:length(dateList) != 0 }">
				
		<c:forEach var="orderYM" items="${dateList }">
		<c:set var="orderYM" value="${fn:replace(orderYM, '-', '.') }" />
		<div class="orderMon">
			<div class="beforeHr"><hr></div>
			<div class="orderMonDiv">${orderYM }</div>
			<div class="afterHr"><hr></div>
		</div>
			<c:set var="cnt" value="${cnt = 0 }" />
			
			<c:forEach var="dto" items="${list }">
			
			<c:set var="infoThumImg" value="${fn:split(dto.info_thumbImg, '|')[0] }"/>
			<c:set var="thumImg" value="${fn:split(infoThumImg, ',')[1] }"/>
			<c:set var="prodPrice" value="${dto.selling_price * dto.volume_order * (100 - dto.sale_percent) / 100 }" />		
			<fmt:formatDate var="orderDate" pattern="yyyy.MM" value="${dto.order_date }" />
			
			<c:if test="${orderYM == orderDate }">
			<c:if test="${cnt != 0 }"><hr></c:if>
			<div class="orderList">
				<div class="orderThumImg">
					<a href="${path }/order_servlet/orderView.do?orderNo=${dto.order_no }">
						<img src="${path }/attach/product_img/${thumImg }" class="orderThumImg_img">
					</a>
				</div>
				<div class="orderInfomation_wrapper">
					<div class="orderInfomation">
						<div class="orderProdName">
							<a href="${path }/order_servlet/orderView.do?orderNo=${dto.order_no }">${dto.product_name }</a>
						</div>							
						<div class="orderPriceNDate">
							<a href="${path }/order_servlet/orderView.do?orderNo=${dto.order_no }">
							<fmt:formatNumber value="${prodPrice }" pattern="#,###"/>원
							<span class="orderDivision">|</span>
							<span class="orderDateSpan">
								<fmt:formatDate pattern="yyyy.MM.dd" value="${dto.order_date }" />
							</span>
							</a>
						</div>						
						<div class="orderStatus">
							${dto.status }
						</div>												
						<div style="height: 5px; margin: auto;"><hr></div>	
						<div>
							<c:if test="${dto.status == '결제완료' }">
								주문 확인 중입니다. 조금만 기다려주세요!
							</c:if>
							<c:if test="${dto.status == '구매확정' }">
								구매가 완료되었습니다. 이용해주셔서 감사합니다.
							</c:if>
							<c:if test="${dto.status == '취소완료' }">
								취소처리가 완료 되었습니다.
							</c:if>
						</div>
					</div>
				</div>
				<div class="orderInfoMaker_wrapper">
					<div class="orderInfoMaker">	
						<div><span>${dto.product_maker }</span></div>
						<div><button type="button" onClick="inquiry(${dto.order_no })">문의하기</button></div>
					</div>								
				</div>						
				<div class="repurchase_wrapper">
					<div class="repurchase">
					<c:if test="${dto.status == '결제완료' }">	
						<div><a href="javascript:orderCancel('${dto.order_product_no}');">취소요청</a></div>
						<div><a href="javascript:sujungAddr('${dto.order_no}');" >배송지변경</a></div>
					</c:if>
					<c:if test="${dto.status == '구매확정' }">					
						<div><a href="javascript:rePurchase('${dto.product_no}', '${dto.volume_order}', '${dto.add_sale}',);" >재구매</a></div>
					</c:if>
					<c:if test="${dto.status == '취소완료' }">	
						<div><a href="javascript:infoCancel('${dto.order_product_no}');">취소정보</a></div>
					</c:if>						
					</div>
				</div>							
			</div>
			<c:set var="cnt" value="${cnt = cnt + 1 }" />
			</c:if>
			</c:forEach>
		</c:forEach>
		
		<c:if test="${totRowCnt > fn:length(list) }">
			<button id="moreOrderList" class="moreOrderList">(+) 더보기</button>
		</c:if>		
		</c:when>
		<c:otherwise>
			<div class="noOrderGuide">주문 내역이 없습니다.</div>			
		</c:otherwise>	
	</c:choose>
</div>

<form name="orderRePurchase">
	<input type="hidden" value="" id="product_no" name="product_no">
	<input type="hidden" value="" id="volume_order" name="volume_order">
	<input type="hidden" value="" id="add_sale" name="add_sale">
</form>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
function sujungAddr(value1) { //배송지 변경
	location.href = "${path }/order_servlet/orderSujungAddr.do?orderNo=" + value1;
}
function inquiry(value1) { //문의하기
	window.open('${path}/popup_servlet/inquiry.do?orderNo=' + value1, '문의하기' + value1, 'width=520px,height=700px');
}
function orderCancel(value1) { //주문 취소
	window.open('${path}/popup_servlet/requestCancel.do?orderProductNo=' + value1, '취소요청' + value1, 'width=520px,height=700px');
}
function infoCancel(value1) { //취소 정보
	window.open('${path}/popup_servlet/infoCancel.do?orderProductNo=' + value1, '취소정보' + value1, 'width=520px,height=700px');
}
function rePurchase(value1, value2, value3) { //재구매
	$("#product_no").val(value1);
	$("#volume_order").val(value2);
	$("#add_sale").val(value3);
	document.orderRePurchase.method = "post";
	document.orderRePurchase.action = "${path }/order_servlet/orderPay.do";
	document.orderRePurchase.submit();
}
$(function() {
	$("#moreOrderList").click(function() {
		param = {
					"searchStart": "${searchStart }",
					"searchEnd": "${searchEnd }",
					"rowMultiple": "${rowMultiple + 1 }" 
				};
		$.ajax({ //비동기식
			type: "post",
			data: param,
			url: "orderList.do",
			success: function(data) {
				$("#page-wrapper").html(data);				
			},
			fail: function() {
				let msg = "<div class='failGuide'>주문내역을 추가 로드하지 못했습니다.</div>";
				$("#moreOrderList").after(msg);
				$("#moreOrderList").css('display', 'none');
			}
		});
	});
});

$(function() {	
	$(".orderStatus").each(function() {
		if($.trim($(this).text()) == '취소완료') {
			$(this).css('color', 'red');
		}
	});
});

function orderSearch() {		
	var searchStart = $("#searchStart").val();
	var searchEnd = $("#searchEnd").val();

	if(searchStart == "") {
		alert('조회기간을 입력하세요');
		orderForm.searchStart.focus();
		return;
	}
	if(searchEnd == "") {
		alert('조회기간을 입력하세요');
		orderForm.searchEnd.focus();
		return;
	}
	if(searchStart != "" && searchEnd != "") {
		orderForm.method = "post";
		orderForm.action = "${path}/order_servlet/orderList.do";
		orderForm.submit();
	}
}

function oneWeek() {
	$searchEnd = $("#searchEnd").val();
	var now = new Date($searchEnd);
	var month;
	var day;

	now.setDate(now.getDate() - 7);  // 일주일 검색	
	
	if(now.getDate() < 10) {
		day = "0" + now.getDate();
	} else {
		day = now.getDate();
	}	
	if(now.getMonth() + 1 < 10) {
		month = now.getMonth() + 1;
		month = "0" + month;
	} else {
		month = now.getMonth() + 1;
	}	
	var oneWeekAgo = now.getFullYear() + "-" + month + "-" + day;
	
	$("#searchStart").val(oneWeekAgo);
	$("#oneWeek").css("border", "1px solid #dc3545");
	$("#oneWeek").css("color", "#dc3545");
	$("#oneMon").css("border", "1px solid #ddd");
	$("#oneMon").css("color", "black");
	$("#oneMon").css("border-left", "none");
	$("#oneMon").css("border-right", "none");
	$("#threeMon").css("border", "1px solid #ddd");
	$("#threeMon").css("color", "black");
	$("#threeMon").css("border-right", "none");
	$("#sixMon").css("border", "1px solid #ddd");
	$("#sixMon").css("color", "black");
}

function oneMon() {
	$searchEnd = $("#searchEnd").val();
	var now = new Date($searchEnd);	
	var month;
	var day;
	now.setMonth(now.getMonth() - 1 ); // 1개월 검색
	
	if(now.getDate() < 10) {
		day = "0" + now.getDate();
	} else {
		day = now.getDate();
	}	
	if(now.getMonth() + 1 < 10) {
		month = now.getMonth() + 1;
		month = "0" + month;
	} else {
		month = now.getMonth() + 1;
	}	
	var oneMonAgo = now.getFullYear() + "-" + month + "-" + day;  
	$("#searchStart").val(oneMonAgo);
	
	$("#oneWeek").css("border", "1px solid #ddd");
	$("#oneWeek").css("color", "black");
	$("#oneWeek").css("border-right", "none");
	$("#oneMon").css("border", "1px solid #dc3545");
	$("#oneMon").css("color", "#dc3545");
	$("#threeMon").css("border", "1px solid #ddd");
	$("#threeMon").css("color", "black");
	$("#threeMon").css("border-right", "none");
	$("#sixMon").css("border", "1px solid #ddd");
	$("#sixMon").css("color", "black");
}

function threeMon() {
	$searchEnd = $("#searchEnd").val();
	var now = new Date($searchEnd);	
	var month;
	var day;
	now.setMonth(now.getMonth() - 3 );
	
	if(now.getDate() < 10) {
		day = "0" + now.getDate();
	} else {
		day = now.getDate();
	}	
	if(now.getMonth() + 1 < 10) {
		month = now.getMonth() + 1;
		month = "0" + month;
	} else {
		month = now.getMonth() + 1;
	}	
	var threeMonAgo = now.getFullYear() + "-" + month + "-" + day;  
	$("#searchStart").val(threeMonAgo);
	
	$("#oneWeek").css("border", "1px solid #ddd");
	$("#oneWeek").css("color", "black");
	$("#oneWeek").css("border-right", "none");
	$("#oneMon").css("border", "1px solid #ddd");
	$("#oneMon").css("color", "black");
	$("#oneMon").css("border-right", "none");
	$("#threeMon").css("border", "1px solid #dc3545");
	$("#threeMon").css("color", "#dc3545");
	$("#sixMon").css("border-left", "none");
	$("#sixMon").css("border", "1px solid #ddd");
	$("#sixMon").css("color", "black");
}

function sixMon() {
	$searchEnd = $("#searchEnd").val();
	var now = new Date($searchEnd);	
	var month;
	var day;
	now.setMonth(now.getMonth() - 6);
	
	if(now.getDate() < 10) {
		day = "0" + now.getDate();
	} else {
		day = now.getDate();
	}	
	if(now.getMonth() + 1 < 10) {
		month = now.getMonth() + 1;
		month = "0" + month;
	} else {
		month = now.getMonth() + 1;
	}	
	var sixMonAgo = now.getFullYear() + "-" + month + "-" + day;  
	$("#searchStart").val(sixMonAgo);
	
	$("#oneWeek").css("border", "1px solid #ddd");
	$("#oneWeek").css("color", "black");
	$("#oneWeek").css("border-right", "none");
	$("#oneMon").css("border", "1px solid #ddd");
	$("#oneMon").css("color", "black");
	$("#oneMon").css("border-right", "none");
	$("#threeMon").css("border", "1px solid #ddd");
	$("#threeMon").css("color", "black");
	$("#threeMon").css("border-right", "none");
	$("#sixMon").css("border", "1px solid #dc3545");
	$("#sixMon").css("color", "#dc3545");
}

</script>
