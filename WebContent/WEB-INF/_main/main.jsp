<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<title>STORE</title>

<link rel="stylesheet" type="text/css" href="../_resources/css/main.css" >
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
</head>
<body>

<div id="page-wrapper">
	<!-- header -->
	<div id="header-wrapper">
		<jsp:include page = "../_include/inc_menu.jsp" flush="true"></jsp:include>
	</div>
	
	<!-- section -->
	<div id="section-wrapper">
		<section>			
			<jsp:include page = "${inc_page }" flush="true"></jsp:include>
		</section>
	</div>
	
	<!-- footer -->
	<div id="footer-wrapper">
		<jsp:include page = "../_include/inc_footer.jsp" flush="true"></jsp:include>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>