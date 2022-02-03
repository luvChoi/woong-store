<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file = "../_include/inc_header.jsp" %>

<div class="helpSupport_wrapper">
	<div class="helpSupportTitle">고객센터 안내</div>
	
	<div class="helpUseGiude">
		<h5 class="guideTitle"><b>고객센터 이용 방법</b></h5>
		<!-- 아코디언 -->	
		<div class="accordion accordion-flush" id="accordionFlushExample">
		  <div class="accordion-item">
		    <h2 class="accordion-header" id="flush-headingOne">
		      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseOne" aria-expanded="false" aria-controls="flush-collapseOne">
		      	온라인 문의하기
		      </button>
		    </h2>
		    <div id="flush-collapseOne" class="accordion-collapse collapse" aria-labelledby="flush-headingOne" data-bs-parent="#accordionFlushExample">
		      	<div class="accordion-body">
		      		주문하신 상품의 취소/환불/배송/반품/교환 문의는 판매자 문의를 통해 더 정확하고 빠르게 처리할 수 있습니다.<br><br>
					판매자 문의는 상단메뉴 <span>내정보 > 주문/배송조회</span>에서 판매자 정보 하단의 [문의하기]를 클릭하시면 됩니다.<br><br>
					<c:choose>
						<c:when test="${cookMemberNo == null || cookMemberNo == 0 }">
							▶ <a href="${path }/main_servlet/findOrder.do" class="goOrderList">주문 / 배송조회</a><br><br>
						</c:when>
						<c:otherwise>
							▶ <a href="${path }/order_servlet/orderList.do" class="goOrderList">주문 / 배송조회</a><br><br>
						</c:otherwise>
					</c:choose>
				</div>
		    </div>
		  </div>
		  <div class="accordion-item">
		    <h2 class="accordion-header" id="flush-headingTwo">
		      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseTwo" aria-expanded="false" aria-controls="flush-collapseTwo">
		      	고객센터 근무시간은 어떻게 되나요?
		      </button>
		    </h2>
		    <div id="flush-collapseTwo" class="accordion-collapse collapse" aria-labelledby="flush-headingTwo" data-bs-parent="#accordionFlushExample">
		      	<div class="accordion-body">
		      		고객센터 전화 상담은 월~금요일, 오전 상담 9시~12시 / 오후 상담 13시~18시 (점심시간 12시~13시)입니다.<br><br>
		      		다소 불편한 점이 있으시더라도 따뜻한 마음으로 이해 부탁드립니다.<br><br>
				</div>
		    </div>
		  </div>
		  <div class="accordion-item">
		    <h2 class="accordion-header" id="flush-headingThree">
		      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseThree" aria-expanded="false" aria-controls="flush-collapseThree">
		      	고객센터ARS 전화상담 이용 안내
		      </button>
		    </h2>
		    <div id="flush-collapseThree" class="accordion-collapse collapse" aria-labelledby="flush-headingThree" data-bs-parent="#accordionFlushExample">
		      	<div class="accordion-body">
		      		고객상담 전화번호는 발신자가 통화료를 부담하는 유료 전화입니다.<br><br>
		      		고객센터 전화연결 시점부터 일반전화와 동일하게 별도의 통화료가 부과되오니 이용 시 참고 부탁드립니다.<br>
		      		단, 휴대폰 또는 인터넷 전화(070)을 이용하시는 경우 통화료는 통신사에 가입하신 요금제에 따라 부과됩니다.<br><br>
		      		감사합니다.<br><br>
		      		<b>[ARS 상세안내]</b><br><br>
					<h6><b>고객센터 전화번호 안내</b></h6>
					전화번호 <span style="color: #FF4646;">1234-5678</span> (유료)<br><br>
				</div>
		    </div>
		  </div>		  		  	
		</div>
	</div>
	
	<div class="helpRemoteSupport">
		<h5 class="supportTitle"><b>고객센터 원격지원</b></h5>
		<div class="accordion accordion-flush" id="accordionFlushExample_2">
		  <div class="accordion-item">
		    <h2 class="accordion-header" id="flush-headingOne_2">
		      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseOne_2" aria-expanded="false" aria-controls="flush-collapseOne_2">
		      	원격지원을 받으려 하는데 프로그램을 설치하라고 합니다. 어떻게 해야 하나요?
		      </button>
		    </h2>
		    <div id="flush-collapseOne_2" class="accordion-collapse collapse" aria-labelledby="flush-headingOne_2" data-bs-parent="accordionFlushExample_2">
		      	<div class="accordion-body">
		      		해당 프로그램은 원격지원 서비스를 받기 위해 일시적으로 실행되는 프로그램으로 서비스가 종료되면 자동 삭제됩니다.<br><br>
				</div>
		    </div>
		  </div>
		  <div class="accordion-item">
		    <h2 class="accordion-header" id="flush-headingTwo_2">
		      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseTwo_2" aria-expanded="false" aria-controls="flush-collapseTwo_2">
		      	원격지원 서비스가 무엇인가요?
		      </button>
		    </h2>
		    <div id="flush-collapseTwo_2" class="accordion-collapse collapse" aria-labelledby="flush-headingTwo_2" data-bs-parent="#accordionFlushExample">
		      	<div class="accordion-body">
		      		원격지원 서비스는 고객님이 요청하시면 브라우저를 이용하여 상담원이 고객님의 PC화면을 함께 보며 상담하는 고객지원 서비스입니다.<br><br>
				</div>
		    </div>
		  </div>
		</div>	
	</div>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.js"></script>

<script>
$('button.accordion-button').mouseover(function(){
	$(this).css('font-weight', 'bold');
});
$('button.accordion-button').mouseout(function(){	
	$(this).css('font-weight', 'normal');
});
</script>