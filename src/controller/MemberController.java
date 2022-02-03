package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.dao.MemberDAO;
import model.dto.MemberDTO;

@WebServlet("/member_servlet/*")
public class MemberController extends HttpServlet {
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
		
		//--------------------------------------------------------------------------------------------------------
		int cookMemberNo = 0;
		
		HttpSession session = request.getSession();	
						
		if(session.getAttribute("cookMemberNo") != null) {
			cookMemberNo = (Integer) session.getAttribute("cookMemberNo");
		}		
		//--------------------------------------------------------------------------------------------------------
		
		String page = "";
		
		if(url.contains("join.do") == true) {
			//System.out.println("join");
			page = "/WEB-INF/member/join.jsp";
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("joinProc.do") == true) {
			String id = request.getParameter("id");
			String passwd =  request.getParameter("passwd");
			String passwdChk =  request.getParameter("passwdChk");
			String name =  request.getParameter("name");
			String birth_ =  request.getParameter("birth");
			String gender =  request.getParameter("gender");
			String email =  request.getParameter("email");
			String phone =  request.getParameter("phone");			
			String addr_no_ =  request.getParameter("addr_no");
			String addr1 =  request.getParameter("addr1");
			String addr2 =  request.getParameter("addr2");
			String addr3 =  request.getParameter("addr3");
						
			if(addr3.trim() == "" || addr3 == null) {
				addr3 = "-";
			}			
			
			int addr_no = Integer.parseInt(addr_no_);
			Date birth = Date.valueOf(birth_);
			
			MemberDTO dto = new MemberDTO();
			dto.setId(id);
			dto.setPasswd(passwd);
			dto.setName(name);
			dto.setBirth(birth);
			dto.setGender(gender);
			dto.setEmail(email);
			dto.setPhone(phone);
			dto.setAddr_no(addr_no);
			dto.setAddr1(addr1);
			dto.setAddr2(addr2);
			dto.setAddr3(addr3);
			
			MemberDAO dao = new MemberDAO();
			int result = dao.setInsert(dto);
			
			String move = "";
			String msg = "";
			if(result > 0) { //정상가입
				move = path + "/main_servlet/login.do";
				msg = "정상적으로 회원가입되었습니다.";
			} else { //처리 중 오류
				move = path + "/member_servlet/join.do";
				msg = "처리 중 오류가 발생했습니다.";							
			}
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('" + msg + "')");
			out.println("window.location.href = '" + move + "';");
			out.println("</script>");
			out.flush();
			out.close();			
			
		} else if(url.contains("myPage.do") == true && cookMemberNo > 0) { // 마이페이지
			MemberDTO dto = new MemberDTO();
			dto.setNo(cookMemberNo);
			
			MemberDAO dao = new MemberDAO();
			dto = dao.getMemberInfo(dto);
			
			String imsi = "";
			String email = "";
			String phone = "010";
			
			//회원email 정보
			imsi = dto.getEmail();
			String[] emailArr1 = imsi.split("@");			
			email += emailArr1[0].substring(0, 2) + "******@";
			
			String[] emailArr2 = emailArr1[1].split("[.]");
			email += emailArr2[0].substring(0, 1) + "*******." + emailArr2[1];
			
			//회원Phone 정보
			imsi = dto.getPhone();
			String[] imsiPhoneArr = imsi.split("-");
			
			for(int i = 1; i < imsiPhoneArr.length; i++) {
				imsi = "-" + imsiPhoneArr[i].substring(0, 1) + "***";				
				phone += imsi;
			}			
			dto.setEmail(email);
			dto.setPhone(phone);
			
			request.setAttribute("dto", dto);
			
			page = "/WEB-INF/member/myPage.jsp";
						
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("checkPasswd.do") == true && cookMemberNo > 0) {	// 비밀번호 확인(내정보 수정)
			MemberDTO dto = new MemberDTO();
			dto.setNo(cookMemberNo);
			
			MemberDAO dao = new MemberDAO();
			dto = dao.getMemberInfo(dto);
			
			request.setAttribute("dto", dto);
			page = "/WEB-INF/member/checkPasswd.jsp";
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("checkPasswdProc.do") == true && cookMemberNo > 0) {	// 비밀번호 처리
			String password = request.getParameter("password");
			
			MemberDTO dto = new MemberDTO();
			dto.setNo(cookMemberNo);
			dto.setPasswd(password);
			
			MemberDAO dao = new MemberDAO();
			int result = dao.getFindPasswd(dto);			
			
			String move = "";
			String msg = "";
			if(result > 0) {
				move = path + "/member_servlet/updateMyInfo.do";
				response.sendRedirect(move);				
			} else {
				msg = "비밀번호가 일치하지 않습니다.";
				move = path + "/member_servlet/myPage.do";
				
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('" + msg + "')");
				out.println("window.location.href = '" + move + "';");
				out.println("</script>");
				out.flush();
				out.close();
				return;
			}
			
		} else if(url.contains("updateMyInfo.do") == true && cookMemberNo > 0) { //내정보 수정
			MemberDTO dto = new MemberDTO();
			dto.setNo(cookMemberNo);
			
			MemberDAO dao = new MemberDAO();
			dto = dao.getMemberInfo(dto);
			
			request.setAttribute("dto", dto);
			page = "/WEB-INF/member/updateMyInfo.jsp";
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("updateMyInfoProc.do") == true && cookMemberNo > 0) { //내정보 수정 처리
			String name =  request.getParameter("name");
			String birth_ =  request.getParameter("birth");
			String gender =  request.getParameter("gender");
			String email =  request.getParameter("email");
			String phone =  request.getParameter("phone");
			String addr_no_ =  request.getParameter("addr_no");
			String addr1 =  request.getParameter("addr1");
			String addr2 =  request.getParameter("addr2");
			String addr3 =  request.getParameter("addr3");
			
			if(addr3 == null || addr3.trim().equals("")) {
				addr3 = "-";
			}			
			int addr_no = Integer.parseInt(addr_no_);
			Date birth = Date.valueOf(birth_);
			
			MemberDTO dto = new MemberDTO();
			dto.setNo(cookMemberNo);
			dto.setName(name);
			dto.setBirth(birth);
			dto.setGender(gender);
			dto.setEmail(email);
			dto.setPhone(phone);
			dto.setAddr_no(addr_no);
			dto.setAddr1(addr1);
			dto.setAddr2(addr2);
			dto.setAddr3(addr3);
			
			MemberDAO dao = new MemberDAO();
			int result = dao.setUpdateMyInfo(dto);
			
			String msg = "";
			String move = path + "/member_servlet/myPage.do";
			if(result > 0) {
				msg = "정상적으로 정보 수정을 완료했습니다.";
			} else {
				msg = "정보 수정 중 오류가 발생했습니다.";
			}			
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('" + msg + "')");
			out.println("window.location.href = '" + move + "';");				
			out.println("</script>");
			out.flush();
			out.close();
			
		} else if(url.contains("updatePasswd.do") == true && cookMemberNo > 0) { //비밀번호 변경
			MemberDTO dto = new MemberDTO();
			dto.setNo(cookMemberNo);
			
			request.setAttribute("dto", dto);
			page = "/WEB-INF/member/updatePasswd.jsp";
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("updatePasswdProc.do") == true && cookMemberNo > 0) { //비밀번호 변경 처리			
			String beforePasswd = request.getParameter("beforePasswd");
			String passwd = request.getParameter("afterPasswd");
			String passwdChk = request.getParameter("afterPasswdChk");
			
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			
			String msg = "";
			String move = "";
					
			if(!passwd.equals(passwdChk)) { //일치하지 않을 경우
				msg = "새 비밀번호가 일치하지 않습니다.";
				move = path + "/member_servlet/myPage.do";
						
				out.println("<script>");
				out.println("alert('" + msg + "')");
				out.println("window.location.href = '" + move + "';");				
				out.println("</script>");
				out.flush();
				out.close();
			}
			
			String no_ = request.getParameter("no");
			int no = Integer.parseInt(no_);
			
			MemberDTO dto = new MemberDTO();
			dto.setNo(no);
			dto.setBeforePasswd(beforePasswd);
			dto.setPasswd(passwd);
			
			MemberDAO dao = new MemberDAO();
			int result = dao.setUpdatePasswd(dto);
			
			move = path + "/member_servlet/myPage.do";
			if(result > 0) {
				msg = "정상적으로 비밀번호가 변경되었습니다.";
			} else {
				msg = "입력정보를 확인해주세요.";
			}
			out.println("<script>");
			out.println("alert('" + msg + "')");
			out.println("window.location.href = '" + move + "';");
			out.println("</script>");
			out.flush();
			out.close();
			
		} else if(url.contains("deleteUser.do") == true && cookMemberNo > 0) { //회원탈퇴
			MemberDTO dto = new MemberDTO();
			dto.setNo(cookMemberNo);
			
			MemberDAO dao = new MemberDAO();
			dto = dao.getMemberInfo(dto);
			
			request.setAttribute("dto", dto);
			page = "/WEB-INF/member/deleteUser.jsp";
			
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
			
		} else if(url.contains("deleteUserProc.do") == true) { //회원탈퇴 처리
			String no_ = request.getParameter("no");
			String password = request.getParameter("password");
			
			int no = Integer.parseInt(no_);
			
			MemberDTO dto = new MemberDTO();
			dto.setNo(no);
			dto.setPasswd(password);
			
			MemberDAO dao = new MemberDAO();
			int result = dao.getFindPasswd(dto);
			System.out.println(result);
			
			String move = "";
			String msg = "";
			if(result == 1) {				
				int deleteChk = 0;
				deleteChk = dao.setDeleteCart(dto); // 회원 장바구니 삭제
				if(deleteChk > 0) {
					System.out.println("장바구니 삭제 확인");
				} else {
					System.out.println("장바구니 삭제 실패");
				}
				
				deleteChk = dao.setUpdateOrder(dto); // 회원 주문정보 변경
				if(deleteChk > 0) {
					System.out.println("주문정보 변경 확인");
				} else {
					System.out.println("주문정보 변경 실패");
				}
				
				deleteChk = dao.setDeleteInquiry(dto); // 회원 문의정보 삭제
				if(deleteChk > 0) {
					System.out.println("문의정보 삭제 확인");
				} else {
					System.out.println("문의정보 삭제 실패");
				}

				deleteChk = dao.setDeleteMember(dto); // 회원정보 삭제
				if(deleteChk > 0) {
					session.invalidate();
					System.out.println("회원정보 삭제 확인");
					msg = "정상적으로 회원 탈퇴되었습니다.\\n지금까지 이용해주셔서 감사합니다^^"; //escape문자 누락하지말 것
					move = path + "/main_servlet/main.do";
				} else {
					System.out.println("회원정보 삭제 실패");
					msg = "입력정보를 확인해주세요.";
					move = path + "/member_servlet/myPage.do";
				}				
			} else {
				msg = "비밀번호가 일치하지 않습니다.";
				move = path + "/member_servlet/myPage.do";				
			}			
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('" + msg + "');");
			out.println("window.location.href='" + move + "';");
			out.println("</script>");
			out.flush();
			out.close();
		}		
	}
}
