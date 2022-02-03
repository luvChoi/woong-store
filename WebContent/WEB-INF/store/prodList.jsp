<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@include file="../_include/inc_header.jsp" %>

<div class="store_wrapper">	
	<div class="list_title">
		<c:if test="${sort == 'best' }">이 달의 추천제품</c:if>
		<c:if test="${sort == 'new' }">새로운 제품, 놓치지 마세요</c:if>
	</div>
	
	<div id="prod_wrapper">
		<div id="prodList_wrapper">	
		<c:set var="k" value="${k = 0 }" />
		<c:forEach var="dto" items="${list }">
		<c:if test="${k % 3 == 0 }">
			<ul id="prod_list" class="my-4">
		</c:if>		
				<li>
					<a href="${path }/store_servlet/view.do?no=${dto.no }" class="prodDisplay">
						<div class="imageArea">		
						<c:set var="infoThumImg" value="${fn:split(dto.info_thumbImg, '|')[0] } " />
						<c:set var="prodImg" value="${fn:split(infoThumImg, ',')[1] } " />
							<c:if test="${sort == 'best' }">
							<div>
								<span class="numbering">${k + 1 }</span>
							</div>
							</c:if>					
							<img src="${path }/attach/product_img/${prodImg }">					
							${prodImgArr[1] }
						</div>
						<div class="info_product">
							<c:if test="${sort == 'new' }">
								<div class="newGuide">신제품</div>
							</c:if>
							<div class="prodName">${dto.name }</div>
							<div class="selling_price">
								<fmt:formatNumber value="${dto.selling_price * (100 - dto.sale_percent) / 100}" pattern="#,###" /> 원
								<span class="beforeSale">
									<fmt:formatNumber value="${dto.selling_price }" pattern="#,###" /> 원
								</span>
							</div>
						</div>
					</a>
				</li>
			<c:set var="k" value="${k = k + 1 }" />
			<c:if test="${k % 3 == 0 }">
			</ul>
			</c:if>
			</c:forEach>
		</div>
	</div>
	
	<div class="moreList">
		<button class="moreListBtn">+ 제품 더보기</button>
	</div>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
$(function() {
	$('.moreListBtn').on('click', function() {
		param = {
					'endRowNum': 'more',
					'sort': '${sort }'
				};
		$.ajax({ //비동기식
			type: "post",
			data: param,
			url: "prodDisplay.do",
			success: function(data) {
				$("#page-wrapper").html(data);
				$(".moreList").css('display', 'none');
			},
			fail: function() {
				let msg = "<div class='failGuide'>주문내역을 추가 로드하지 못했습니다.</div>";
				$(".moreList").after(msg);
				$(".moreList").css('display', 'none');
			}
		});
	});
});
</script>