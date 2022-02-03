package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.dao.CartDAO;
import model.dao.MemberDAO;
import model.dao.OrderDAO;
import model.dao.ProductDAO;
import model.dto.CartDTO;
import model.dto.MemberDTO;
import model.dto.OrderDTO;
import model.dto.ProductDTO;


@WebServlet("/main_servlet/*")
public class _MainController extends HttpServlet {
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

		//로그인 여부 확인
		int cookMemberNo = 0;
		int cookUpdPeriod = 0;
		
		HttpSession session = request.getSession();	
						
		if(session.getAttribute("cookMemberNo") != null) {
			cookMemberNo = (Integer) session.getAttribute("cookMemberNo");
		}
		
		String page = "";
		if(url.contains("login.do") == true) {
			String id = request.getParameter("id");
			String go = request.getParameter("go");
			
			if(!(id == null || id.trim().equals(""))) {
				request.setAttribute("id", id);
			}
			if(!(go == null || go.trim().equals(""))) {
				if(go.trim().equals("orderList")) {
					request.setAttribute("go", go);
				}
			}			
			page = "/WEB-INF/_main/login.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		
		} else if(url.contains("loginProc.do") == true) {
			String id = request.getParameter("id");
			String passwd = request.getParameter("passwd");
			String go = request.getParameter("go");
			
			MemberDTO dto = new MemberDTO();
			dto.setId(id);
			dto.setPasswd(passwd);
			
			MemberDAO dao = new MemberDAO();
			dto = dao.getLogin(dto);
			
			String msg = "";
			String move = "";
			
			int cartAddCnt = 0;
			if(dto.getNo() > 0) {
				if(cookies != null) {
					for(Cookie c : cookies) {
						if(c.getName().contains("StoreCart_")) {
							CartDTO dtoCart = new CartDTO();					
							
							String[] s = c.getValue().split("%2C");
							int productNo = Integer.parseInt(s[0]);
							int volumeOrder = Integer.parseInt(s[1]);
							int addSale = Integer.parseInt(s[2]);
													
							dtoCart.setMember_no(dto.getNo());
							dtoCart.setProduct_no(productNo);
							dtoCart.setVolume_order(volumeOrder);
							dtoCart.setAdd_sale(addSale);

							CartDAO daoCart = new CartDAO();
							int result = daoCart.setInsert(dtoCart);
							if(result > 0) {
								c.setMaxAge(0);
								c.setPath("/");
								response.addCookie(c);
								cartAddCnt++;
							}				
						}
					}
				}
				session.setAttribute("cookMemberNo", dto.getNo());
				session.setAttribute("cookUpdPeriod", dto.getPassChg_period());
				session.setAttribute("cookCartCnt", dto.getCart_cnt() + cartAddCnt);
				session.setMaxInactiveInterval(5 * 60); //5분
				
				if(cookUpdPeriod > 180) { //비번변경 6개월 지남				
					msg = "비밀번호 변경한지 6개월이 지났습니다. \\n비밀번호를 변경해주세요.";
				} else {
					msg = dto.getName() + "님 환영합니다.";
				}
				
				if(go == null || go.trim().equals("")) {
					move = path + "/main_servlet/main.do";
				} else {
					if(go.trim().equals("orderList")) {
						move = path + "/order_servlet/orderList.do";
					} else {
						move = path + "/main_servlet/main.do";
					}
				}
			} else {
				msg = "아이디 또는 비밀번호가 잘못 입력되었습니다.";
				move = path + "/main_servlet/login.do";	
			}
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('" + msg + "')");
			out.println("window.location.href='" + move + "';");	
			out.println("</script>");
			out.flush();
			out.close();
			
		} else if(url.contains("logout.do") == true) {
			session.invalidate();			
			String move = path + "/store_servlet/prodDisplay.do?sort=best";
			response.sendRedirect(move);
					
		} else if(url.contains("main.do") == true) {
			String move = path + "/store_servlet/prodDisplay.do?sort=best";
			response.sendRedirect(move);
			
		} else if(url.contains("findId.do") == true && cookMemberNo == 0) { //아이디 찾기
			String findItem = "id";
			
			page = "/WEB-INF/_main/findId.jsp";
			request.setAttribute("findItem", findItem);
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("findIdResult.do") == true && cookMemberNo == 0)  {  //아이디 찾기결과
			String name = request.getParameter("name");
			String birth_ = request.getParameter("birth");
			String phone = request.getParameter("phone");		
			
			MemberDTO dto = new MemberDTO();
			
			if(!(birth_ == null || birth_.trim().equals(""))) {
				Date birth = Date.valueOf(birth_);
				dto.setBirth(birth);
			}
			dto.setName(name);
			dto.setPhone(phone);			
			
			MemberDAO dao = new MemberDAO();
			dto = dao.getFindId(dto);
												
			request.setAttribute("dto", dto);
			
			page = "/WEB-INF/_main/findIdResult.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("findPasswd.do") == true && cookMemberNo == 0) { //비밀번호 찾기
			String findItem = "passwd";
			
			page = "/WEB-INF/_main/findPasswd.jsp";
			request.setAttribute("findItem", findItem);
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("findPasswdResult.do") == true && cookMemberNo == 0) { //비밀번호 찾기결과
			String id = request.getParameter("id");
			String phone = request.getParameter("phone");
			
			MemberDTO dto = new MemberDTO();
			
			dto.setId(id);
			dto.setPhone(phone);
			
			MemberDAO dao = new MemberDAO();
			int result = dao.getFindPasswd(dto);
			
			request.setAttribute("result", result);
			request.setAttribute("dto", dto);
			
			page = "/WEB-INF/_main/findPasswdResult.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("updatePassProc.do") == true && cookMemberNo == 0) { //비밀번호 재설정 처리
			String id = request.getParameter("id");
			String passwd = request.getParameter("passwd");
			String passwdChk = request.getParameter("passwdChk");
			
			if(passwd.equals(passwdChk)) {
				System.out.println("새 비밀번호는 서로 일치합니다.");
				MemberDTO dto = new MemberDTO();
				dto.setId(id);
				dto.setPasswd(passwd);

				MemberDAO dao = new MemberDAO();
				int result = dao.setUpdatePasswd(dto);
				
				String move = path;
				String msg = "";
				
				if(result > 0) {
					move += "/main_servlet/login.do";		
					response.setContentType("text/html; charset=UTF-8");
					PrintWriter out = response.getWriter();
					out.println("<script>");
					out.println("alert('비밀번호가 정상적으로 재설정되었습니다.')");		
					out.println("window.location.href='" + move + "';");		
					out.println("</script>");
					out.flush();
					out.close();
					return;
				} else {
					move += "/main_servlet/findPasswd.do";
					msg = "처리 중 오류가 발생했습니다.";
				}
				System.out.println(msg);
				response.sendRedirect(move);
			}
			
		} else if(url.contains("findOrder.do") == true && cookMemberNo == 0) { //비회원 주문번호 조회			
			page = "/WEB-INF/_main/findOrder.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("findOrderResult.do") == true && cookMemberNo == 0) { //비회원 주문번호 조회
			String orderNo_ = request.getParameter("orderNo");
			String phone = request.getParameter("phone");
		
			int orderNo = 0;
			if(!(phone == null || phone.trim().equals(""))) {
				orderNo = Integer.parseInt(orderNo_);
			}
						
			OrderDTO dto =  new OrderDTO();
			dto.setOrder_no(orderNo);
			dto.setPhone(phone);
			
			OrderDAO dao = new OrderDAO();
			dto = dao.getSelectOne(dto);
						
			if(dto.getOrderProdList() == null || dto.getOrderProdList().size() == 0) {
				String move = path + "/main_servlet/findOrder.do";
				
				response.setContentType("text/html; charset=UTF-8");				
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('입력하신 정보를 확인해주세요.')");
				out.println("window.location.href='" + move + "';");
				out.println("</script>");
				out.flush();
				out.close();
				return;				
			} else {				
				page = "/WEB-INF/_main/findOrderResult.jsp";
				
				request.setAttribute("dto", dto);
				RequestDispatcher rd = request.getRequestDispatcher(page);
				rd.forward(request, response);
			}			
		}
	} 
}
