<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@include file="../_include/inc_header.jsp" %>

<div class="storeAll_wrapper">	
	<div class="classification_wrapper">
		<ul>
			<c:forEach var="dto" items="${typeList }">
				<li class="classification_list">
					<a href="javascript:changeClassfy('${dto.classification }')" class="classify_A">${dto.classification }</a>
				</li>
			</c:forEach>
		</ul>
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
	</div>
	<form name="classfyForm">
		<input type="hidden" name="classification" value="${classification }" class="classfyInput">
	</form>
	
	<div class="ProdListAll_wrapper">		
		<div class="totalRecord">총 ${totalRecord }개</div>		
		<ul class="ProdListAll" class="my-4">
			<c:forEach var="dto" items="${prodList }">
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
			</c:forEach>
		</ul>			
	</div>
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
</div>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>

<script>

function changeClassfy(value) { //분류별 항목 페이지 이동
	if(value != '${classification }') {
		$('.classfyInput').val(value);
		classfyForm.method = "post";
		classfyForm.action = "${path }/store_servlet/allProduct.do";
		classfyForm.submit();
	}
}

$(function() {
	//현재 분류 표시
	$('.classify_A').each(function() {
		var classify = $(this).text();
		if(classify == '${classification}') {
			$(this).parent('li').css('border-bottom', '3px solid black');
			$(this).css('color', 'black');
		}
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
			'classification' : '${classification }',
			'orderBy' : '${orderBy }',
			'pageNo' : toPage
		};
		$.ajax({
			type: 'post',
			data: param,
			url: 'allProduct.do',
			success: function(data) {
				$('#page-wrapper').html(data);
			},
			fail: function() {
				let msg = '<div class="failGuide">페이지 이동을 로드하지 못했습니다.</div>';
				$('.classification_wrapper').after(msg);
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
				'classification' : '${classification }',
				'orderBy' : thisId
			}
			$.ajax({	
				type: 'post',
				data: param,
				url: 'allProduct.do',
				success: function(data) {
					$('#page-wrapper').html(data);
				},
				fail: function() {
					let msg = '<div class="failGuide">해당 정렬을 로드하지 못했습니다.</div>';
					$('.classification_wrapper').after(msg);
				}
			});
		}
	});	
});
</script>
