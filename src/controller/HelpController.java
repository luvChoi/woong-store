package controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.dao.InquiryDAO;
import model.dto.InquiryDTO;

@WebServlet("/help_servlet/*")
public class HelpController extends HttpServlet {
	private static final long serialVersionUID = 1L;
  
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProc(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProc(request, response);
	}

	protected void doProc(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		String path = request.getContextPath();
		String url = request.getRequestURL().toString();
		
		String page = "/WEB-INF/_main/main.jsp";
		String inc_page = "../help/";
		
		//로그인 여부 확인
		int cookMemberNo = 0;
		
		HttpSession session = request.getSession();
		
		if(session.getAttribute("cookMemberNo") != null) {
			cookMemberNo = (Integer) session.getAttribute("cookMemberNo");
			session.setMaxInactiveInterval(5 * 60); //5분
		}
		
		if(url.contains("helpGuide.do") == true) { //고객센터 안내 페이지
			
			inc_page += "helpGuide.jsp";
			
			request.setAttribute("inc_page", inc_page);
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("inquiryAnswer.do") == true) { // 문의/답변 페이지			
			String periodAgo = request.getParameter("periodAgo");
			String answerExist_ = request.getParameter("answerExist");
			
			LocalDate current_date = LocalDate.now();			
			LocalDate searchStart = current_date.minusMonths(1);  // 기본 1개월 검색
			int cntRef = 3; // 답변, 미답변 모두 검색
			
			if(periodAgo == null || periodAgo.trim().equals("")) {
				periodAgo = "oneMonth";
			} else {
				if(periodAgo.equals("today")) {
					searchStart = current_date;
				} else if(periodAgo.equals("oneWeek")) {
					searchStart = current_date.minusWeeks(1);
				} else if(periodAgo.equals("threeMonth")) {
					searchStart = current_date.minusMonths(3);
				} else if(periodAgo.equals("sixMonth")) {
					searchStart = current_date.minusMonths(6);
				} else if(periodAgo.equals("oneYear")) {
					searchStart = current_date.minusYears(1);
				}
			}			
			if(!(answerExist_ == null || answerExist_.trim().equals(""))) {
				cntRef = Integer.parseInt(answerExist_);
			}
			Date searchDate = Date.valueOf(searchStart);
			
			//페이징
			String pageNo_ = request.getParameter("pageNo");
			if(pageNo_ == null || pageNo_.trim().equals("")) {
				pageNo_ = "1";				
			}
			int pageNo = Integer.parseInt(pageNo_);
			
			InquiryDAO dao = new InquiryDAO();
			int pageRecordSize = 1;
			int pageLinkSize = 3;
			int totalRecord = dao.getTotalRecord(cookMemberNo, searchDate, cntRef);
			int startRecord = pageRecordSize * (pageNo - 1) + 1;
			int lastRecord = pageRecordSize * pageNo;
			if (lastRecord > totalRecord) {
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
			
			//DB 검색조건						
			List<InquiryDTO> list = dao.getInquiryList(cookMemberNo, searchDate, cntRef, startRecord, lastRecord);
			
			inc_page += "inquiryAnswer.jsp";
			
			request.setAttribute("list", list);
			request.setAttribute("inc_page", inc_page);
			request.setAttribute("periodAgo", periodAgo);
			request.setAttribute("cntRef", cntRef);
			request.setAttribute("pageNo", pageNo); //현재 페이지
			request.setAttribute("startPage", startPage);
			request.setAttribute("lastPage", lastPage);
			request.setAttribute("totalPage", totalPage); //total 페이지
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);			
		
		} else if(url.contains("deleteInquiry.do") == true) {
			String ref_ = request.getParameter("ref");
			int ref = Integer.parseInt(ref_);
			
			InquiryDTO dto = new InquiryDTO();
			dto.setRef(ref);
			
			InquiryDAO dao = new InquiryDAO();
			int result = dao.setDelete(dto);
			
			String msg = "";
			String move = path + "/help_servlet/inquiryAnswer.do";
			
			if(result > 0) {
				msg = "주문/배송문의가 정상적으로 삭제되었습니다.";
			} else {
				msg = "처리 중 오류가 발생했습니다.";
			}
			System.out.println(msg);
			response.sendRedirect(move);		
		}		
	}
}
