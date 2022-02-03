package controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.dao.ProductDAO;
import model.dto.ProductDTO;

@WebServlet("/store_servlet/*")
public class StroreController extends HttpServlet {
	private static final long serialVersionUID = 1L;
           
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProc(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProc(request, response);
	}

	protected void doProc(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		Cookie[] cookies = request.getCookies();
		
		String path = request.getContextPath();
		String url = request.getRequestURL().toString();
		
		//--------------------------------------------------------------------------------------------------------
		int cookMemberNo = 0;
		int cookCartCnt = 0;
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("cookMemberNo") != null) {
			cookMemberNo = (Integer) session.getAttribute("cookMemberNo");
			session.setMaxInactiveInterval(5 * 60); //5분
		} else {
			if(cookies != null && cookies.length > 0) {				
				for(Cookie c : cookies) {
					if(c.getName().contains("StoreCart_")) {
						cookCartCnt++;
					}
				}			
				session.setAttribute("cookCartCnt", cookCartCnt);					
			}
		}
		//--------------------------------------------------------------------------------------------------------
		
		String page = "/WEB-INF/_main/main.jsp";
		String inc_page = "../store/";
		
		String servletStr = "store";
		request.setAttribute("servletStr", servletStr);
		
		if(url.contains("allProduct.do") == true) {
			String classification = request.getParameter("classification");
			String orderBy = request.getParameter("orderBy");
			
			if(classification == null || classification.trim().equals("")) {
				classification = "TV/AV"; // Default 분류
			}
			if(orderBy == null || orderBy.trim().equals("")) {
				//orderBy = "regi_date desc"; // Default 정렬
				orderBy = "no desc"; // Default 정렬(최신순)
			}
			
			//페이징 시작
			String pageNo_ = request.getParameter("pageNo");
			if(pageNo_ == null || pageNo_.trim().equals("")) {
				pageNo_ = "1";
			}
			int pageNo = Integer.parseInt(pageNo_);
			
			ProductDAO dao = new ProductDAO();
			
			int pageRecordSize = 3; // 한페이지에 보이는 "레코드 수"
			int pageLinkSize = 1;
			int totalRecord = dao.getTotalRecord(classification, "-");
			int startRecord = pageRecordSize * (pageNo - 1) + 1;
			int lastRecord = pageRecordSize * pageNo;
			if(lastRecord > totalRecord ) {
				lastRecord = totalRecord;
			}
			
			int totalPage = 0;
			int startPage = 1;
			int lastPage = 1;
			if(totalRecord > 0) {
				totalPage = totalRecord / pageRecordSize + (totalRecord % pageRecordSize == 0 ? 0 : 1);
				startPage = (pageNo / pageLinkSize - (pageNo % pageLinkSize != 0 ? 0 : 1)) * pageLinkSize + 1;
				lastPage = startPage + pageLinkSize - 1 ;
				if(lastPage > totalPage) { lastPage = totalPage; }
			}
			//페이징 끝
			
			List<ProductDTO> typeList = dao.getProductType();
			List<ProductDTO> prodList = dao.getTypeOrSearch(classification, "-", orderBy, startRecord, lastRecord);
						
			inc_page += "allProdList.jsp";
			
			request.setAttribute("inc_page", inc_page);
			request.setAttribute("classification", classification);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("typeList", typeList);
			request.setAttribute("prodList", prodList);
			request.setAttribute("totalRecord", totalRecord);
			request.setAttribute("pageNo", pageNo);
			request.setAttribute("startPage", startPage);
			request.setAttribute("lastPage", lastPage);
			request.setAttribute("totalPage", totalPage);
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("prodDisplay.do") == true) { //베스트&신상목록
			//System.out.println("prodDisplay");			
			String endRecordNum_ = request.getParameter("endRowNum");
			String sort = request.getParameter("sort");
						
			int endRecordNum = 6;		
			if(!(endRecordNum_ == null || endRecordNum_.trim().equals(""))) {
				if(endRecordNum_.equals("more")) {
					endRecordNum = 12;
				}
			}
			LocalDate current_date = LocalDate.now();						
			LocalDate searchStart_ = current_date.minusMonths(2); //최근 2개월내 신상
			Date searchStart = Date.valueOf(searchStart_);
			
			ProductDAO dao = new ProductDAO();
			List<ProductDTO> list = new ArrayList<>();
			
			if(sort.equals("best")) {
				list = dao.getBestProdList(searchStart, endRecordNum);				
			} else if(sort.equals("new")) {
				list = dao.getNewProdList(searchStart, endRecordNum);				
			}			
			inc_page += "prodList.jsp";
			
			request.setAttribute("inc_page", inc_page);
			request.setAttribute("sort", sort);
			request.setAttribute("list", list);
						
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("view.do") == true) { //상세보기
			//System.out.println("view");
			String no_ = request.getParameter("no");
			int no = Integer.parseInt(no_);
			
			ProductDTO dto = new ProductDTO();
			dto.setNo(no);
			
			ProductDAO dao = new ProductDAO();
			dto = dao.getSelectOne(dto);
			String description = dto.getDescription().replace("\r\n","<br>");
			dto.setDescription(description);
			
			inc_page += "view.jsp";
			
			request.setAttribute("dto", dto);
			request.setAttribute("inc_page", inc_page);
						
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("searchResult.do") == true) { //검색결과
			//System.out.println("searchResult");
			String searchWord = request.getParameter("searchWord");
			String orderBy = request.getParameter("orderBy");
						
			if(orderBy == null || orderBy.trim().equals("")) {
				orderBy = "no desc"; // Default 정렬
			}
			
			//페이징 시작
			String pageNo_ = request.getParameter("pageNo");
			if(pageNo_ == null || pageNo_.trim().equals("")) {
				pageNo_ = "1";
			}
			int pageNo = Integer.parseInt(pageNo_);
			
			ProductDAO dao = new ProductDAO();
			
			int pageRecordSize = 2; // 한페이지에 보이는 "레코드 수"
			int pageLinkSize = 3;
			//int pageLinkSize = 1;
			int totalRecord = dao.getTotalRecord("-", searchWord);
			int startRecord = pageRecordSize * (pageNo - 1) + 1;
			int lastRecord = pageRecordSize * pageNo;
			if(lastRecord > totalRecord ) {
				lastRecord = totalRecord;
			}
			
			int totalPage = 0;
			int startPage = 1;
			int lastPage = 1;
			if(totalRecord > 0) {
				totalPage = totalRecord / pageRecordSize + (totalRecord % pageRecordSize == 0 ? 0 : 1);
				startPage = (pageNo / pageLinkSize - (pageNo % pageLinkSize != 0 ? 0 : 1)) * pageLinkSize + 1;
				lastPage = startPage + pageLinkSize - 1 ;
				if(lastPage > totalPage) { lastPage = totalPage; }
			}
			//페이징 끝
			
			List<ProductDTO> prodList = dao.getTypeOrSearch("-", searchWord, orderBy, startRecord, lastRecord);
						
			inc_page += "searchResult.jsp";
			
			request.setAttribute("inc_page", inc_page);
			request.setAttribute("orderBy", orderBy);
			request.setAttribute("prodList", prodList);
			request.setAttribute("totalRecord", totalRecord);
			request.setAttribute("searchWord", searchWord);			
			request.setAttribute("pageNo", pageNo);
			request.setAttribute("startPage", startPage);
			request.setAttribute("lastPage", lastPage);
			request.setAttribute("totalPage", totalPage);			
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);			
		}		
	}
}
