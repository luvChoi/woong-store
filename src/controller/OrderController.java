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

import model.dao.CartDAO;
import model.dao.MemberDAO;
import model.dao.OrderDAO;
import model.dao.ProductDAO;
import model.dto.CartDTO;
import model.dto.MemberDTO;
import model.dto.OrderDTO;
import model.dto.ProductDTO;

@WebServlet("/order_servlet/*")
public class OrderController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProc(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doProc(request, response);
	}

	protected void doProc(HttpServletRequest request, HttpServletResponse response)	throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		Cookie[] cookies = request.getCookies();
		
		String path = request.getContextPath();
		String url = request.getRequestURL().toString();

		//로그인 여부 확인
		int cookMemberNo = 0;		
		HttpSession session = request.getSession();

		if (session.getAttribute("cookMemberNo") != null) {
			cookMemberNo = (Integer) session.getAttribute("cookMemberNo");
			session.setMaxInactiveInterval(5 * 60); //5분
		}

		String page = "/WEB-INF/_main/main.jsp";
		String inc_page = "../order/";

		if (url.contains("orderList.do") == true) { // 결제 내역보기
			OrderDTO dto = new OrderDTO();
			dto.setMember_no(cookMemberNo);

			LocalDate current_date = LocalDate.now();
			Date searchEnd = Date.valueOf(current_date);
						
			LocalDate twoYearsAgo = current_date.minusYears(2);
			Date searchStart = Date.valueOf(twoYearsAgo);
			
			String searchStartInput = request.getParameter("searchStart");
			String searchEndInput = request.getParameter("searchEnd");
			
			if(searchStartInput != null && searchEndInput != null) {
				searchStart = Date.valueOf(searchStartInput);
				searchEnd = Date.valueOf(searchEndInput);
			}
			
			OrderDAO dao = new OrderDAO();
			int totRowCnt = dao.getCountRow(dto, searchStart, searchEnd);
			
			int rowMultiple = 1;
			
			String rowMultiple_ = request.getParameter("rowMultiple");
			if(!(rowMultiple_ == null || rowMultiple_ == "")) {
				rowMultiple = Integer.parseInt(rowMultiple_);
			}
			
			List<OrderDTO> list = dao.getSelectAll(dto, searchStart, searchEnd, rowMultiple);			
			List<String> dateList = new ArrayList<>();

			for(OrderDTO orderDto : list) {
				Date date = orderDto.getOrder_date();
				
				String dateStr = date.toString().substring(0, 7);
				
				if(dateList.size() == 0) {
					dateList.add(dateStr);
				} else {					
					if(!dateList.get(dateList.size()-1).equals(dateStr)) { 
						dateList.add(dateStr);
					}
				}
			}
			inc_page += "orderList.jsp";
			
			request.setAttribute("list", list);
			request.setAttribute("dateList", dateList);
			request.setAttribute("searchStart", searchStart);
			request.setAttribute("searchEnd", searchEnd);
			request.setAttribute("totRowCnt", totRowCnt);
			request.setAttribute("rowMultiple", rowMultiple);			
			request.setAttribute("inc_page", inc_page);

			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);

		} else if (url.contains("orderView.do") == true) { // 주문 상세보기
			String orderNo_ = request.getParameter("orderNo");
			int orderNo = Integer.parseInt(orderNo_);

			OrderDTO dto = new OrderDTO();
			dto.setOrder_no(orderNo);

			OrderDAO dao = new OrderDAO();
			dto = dao.getSelectOne(dto);

			inc_page += "orderView.jsp";

			request.setAttribute("dto", dto);
			request.setAttribute("inc_page", inc_page);

			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);

		} else if (url.contains("orderPay.do") == true) { // 주문/결제 페이지
			String cart_no = request.getParameter("orderCartNoArr");
						
			CartDTO cartDto = new CartDTO();
			cartDto.setMember_no(cookMemberNo);
			
			List<CartDTO> orderProdList = new ArrayList<>();
			
			if(cart_no == null || cart_no == "") { //상품 상세보기에서 주문하기
				String product_no_ = request.getParameter("product_no");
				String volume_order_ = request.getParameter("volume_order");
				String add_sale_ = request.getParameter("add_sale");
				
				int product_no = Integer.parseInt(product_no_);
				int volume_order = Integer.parseInt(volume_order_);
				int add_sale = Integer.parseInt(add_sale_);
				
				ProductDTO dtoProd = new ProductDTO();
				dtoProd.setNo(product_no);
				ProductDAO daoProd = new ProductDAO();
				dtoProd = daoProd.getSelectOne(dtoProd);
				
				cartDto.setProduct_no(product_no);
				cartDto.setVolume_order(volume_order);
				cartDto.setAdd_sale(add_sale);
				
				cartDto.setProduct_name(dtoProd.getName());
				cartDto.setProduct_maker(dtoProd.getMaker());
				cartDto.setSelling_price(dtoProd.getSelling_price());
				cartDto.setSale_percent(dtoProd.getSale_percent());
				cartDto.setInfo_thumbImg(dtoProd.getInfo_thumbImg());
				
				cartDto.setCart_no(0);
				
				orderProdList.add(cartDto);
				
				request.setAttribute("product_no", product_no);
				request.setAttribute("volume_order", volume_order);
				request.setAttribute("add_sale", add_sale);
				
			} else { //장바구니에서 주문하기	
				String[] cartNoStrArr = cart_no.split(",");
				
				if (cookMemberNo > 0) { //로그인 상태	
					List<Integer> cartNoList = new ArrayList<>();

					int k = 0;
					for (String s : cartNoStrArr) {						
						k = Integer.parseInt(s);
						cartNoList.add(k);
					}
					cartDto.setCartNoList(cartNoList);
					
					CartDAO cartDao = new CartDAO();
					orderProdList = cartDao.getCartList(cartDto);
					
				} else { //비로그인 상태
					for(Cookie c : cookies) {
						String cookieName = c.getName().substring(10);
						
						for(String selectCartNo : cartNoStrArr) {
							if(cookieName.equals(selectCartNo)) {
								CartDTO dto = new CartDTO();
								int cartNo = Integer.parseInt(cookieName);
								
								String[] s = c.getValue().split("%2C");
								int productNo = Integer.parseInt(s[0]);
								int volumeOrder = Integer.parseInt(s[1]);
								int addSale = Integer.parseInt(s[2]);						
														
								ProductDTO dtoProd = new ProductDTO();
								dtoProd.setNo(productNo);
								ProductDAO daoProd = new ProductDAO();						
								dtoProd = daoProd.getSelectOne(dtoProd);
								
								dto.setCart_no(cartNo);
								dto.setMember_no(0);
								dto.setVolume_order(volumeOrder);
								dto.setProduct_no(productNo);
								dto.setAdd_sale(addSale);
								
								dto.setProduct_name(dtoProd.getName());
								dto.setProduct_maker(dtoProd.getMaker());
								dto.setSelling_price(dtoProd.getSelling_price());
								dto.setSale_percent(dtoProd.getSale_percent());
								dto.setInfo_thumbImg(dtoProd.getInfo_thumbImg());
								
								orderProdList.add(dto);
							}
						}											
					}
				}				
			}

			MemberDTO memDto = new MemberDTO();
			memDto.setNo(cookMemberNo);

			MemberDAO memDao = new MemberDAO();
			memDto = memDao.getMemberInfo(memDto);
			
			inc_page += "orderPay.jsp";

			request.setAttribute("inc_page", inc_page);
			request.setAttribute("orderProdList", orderProdList);
			request.setAttribute("memberInfo", memDto);

			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if (url.contains("orderProc.do") == true) { //주문처리
			String orderCartNo = request.getParameter("orderCartNo");
			
			String name = request.getParameter("name");
			String phone = request.getParameter("phone");
			String addr_no_ = request.getParameter("addr_no");
			String addr1 = request.getParameter("addr1");
			String addr2 = request.getParameter("addr2");
			String addr3 = request.getParameter("addr3");
			String request_term = request.getParameter("request_term");

			if (addr2.trim() == "" || addr2 == null) {
				addr2 = "-";
			}
			if (addr3.trim() == "" || addr3 == null) {
				addr3 = "-";
			}
			if (request_term.trim() == "" || request_term == null) {
				request_term = "-";
			}
						
			int addr_no = Integer.parseInt(addr_no_);

			orderCartNo = orderCartNo.substring(1);
			List<Integer> cartNoList = new ArrayList<>();			
						
			OrderDTO dto = new OrderDTO();
			dto.setName(name);
			dto.setPhone(phone);
			dto.setAddr_no(addr_no);
			dto.setAddr1(addr1);
			dto.setAddr2(addr2);
			dto.setAddr3(addr3);
			dto.setRequest_term(request_term);
			dto.setMember_no(cookMemberNo);
						
			OrderDAO dao = new OrderDAO();
			
			int product_no = 0;
			int result = 0;
			int successCtn = 0; //성공여부 숫자
			
			if(orderCartNo.equals("0")) { //상세보기 구매
				String product_no_ = request.getParameter("product_no");
				String volume_order_ = request.getParameter("volume_order");
				String add_sale_ = request.getParameter("add_sale");
				
				product_no = Integer.parseInt(product_no_);
				int volume_order = Integer.parseInt(volume_order_);
				int add_sale = Integer.parseInt(add_sale_);
				
				dto.setProduct_no(product_no);
				dto.setVolume_order(volume_order);
				dto.setAdd_sale(add_sale);				
				result = dao.setInsertInView(dto, 1);
				if(result > 0) {
					successCtn = 1;
				}
			} else { //장바구니 구매				
				String[] cartNoArr = orderCartNo.split(",");				
				for (String s : cartNoArr) {
					int i = Integer.parseInt(s);
					cartNoList.add(i);
				}
				int k = 1;
				int success = 0;
				String msg = "";
				
				if(cookMemberNo > 0) { //로그인 상태										
					for(int cartNo :cartNoList) {
						dto.setCartNo(cartNo);
						
						success = dao.setInsertInCart(dto, k);
						if(success > 0) {
							k++;
							successCtn = 1;
							CartDTO dtoCart = new CartDTO();
							dtoCart.setCart_no(cartNo);
							CartDAO daoCart = new CartDAO();
							success = daoCart.setDelete(dtoCart);						
							if(success > 0) { 
								msg = "주문등록 후 장바구니삭제 성공";
								int cartCnt = (Integer) session.getAttribute("cookCartCnt");
								cartCnt --;
								session.setAttribute("cookCartCnt", cartCnt);
							} else {
								msg = "주문등록 후 장바구니삭제 실패";
								
							}
						} else {
							msg = "주문등록 중 오류가 발생했습니다.";
							successCtn = 0;
						}
						System.out.println(msg);
					}					
				} else { //비로그인 상태
					for(Cookie c : cookies) { //쿠키정보 중 선택된 cartNo만 주문등록
						for(String selectCartNo : cartNoArr) {
							String cookieName = c.getName().substring(10);
							
							if(cookieName.equals(selectCartNo)) {								
								String[] s = c.getValue().split("%2C");
								int productNo = Integer.parseInt(s[0]);
								int volumeOrder = Integer.parseInt(s[1]);
								int addSale = Integer.parseInt(s[2]);						
																						
								dto.setVolume_order(volumeOrder);
								dto.setProduct_no(productNo);
								dto.setAdd_sale(addSale);
								
								success = dao.setInsertInView(dto, k);
								
								if(success > 0) { //주문등록 성공시
									k++;
									successCtn = 1;
									c.setMaxAge(0);
									c.setPath("/");
									response.addCookie(c);
									
									int cartCnt = (Integer) session.getAttribute("cookCartCnt");
									cartCnt --;
									session.setAttribute("cookCartCnt", cartCnt);													
								} else {
									msg = "주문등록에 실패하였습니다.";
									successCtn = 0;
								}
							}
						}											
					}	
				}	
			}
			String msg = "";
			String move = "";

			if (successCtn == 1) {
				msg = "정상적으로 주문이 등록되었습니다.";
				int orderNo = dao.getRecenctOrderNo(dto);
				move = path + "/order_servlet/orderSuccess.do?order_no=" + orderNo;								
			} else {
				msg = "처리 중 오류가 발생했습니다.";
				if(orderCartNo.equals("0")) {
					move = path + "/store_servlet/view.do?no=" + product_no;
				} else {
					move = path + "/cart_servlet/list.do";
				}
			}
			System.out.println(msg);
			response.sendRedirect(move);			

		} else if (url.contains("orderSuccess.do") == true) { //주문성공 페이지	
			String order_no_ = request.getParameter("order_no");
			int order_no = Integer.parseInt(order_no_);
			
			OrderDTO dto = new OrderDTO();
			dto.setOrder_no(order_no);
			OrderDAO dao = new OrderDAO();
			dto = dao.getSelectOne(dto);

			inc_page += "orderSuccess.jsp";

			request.setAttribute("dto", dto);
			request.setAttribute("inc_page", inc_page);

			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if (url.contains("orderSujungAddr.do") == true) { //배송지 변경
			String orderNo_ = request.getParameter("orderNo");
			int orderNo = Integer.parseInt(orderNo_);

			OrderDTO dto = new OrderDTO();
			dto.setOrder_no(orderNo);

			OrderDAO dao = new OrderDAO();
			dto = dao.getSelectOne(dto);			

			inc_page += "orderSujungAddr.jsp";

			request.setAttribute("dto", dto);
			request.setAttribute("inc_page", inc_page);

			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if (url.contains("orderSujungAddrProc.do") == true) { //배송지 변경 처리
			String ordere_no_ = request.getParameter("ordere_no");
			String name = request.getParameter("name");
			String phone = request.getParameter("phone");
			String addr_no_ = request.getParameter("addr_no");
			String addr1 = request.getParameter("addr1");
			String addr2 = request.getParameter("addr2");
			String addr3 = request.getParameter("addr3");
			String request_term = request.getParameter("request_term");

			if (addr2.trim() == "" || addr2 == null) {
				addr2 = "-";
			}
			if (addr3.trim() == "" || addr3 == null) {
				addr3 = "-";
			}
			if (request_term.trim() == "" || request_term == null) {
				request_term = "-";
			}
			
			int ordere_no = Integer.parseInt(ordere_no_);
			int addr_no = Integer.parseInt(addr_no_);
			
			OrderDTO dto = new OrderDTO();
			dto.setOrder_no(ordere_no);
			dto.setName(name);
			dto.setPhone(phone);
			dto.setAddr_no(addr_no);
			dto.setAddr1(addr1);
			dto.setAddr2(addr2);
			dto.setAddr3(addr3);
			dto.setRequest_term(request_term);
			
			OrderDAO dao = new OrderDAO();
			int result = dao.setUpdateAddr(dto);
			
			String msg = "";
			String move = path + "/order_servlet/orderList.do";
			if(result > 0) {
				msg = "정상적으로 변경되었습니다.";
			} else {
				msg = "처리 중 오류가 발생했습니다.";
			}
			System.out.println(msg);
			response.sendRedirect(move);			
		} 
	}
}
