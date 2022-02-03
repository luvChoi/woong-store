package controller;

import java.io.IOException;
import java.net.URLEncoder;
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
import model.dao.ProductDAO;
import model.dto.CartDTO;
import model.dto.ProductDTO;

@WebServlet("/cart_servlet/*")
public class CartController extends HttpServlet {
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
			session.setMaxInactiveInterval(5 * 60);
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
		
		String page = "";
		String inc_page = "../cart/";
		
		if(url.contains("list.do") == true) { //장바구니 목록
			List<CartDTO> list = new ArrayList<>();
			
			if(cookMemberNo > 0) {
				CartDTO dto = new CartDTO();
				dto.setMember_no(cookMemberNo);
				
				CartDAO dao = new CartDAO();
				list = dao.getCartList(dto);
				
			} else { //비로그인 처리
				if(cookies != null) {
					for(Cookie c : cookies) {
						if(c.getName().contains("StoreCart_")) {
							CartDTO dto = new CartDTO();
							String cartNo_ = c.getName().substring(10);
							int cartNo = Integer.parseInt(cartNo_);
							
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
							
							list.add(dto);
						}
					}
				}
			}
			inc_page += "list.jsp";
			request.setAttribute("inc_page", inc_page);
			request.setAttribute("list", list);
						
			page = "/WEB-INF/_main/main.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("chugaProc.do") == true) { //장바구니 추가 처리
			String product_no_ = request.getParameter("product_no");
			String volume_order_ = request.getParameter("volume_order");
			String add_sale_ = request.getParameter("add_sale");
			
			CartDTO dto = new CartDTO();
			CartDAO dao = new CartDAO();
			
			String msg = "";
			String move = path + "/store_servlet/view.do?no=" + product_no_;
						
			int product_no = Integer.parseInt(product_no_);
			int volume_order = Integer.parseInt(volume_order_);
			int add_sale = Integer.parseInt(add_sale_);
			
			if(cookMemberNo > 0) { // 로그인 중일때
				dto.setMember_no(cookMemberNo);
				dto.setProduct_no(product_no);
				dto.setVolume_order(volume_order);
				dto.setAdd_sale(add_sale);				
				
				int result = dao.setInsert(dto);
								
				if(result > 0) {
					msg = "정상적으로 장바구니가 추가되었습니다.";
					int cartCnt = (Integer) session.getAttribute("cookCartCnt");
					cartCnt += 1; //장바구니 list 하나 추가
					session.setAttribute("cookCartCnt", cartCnt);
				} else {
					msg = "처리 중 오류가 발생했습니다.";
				}
				System.out.println(msg);
				
			} else { // 비로그인 장바구니 처리(쿠키)
				String cartInfo = product_no + "," + volume_order + "," + add_sale;
				cartInfo = URLEncoder.encode(cartInfo, "UTF-8");
				int cartNo = 0;
				
				if(cookies != null && cookies.length > 0) {	
					for(Cookie c : cookies) {
						if(c.getName().contains("StoreCart_")) {
							String imsi = c.getName().substring(10);
							int imsiNo = Integer.parseInt(imsi);
							if(cartNo < imsiNo) { cartNo = imsiNo; }
						}
					}
				}
				cartNo++;
				Cookie cookie = new Cookie("StoreCart_" + cartNo, cartInfo);
				cookie.setPath("/");
				response.addCookie(cookie);
			}
			response.sendRedirect(move);
			
		} else if(url.contains("updateProc.do") == true) { //수량변경
			String cart_no_ = request.getParameter("cart_no");
			String volume_order_ = request.getParameter("volume_order");
						
			int result = 0;			
			String msg = "";
			String move = path + "/cart_servlet/list.do";
			
			if(cookMemberNo > 0) { //로그인 중일때
				int cart_no = Integer.parseInt(cart_no_);
				int volume_order = Integer.parseInt(volume_order_);
				
				CartDTO dto = new CartDTO();
				dto.setCart_no(cart_no);
				dto.setVolume_order(volume_order);
				
				CartDAO dao = new CartDAO();
				result = dao.setUpdate(dto);
				
				if(result > 0) {
					msg = "정상적으로 장바구니가 수정되었습니다.";
				} else {
					msg = "처리 중 오류가 발생했습니다.";
				}
			} else { //비로그인 중일때
				for(Cookie c : cookies) {
					String name = "";
					String value = "";
					
					if(c.getName().equals("StoreCart_" + cart_no_)) {
						name = c.getName();
						value = c.getValue();
						String[] valArr = value.split("%2C");
						valArr[1] = volume_order_;
						
						value = valArr[0] + "," + valArr[1] + "," + valArr[2];
						value = URLEncoder.encode(value, "UTF-8");						
					} else {
						name = c.getName();
						value = c.getValue();
					}
					Cookie cookie = new Cookie(name, value);
					cookie.setPath("/");
					response.addCookie(cookie);
				}
			}
			System.out.println(msg);
			response.sendRedirect(move);
			
		} else if(url.contains("clearProc.do") == true) { //장바구니 삭제
			String cart_no = request.getParameter("orderCartNoArr");
			String[] cartNoStrArr = cart_no.split(",");
			
			String msg = "";		
			String move = path + "/cart_servlet/list.do";
			
			if(cookMemberNo > 0) { // 로그인 중일때
				List<Integer> cartNoList = new ArrayList<>();
				int k = 0;
				for(String s : cartNoStrArr) {
					k = Integer.parseInt(s);
					cartNoList.add(k);
				}			
				CartDTO dto = new CartDTO();
				dto.setCartNoList(cartNoList);
				
				CartDAO dao = new CartDAO();
				int result = dao.setDelete(dto);
				
				if(result > 0) {
					msg = "정상적으로 장바구니가 삭제되었습니다.";				
					int cartCnt = (Integer) session.getAttribute("cookCartCnt");
					cartCnt -= cartNoList.size(); //장바구니 list 선택한만큼 삭제
					
					session.setAttribute("cookCartCnt", cartCnt);
				} else {
					msg = "처리 중 오류가 발생했습니다.";
				}
				System.out.println(msg);
				
			} else { // 비로그인 중 삭제
				for (Cookie c : cookies) {
					for (String cartNo : cartNoStrArr) {
						if(c.getName().equals("StoreCart_" + cartNo)) {
							c.setMaxAge(0); // 장바구니 비움
							c.setPath("/");
							response.addCookie(c);
						}
					}
				}					
			}			
			response.sendRedirect(move);
		}
	}
}
