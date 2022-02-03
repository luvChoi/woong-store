package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.dao.InquiryDAO;
import model.dao.OrderDAO;
import model.dao.RequestCancelDAO;
import model.dto.InquiryDTO;
import model.dto.OrderDTO;
import model.dto.RequestCancelDTO;

@WebServlet("/popup_servlet/*")
public class PopupController extends HttpServlet {
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
		
		// --------------------------------------------------------------------------------------------------------
		int cookMemberNo = 0;

		HttpSession session = request.getSession();

		if (session.getAttribute("cookMemberNo") != null) {
			cookMemberNo = (Integer) session.getAttribute("cookMemberNo");
			session.setMaxInactiveInterval(5 * 60);
		}
		// --------------------------------------------------------------------------------------------------------
				
		String page = "";
		
		if(url.contains("inquiry.do") == true) { //문의하기
			String orderNo_ = request.getParameter("orderNo");
			int orderNo = Integer.parseInt(orderNo_);
			
			InquiryDAO dao = new InquiryDAO();
			List<InquiryDTO> typeList = dao.getInquiryType();
			List<OrderDTO> prodList = dao.getProdList(orderNo);
			
			request.setAttribute("orderNo", orderNo);
			request.setAttribute("typeList", typeList);
			request.setAttribute("prodList", prodList);
			
			page = "/WEB-INF/popup/shoppingInquiry.jsp";
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("inquiryRegistProc.do") == true) { //문의하기 처리			
			String orderNo_ = request.getParameter("orderNo");
			String inq_prodList = request.getParameter("inq_prodList");
			String type_no_ = request.getParameter("type_no");
			String subject = request.getParameter("subject");
			String content = request.getParameter("content");
			
			content = content.replace("\r\n","<br>");
			
			int order_no = Integer.parseInt(orderNo_);
			int type_no = Integer.parseInt(type_no_);
			
			InquiryDAO dao = new InquiryDAO();
			int ref = dao.getMaxRef() + 1;
						
			InquiryDTO dto = new InquiryDTO();
			dto.setOrder_no(order_no);
			dto.setMember_no(cookMemberNo);
			dto.setTypeNo(type_no);
			dto.setSubject(subject);
			dto.setContent(content);
			dto.setRef_step(1);
		
			String[] inqListStrArr = inq_prodList.split(",");			
			int result = 0;
			String msg = "";
			
			for(String s : inqListStrArr) {
				int k = Integer.parseInt(s);
				dto.setInq_prodNo(k);
				
				dto.setRef(ref); //문의번호 증가
				result = dao.setRegist(dto);				
				
				if(result > 0) {
					msg = "주문번호(" + order_no + ") / 상품주문번호(" + dto.getInq_prodNo() + ") 등록에 성공하였습니다.";
				} else {
					msg = "주문번호(" + order_no + ") / 상품주문번호(" + dto.getInq_prodNo() + ") 등록에 실패하였습니다.";
				}
				System.out.println(msg);
				
				ref++;
			}
			response.setContentType("text/html; charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("window.close();");			
			out.println("</script>");
			out.flush();
			out.close();
			
		} else if(url.contains("requestCancel.do") == true) { //취소요청 (사유저장)
			String orderProductNo_ = request.getParameter("orderProductNo");
			int orderProductNo = Integer.parseInt(orderProductNo_);
			
			OrderDTO dtoOrder = new OrderDTO();
			dtoOrder.setOrder_product_no(orderProductNo);
			
			OrderDAO daoOrder = new OrderDAO();
			dtoOrder = daoOrder.getInfoOrderOne(dtoOrder);
			
			RequestCancelDAO dao = new RequestCancelDAO();
			List<RequestCancelDTO> cancelTypeList = dao.getCancelType();			
			
			request.setAttribute("dtoOrder", dtoOrder);
			request.setAttribute("cancelTypeList", cancelTypeList);			
			
			page = "/WEB-INF/popup/requestOrderCancel.jsp";
					
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("requestCancelProc.do") == true) { //취소요청 처리
			String orderProductNo_ = request.getParameter("orderProductNo");
			String cancel_type_ = request.getParameter("cancel_type");
			String cancel_reason = request.getParameter("cancel_reason");
			
			int orderProductNo = Integer.parseInt(orderProductNo_);
			int cancel_type = Integer.parseInt(cancel_type_);
			
			RequestCancelDTO dto = new RequestCancelDTO();
			dto.setOrder_product_no(orderProductNo);
			dto.setCancel_type(cancel_type);
			dto.setCancel_reason(cancel_reason);
			
			RequestCancelDAO dao = new RequestCancelDAO();
			int result = dao.setInsert(dto);
			
			String msg = "";
			if(result > 0) {
				msg = "정상적으로 취소요청되었습니다.";
				
				OrderDTO dtoOrder = new OrderDTO();
				dtoOrder.setOrder_product_no(orderProductNo);
				
				OrderDAO daoOrder = new OrderDAO();
				daoOrder.setCancel(dtoOrder);
				
				response.setContentType("text/html; charset=utf-8");
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("window.close();");
				out.println("</script>");
				out.flush();
				out.close();
				return;				
			} else {
				msg = "처리 중 오류가 발생했습니다.";
			}
			System.out.println(msg);
						
		} else if(url.contains("infoCancel.do") == true) { //취소정보
			String orderProductNo_ = request.getParameter("orderProductNo");
			int orderProductNo = Integer.parseInt(orderProductNo_);			
			
			RequestCancelDTO dto =  new RequestCancelDTO();
			dto.setOrder_product_no(orderProductNo);			
			
			RequestCancelDAO dao = new RequestCancelDAO();
			dto = dao.getSelectInfo(dto);			
			
			request.setAttribute("dto", dto);
			
			page = "/WEB-INF/popup/infoOrderCancel.jsp";
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		}
	}

}
