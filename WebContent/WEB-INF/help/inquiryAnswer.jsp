<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file = "../_include/inc_header.jsp" %>

<div class="inquiryAnswer_wrapper">
	<div class="inquiryAnswerTitle">판매자 문의</div>
	<div class="inquiryAnswerSearchArea">		
		<div>
			<ul class="inquirySearchPeriod">
				<li><a href="#" id="today">오늘</a></li>
				<li><a href="#" id="oneWeek">1주일</a></li>
				<li><a href="#" id="oneMonth">1개월</a></li>
				<li><a href="#" id="threeMonth">3개월</a></li>
				<li><a href="#" id="sixMonth">6개월</a></li>
				<li><a href="#" id="oneYear">1년</a></li>
			</ul>			
			<ul class="inquirySearchSelect">
				<li><input type="radio" name="searchSelect" value="3" > 전체</li>
				<li><input type="radio" name="searchSelect" value="2" > 답변</li>
				<li><input type="radio" name="searchSelect" value="1" > 미답변</li>
				<li></li>
				<li><button type="button" onClick="searchInquiry();" class="inquirySearchBtn">조회</button></li>
			</ul>
		</div>			
	</div>
	
	<form name="inquirySearchForm">
		<input type="hidden" name="periodAgo" value="${periodAgo }"> <!-- 1개월 서치 기본 -->
		<input type="hidden" name="answerExist" value="${cntRef }">
		<input type="hidden" name="pageNo" value="1">
		<input type="hidden" name="totalPage" value="${totalPage }">
	</form>
		
	<c:if test="${fn:length(list) != 0 }">	
	<ul class="inquiryAnswerList_wrapper">	
		<!-- 반복문 위치 -->
		<c:forEach var="dto" items="${list }">
		<c:set var="infoProd" value="${dto.prodList[0].info_thumbImg }" />
		<c:set var="thumbImg" value="${fn:split(infoProd, ',')[1] }" />
		<c:set var="productNo" value="${dto.prodList[0].product_no }" />
		
		<li class="inquiryAnswerList">
			<!-- c:if) ref_step이 1일때 -->
			<c:if test="${dto.ref_step == 1 }">
			<div class=list_divider></div>
			<a href="${path }/store_servlet/view.do?no=${productNo }" class="thumb"><img src="${path }/attach/product_img/${thumbImg }" ></a>
			<div class="goods_items">
				<p><span class="answerCheck">답변대기</span><span class="infoOrderNo">주문번호 &nbsp; ${dto.order_no }</span></p>
				<div class="prodInfo">
					<a href="${path }/store_servlet/view.do?no=${productNo }" >${dto.prodList[0].product_name }</a>
				</div>
				<p class="seller">${dto.prodList[0].product_maker }</p>
				<button onClick="deleteInquiry('${dto.ref}');" class="inqSakjeBtn">삭제하기</button> <!-- ref value 물고 ref 삭제 -->				
			</div>						
			<div class="qna_items">							
				<div class="q_area">
					<span class="q_icon">Q</span>
					<div class="q_area_inquiry">
						<p>[${dto.typeStr }] ${dto.subject } <span class="divider">|</span> <fmt:formatDate value="${dto.regi_date }" /></p>
						<div class="inquiry_content">
							${dto.content }
						</div>
					</div>
				</div>
			</div>
			</c:if>
											
			<!-- c:if) ref_step이 2일때 / input : hidden으로 ref_step value 넣고, 앞의 값 변경-->
			<c:if test="${dto.ref_step == 2 }">
			<input type="hidden" name="refStepChk" value="${dto.ref_step }">
			<div class="qna_items">
				<div class="a_area">
					<span class="a_icon">A</span>
					<div class="a_area_answer">
						<p>[판매자 답변] <span class="divider">|</span> <fmt:formatDate value="${dto.regi_date }" /></p>
						<div class="answer_content">
							${dto.content }
						</div>
					</div>				
				</div>
			</div>
			</c:if>		
		</li>
		</c:forEach>		
	</ul>
	<div class="pagination_group_wrapper" >
		<div class="pagination_group" >
			<button id="toFirstBtn">&laquo;</button>
			<button id="toPrevBtn">&lt;</button>
			<c:forEach var="page" begin="${startPage }" end="${lastPage }" step="1">
				<button id="pageLink">${page }</button>
			</c:forEach>
			<button id="toNextBtn">&gt;</button>
			<button id="toLastBtn">&raquo;</button>
		</div>
	</div>
	</c:if>
	
	<!-- list size가 0일때 -->
	<c:if test="${fn:length(list) == 0 }">	
	<div class="inquiryAnswerGuide">
		작성된 판매자 문의가 없습니다.
	</div>
	</c:if>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
