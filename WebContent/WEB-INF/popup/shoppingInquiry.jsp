<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@include file="../_include/inc_header.jsp" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매자 문의하기</title>

<link rel="stylesheet" type="text/css" href="../_resources/css/popup.css" >
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<h1 class="shoppingInquiry_title">판매자 <span>문의하기</span></h1>

<div class="shoppingInquiry_wrapper">
	<table class="infoInquiryTB">
		<tr>
			<td>주문번호</td>
			<td class="inquiryOrderNo"><span>${orderNo }</span></td>
		</tr>
		<tr>
			<td>상품명</td>
			<td class="inquiryProdName">
				<!-- 주문상품이 하나일때 -->
				<c:if test="${fn:length(prodList) == 1}">
				<span>${prodList[0].product_name }</span>
				</c:if>
				<!-- 주문상품이 하나 이상일때 -->
				<c:if test="${fn:length(prodList) > 1}">				
				<button type="button" onClick="accordion();" class="inquiryProdList">
					${prodList[0].product_name }
				</button>
				<div class="selectProdList" style="display: none">
					<ul>
						<li>
							<input type="checkbox" id="selectAll" ><b><span>전체선택</span></b>							
						</li>
						<c:forEach var="dto" items="${prodList }">
							<li>
								<input type="checkbox" value="${dto.order_product_no }" id="selectItem"><span>${dto.product_name }</span>
							</li>				
						</c:forEach>
					</ul>
				</div>			
			</c:if>
			</td>	 
		</tr>
	</table>
	
	<form name="inquiryForm">
	<table class="shoppingInquiryTB">
		<tr>
			<td>문의유형</td>
			<td>
				<select name="type_no" class="form-select">
					<option value="" selected >문의유형 선택</option>
					<c:forEach var="dto" items="${typeList }">
						<option value="${dto.typeNo }">${dto.typeStr }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr>
			<td>제목</td>
			<td>
				<input type="text" name="subject" class=form-control>
			</td>
		</tr>
		<tr>
			<td>내용</td>
			<td>
				<textarea name="content" class="form-control" ></textarea>
			</td>
		</tr>
	</table>
	
	<div class="inquiryGuideArea">
		* 문의하신 내용에 대한 답변은 고객센터>문의/답변에서 확인하실 수 있습니다.
	</div>
	<div class="shoppingInquirybtnArea">
		<button type="button" onClick="inquiryRegist();">확인</button>
		<button type="button" onClick="closePopup();">취소</button>
	</div>
	
	<input type="hidden" name=orderNo value="${orderNo }"> <!-- 주문번호 -->
	<input type="hidden" name=inq_prodList value="${prodList[0].order_product_no }"> <!-- 문의상품리스트 -->
	</form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
function inquiryRegist() {
	if(inquiryForm.type_no.value == '') {		
		alert('문의유형을 선택하세요.');
		inquiryForm.type_no.focus();
		return;
	}
	if(inquiryForm.subject.value == '') {		
		alert('제목을 입력하세요.');
		inquiryForm.subject.focus();
		return;
	}
	if(inquiryForm.content.value == '') {		
		alert('내용을 입력하세요.');
		inquiryForm.content.focus();
		return;
	}
	document.inquiryForm.method = "post";
	document.inquiryForm.action = "${path }/popup_servlet/inquiryRegistProc.do";
	document.inquiryForm.submit();
}

function closePopup() { //문의창 닫기
	window.close();
}

function accordion() { //상품명 아코디언
	var $selectDisplay = $('.selectProdList').css('display');
	if($selectDisplay == 'none') {
		$('.selectProdList').css('display', 'block');
	}
	if($selectDisplay == 'block') {
		$('.selectProdList').css('display', 'none');
	}
}

$('input[id=selectAll]').change(function() { //아코디언 전체선택 및 해제
	var $orderProdNo = $('input[name=inq_prodList]');
	var selectProdNo = "";
	
	if($('#selectAll').prop('checked')) {
		$($('input[id=selectItem]').get().reverse()).each(function(index) {
			$(this).prop('checked', true);
			var thisNo = $(this).val();
			selectProdNo = selectProdNo + ',' + thisNo;
		});
		$orderProdNo.val(selectProdNo.substring(1));
	} else {
		$('input[id=selectItem]').each(function(index) {
			$(this).prop('checked', false);			
		});		
		$orderProdNo.val('${prodList[0].order_product_no }');
	}
	$('.inquiryProdList').html('${prodList[0].product_name }');
});

$('input[id=selectItem]').change(function() { //아코디언 상품명 표시(최상위 체크 품명 표시)
	var checkCnt = 0;
	var $orderProdNo = $('input[name=inq_prodList]');
	var selectProdNo = "";
	
	$($('input[id=selectItem]').get().reverse()).each(function(index) {
		if($(this).is(':checked') == true) {
			var thisVal = $(this).next('span').text();
			var thisNo = $(this).val();
			$('.inquiryProdList').html(thisVal);
			checkCnt ++;
			selectProdNo = selectProdNo + ',' + thisNo;	
		}
		$orderProdNo.val(selectProdNo.substring(1));
	});
	if(checkCnt == 0) {
		$('.inquiryProdList').html('${prodList[0].product_name }');
		$orderProdNo.val('${prodList[0].order_product_no }');
	}
});
</script>

</body>
</html>