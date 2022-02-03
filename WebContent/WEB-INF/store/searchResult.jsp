<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@include file="../_include/inc_header.jsp" %>

<div class="searchGuide_wrapper">			
	<span class="catalog"> 홈 > 통합검색 > </span>
	<span class="searchContent">${searchWord }</span>
</div>
<div class="searchResult_wrapper">		
	<div class="resultGuide_wrapper">		
		<div class="resultGuide">
			<span>제품 (<fmt:formatNumber value="${totalRecord }" pattern="#,###" />)</span>
		</div>		
		<c:if test="${fn:length(prodList) != 0 }">
			<div class="sortSelect">		
				<a href="#" class="orderBySelect">
					<span class="icon">▼</span>
					<span class="orderByContent">
						<c:if test="${orderBy == 'no desc'}">최신순</c:if>
						<c:if test="${orderBy == 'last_price desc'}">가격 높은순</c:if>
						<c:if test="${orderBy == 'last_price'}">가격 낮은순</c:if>
					</span>
				</a>			
				<div id="sortDrop" class="dropdown_menu shadow" style="display: none;">
					<div class="dropdown-item">
						<a href="#" id="no desc" class="orderByChoice">최신순</a>
					</div>
					<div class="dropdown-item">
						<a href="#" id="last_price desc" class="orderByChoice">가격 높은순</a>
					</div>
					<div class="dropdown-item">
						<a href="#" id="last_price" class="orderByChoice">가격 낮은순</a>
					</div>
				</div>
			</div>
		</c:if>						
	</div>
	
	<c:choose>
		<c:when test="${fn:length(prodList) != 0 }">
		<ul class="SearchResultProd">
			<c:forEach var="dto" items="${prodList }">
			<c:set var="infoThumb" value="${fn:split(dto.info_thumbImg, '|')[0] }" />
			<c:set var="thumbImg" value="${fn:split(infoThumb, ',')[1] }" />
			<li>
				<div class="result_item">
					<div class="result_thumb">
						<a href="${path }/store_servlet/view.do?no=${dto.no }">
							<img src="${path }/attach/product_img/${thumbImg }">
						</a>
					</div>
					<div class="result_info">
						<div class="resultProd_info">
							<div class="resultProd_info_name">
								<a href="${path }/store_servlet/view.do?no=${dto.no }">
									${dto.name }
								</a>
							</div>
							<div class="resultProd_info_desc">
								${dto.description }
							</div>
						</div>
						<div class="resultPrice_info">
						<c:set var="calcPrice" value="${dto.selling_price * (100 - dto.sale_percent) / 100 }" />
							<a href="${path }/store_servlet/view.do?no=${dto.no }">
								<span class="afterPrice"><fmt:formatNumber value="${calcPrice }" pattern="#,###" />원</span>
								<span class="beforePrice"><fmt:formatNumber value="${dto.selling_price }" pattern="#,###" />원</span>
							</a>
						</div>
					</div>
				</div>
			</li>
			</c:forEach>	
		</ul>	
		
		<div class="pagination_group_wrapper" id="pageGroup">
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
		</c:when>		
		<c:otherwise>
			<div class="noResultGuide_wrapper">
				<div class="noResultGuide">“<span>${searchWord }</span>”에 대한 검색 결과가 없습니다</div>
				<div class="noResultReGuide">다시 한번 확인해주세요.</div>
			</div>
		</c:otherwise>
	</c:choose>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>
$(function() {	
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
	
	//페이지 이동 ajax
	$('.pagination_group button').on('click', function() {
		var thisId = $(this).attr('id');
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
		param = {		
			'orderBy' : '${orderBy }',
			'pageNo' : toPage
		};
		$.ajax({
			type: 'post',
			data: param,
			url: 'searchResult.do?searchWord=${searchWord }',
			success: function(data) {
				$('#page-wrapper').html(data);
			},
			fail: function() {
				let msg = '<div class="failGuide">페이지 이동을 로드하지 못했습니다.</div>';
				$('.pagination_group_wrapper').after(msg);
				$('.pagination_group_wrapper').hide();
			}
		});	
	});
	
	//정렬 DropDown
	$('.orderBySelect').on('click', function() {
		var dropDisplay = $('#sortDrop').css('display');
		var $sortDrop = $('#sortDrop');
		
		if(dropDisplay == 'none') {
			$sortDrop.show();
			$('.orderBySelect').children('.icon').text('▲');
		}
		if(dropDisplay == 'block') {
			$sortDrop.hide();
			$('.orderBySelect').children('.icon').text('▼');
		}
	});
	
	//정렬 ajax
	$('.orderByChoice').on('click', function() {
		var thisId = $(this).attr('id');
		if(thisId != '${orderBy }') {
			param = {				
				'orderBy' : thisId
			}
			$.ajax({
				type: 'post',
				data: param,
				url: 'searchResult.do?searchWord=${searchWord }',
				success: function(data) {
					$('#page-wrapper').html(data);
				},
				fail: function() {
					let msg = '<div class="failGuide">해당 정렬을 로드하지 못했습니다.</div>';
					$('.pagination_group_wrapper').after(msg);
					$('.pagination_group_wrapper').hide();
				}
			});
		}
	});
	
});
</script>
