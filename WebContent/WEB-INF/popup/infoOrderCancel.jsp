<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@include file="../_include/inc_header.jsp" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>취소 상세정보</title>

<link rel="stylesheet" type="text/css" href="../_resources/css/popup.css" >
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<h1 class="requestCancel_title"><span>취소</span> 상세정보</h1>

<div class="requestCancel_wrapper">
	<div class="requestCancel_guide">
		* 취소 완료 후에는 취소 철회가 불가합니다.
	</div>
	
	<table class="infoCancelProdOrderTB">
		<tr>
			<td><b>상품주문번호</b></td>
			<td>상품명</td>	
			<td>주문수량</td>
			<td>진행상태</td>
		</tr>
		<tr>
			<td class="OrderProdNo">${dto.order_product_no }</td>
			<td>${dto.product_name }</td>
			<td><b>${dto.volume_order }</b>개</td>
			<td>${dto.status }</td>
		</tr>
	</table>
	
	<div class="cancelReason_title">취소사유</div>
	<table class="cancelReasonTB">
		<tr>
			<td>사유선택</td>
			<td>${dto.cancelTypeStr }</td>
		</tr>
		<tr>
			<td>사유입력</td>
			<td class="cancelReasonTd">${dto.cancel_reason }</td>
		</tr>
	</table>
	
	<div class="requestCancelbtnArea">
		<button type="button" onClick="closePopup();">확인</button>
	</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
function closePopup() {
	window.close();
}		
</script>

</body>
</html>