function searchInquiry() {
	inquirySearchForm.method = "post";
	inquirySearchForm.action = "${path }/help_servlet/inquiryAnswer.do";
	inquirySearchForm.submit();
}

function deleteInquiry(value) {
	if(confirm('주문/배송문의를 삭제하시겠습니까?')) {
		location.href = "${path }/help_servlet/deleteInquiry.do?ref=" + value;
	}
}

$(function() {
	$('input[name=refStepChk]').each(function(){
		var $answerCheck = $(this).parent().prev('li').children('div').children('p').children('span.answerCheck');
		$answerCheck.text('답변완료');
		$answerCheck.css('background-color', '#FF4646');
	});		
	
	var $periodA = $('.inquirySearchPeriod').children('li').children('a');
	var $periodAgo = $('input[name=periodAgo]');
	
	$periodA.each(function() { //페이지 로딩시 검색조건 css 적용
		var thisId = $(this).attr('id');			
		if(thisId == $periodAgo.val()) {
			$(this).css({'background-color':'#6A6985', 'color':'white'});
		}
	});
	
	$periodA.on('click', function() { //검색기간 클릭시 css 적용
		var period = $(this).attr('id');
		$periodAgo.val(period); //컨트롤러에서 계산
		$periodA.css({'background-color':'white', 'color':'gray'});
		$(this).css({'background-color':'#6A6985', 'color':'white'});
	});
	
	var $answerInput = $('.inquirySearchSelect').children('li').children('input');
	var $answerExist = $('input[name=answerExist]');
	
	$answerInput.each(function() { //페이지 로딩시 답변조건 css 적용
		var $thisVal = $(this).val();			
		if($thisVal == $answerExist.val()) {
			$(this).prop('checked', 'true');
		}
	});
	
	$('input[name=searchSelect]').on('click', function() {
		var answerVal = $(this).val();
		$answerExist.val(answerVal);
	});
	
	//현재 페이지 표시(페이지박스)
	$('button[id=pageLink]').each(function() {
		var thisVal = $(this).text();
		if(thisVal == '${pageNo}') {
			$(this).css({
				'color': 'black',
				'font-weight': 'bold',
				'text-decoration': 'underline'
			});
			$(this).attr('disabled', 'true');
		}
	});
	
	//페이지 버튼 비활성화
	var startPage = ${startPage };
	var lastPage = ${lastPage };
	var totalPage = ${totalPage };
	
	if(startPage == "1") {
		$('#toFirstBtn').attr('disabled', 'true');
		$('#toPrevBtn').attr('disabled', 'true');
	}
	if(lastPage == totalPage) {
		$('#toNextBtn').attr('disabled', 'true');
		$('#toLastBtn').attr('disabled', 'true');
	}
	
	//페이징
	var currentPage = ${pageNo };
	var totalPage = ${totalPage };
	var $pageBtn = $('.pagination_group').children('button');
	
	if(currentPage == "1") {
		$('#toFirstBtn').attr('disabled', 'true');
		$('#toPrevBtn').attr('disabled', 'true');
	}
	if(currentPage == totalPage) {
		$('#toNextBtn').attr('disabled', 'true');
		$('#toLastBtn').attr('disabled', 'true');
	}
	
	$pageBtn.on('click', function() {
		var thisId = $(this).attr('id');
		var $pageNo = $('input[name=pageNo]');
		var toPage = '0';
		
		if(thisId == 'toFirstBtn') {
			toPage = '1';
		} else if(thisId == 'toPrevBtn') {
			toPage = ${startPage - 1 };
		} else if(thisId == 'pageLink') {
			toPage = $(this).text();
		} else if(thisId == 'toNextBtn') {
			toPage = ${lastPage + 1 };
		} else if(thisId == 'toLastBtn') {
			toPage = ${totalPage };
		}
		$pageNo.val(toPage);
		
		inquirySearchForm.method = "post";
		inquirySearchForm.action = "${path }/help_servlet/inquiryAnswer.do";
		inquirySearchForm.submit();
	});	
});
</script>
