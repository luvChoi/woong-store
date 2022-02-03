<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@include file="../_include/inc_header.jsp" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 취소요청</title>

<link rel="stylesheet" type="text/css" href="../_resources/css/popup.css" >
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<h1 class="requestCancel_title"><span>주문</span> 취소요청</h1>

<div class="requestCancel_wrapper">
	<div class="requestCancel_guide">
		상품주문번호 단위로 취소요청이 가능합니다.<br>
		상품이 발송되기 전에 주문 취소요청을 하실 수 있습니다.
	</div>
	
	<table class="infoCancelProdOrderTB">
		<tr>
			<td><b>상품주문번호</b></td>
			<td>상품명</td>	
			<td>주문수량</td>
			<td>진행상태</td>
		</tr>
		<tr>
			<td class="OrderProdNo">${dtoOrder.order_product_no }</td>
			<td>${dtoOrder.product_name }</td>
			<td><b>${dtoOrder.volume_order }</b>개</td>
			<td>${dtoOrder.status }</td>
		</tr>
	</table>
	
	<form name="requestCancelForm">
	<div class="cancelReason_title">취소사유</div>
	<input type="hidden" name="orderProductNo" value="${dtoOrder.order_product_no }">
	<table class="cancelReasonTB">
		<tr>
			<td>사유선택</td>
			<td>
				<select name="cancel_type" class="form-select">
					<option value="" selected>취소사유를 선택해주세요.</option>
					<c:forEach var="dto" items="${cancelTypeList }">
						<option value="${dto.typeNo }">${dto.cancelTypeStr }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td>사유입력</td>
			<td>
				<textarea name="cancel_reason" class="form-control" ></textarea>
			</td>
		</tr>
	</table>
	
	<div class="requestCancelbtnArea">
		<button type="button" onClick="requestCancel();">취소요청하기</button>
	</div>
	</form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
function requestCancel() {	
	if(requestCancelForm.cancel_type.value == "") {
		alert('취소사유를 선택해주세요.');
		requestCancelForm.cancel_type.focus();
		return;
	}
	if(requestCancelForm.cancel_reason.value == "") {
		alert('취소사유를 입력해주세요.');
		requestCancelForm.cancel_reason.focus();
		return;
	}
	requestCancelForm.method = "post";
	requestCancelForm.action = "${path }/popup_servlet/requestCancelProc.do";
	requestCancelForm.submit();
}		
</script>

</body>
</html>