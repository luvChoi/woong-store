package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import config.DB;
import model.dto.MemberDTO;

public class MemberDAO {
	//--- 공통부분 시작 ---------------------------------------------------------------------------
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	//메서드
	public void getConn() {
		try {
			conn = DB.dbConn();
			System.out.println("-- 오라클 접속 성공 --");
		} catch(Exception e) {
			System.out.println("-- 오라클 접속 실패 --");
		}
	}
	public void getConnClose() {
		DB.dbConnClose(rs, pstmt, conn);
	}	
	//--- 공통부분 종료 ---------------------------------------------------------------------------
	
	//회원정보 호출(1명)
	public MemberDTO getMemberInfo(MemberDTO dto) {
		MemberDTO infoDto = new MemberDTO();
		infoDto.setNo(dto.getNo());
		getConn();
		try {
			String sql = "select * from member where no = ?";
			pstmt = conn.prepareStatement(sql);			
			pstmt.setInt(1, dto.getNo());			
			rs = pstmt.executeQuery();	
			if(rs.next()) {
				infoDto.setId(rs.getString("id"));
				infoDto.setName(rs.getString("name"));
				infoDto.setBirth(rs.getDate("birth"));
				infoDto.setGender(rs.getString("gender"));
				infoDto.setEmail(rs.getString("email"));
				infoDto.setPhone(rs.getString("phone"));
				infoDto.setAddr_no(rs.getInt("addr_no"));
				infoDto.setAddr1(rs.getString("addr1"));
				infoDto.setAddr2(rs.getString("addr2"));
				infoDto.setAddr3(rs.getString("addr3"));
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return infoDto;
	}
	
	//로그인
	public MemberDTO getLogin(MemberDTO dto) {
		MemberDTO dtoLogin = new MemberDTO();
		getConn();
		try {
			String sql = "";
			sql += "select no, name, trunc(sysdate - pwdUpd_date) passChg_period,";
			//sql += "select no, name, (curdate() - pwdUpd_date) passChg_period,";
			sql += " (select count(member_no) from cart where member_no =";			
			sql += " (select no from member where id=? and passwd = ?)) cart_cnt";			
			sql += " from member where id=? and passwd=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPasswd());
			pstmt.setString(3, dto.getId());
			pstmt.setString(4, dto.getPasswd());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dtoLogin.setNo(rs.getInt("no"));
				dtoLogin.setName(rs.getString("name"));
				dtoLogin.setPassChg_period(rs.getInt("passChg_period"));
				dtoLogin.setCart_cnt(rs.getInt("cart_cnt"));
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return dtoLogin;
	}
	
	//아이디 찾기
	public MemberDTO getFindId(MemberDTO dto) {
		MemberDTO dtoFind = new MemberDTO();
		getConn();
		try {
			String sql = "";
			sql += "select * from member";
			sql += " where name=? and birth=? and phone=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setDate(2, dto.getBirth());
			pstmt.setString(3, dto.getPhone());			
			rs = pstmt.executeQuery();		
			
			if(rs.next()) {
				dtoFind.setNo(rs.getInt("no"));
				dtoFind.setId(rs.getString("id"));
				dtoFind.setName(rs.getString("name"));
				dtoFind.setBirth(rs.getDate("birth"));
				dtoFind.setPhone(rs.getString("phone"));
				dtoFind.setRegi_date(rs.getDate("regi_date"));
			}		
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return dtoFind;
	}
	
	//비밀번호 찾기
	public int getFindPasswd(MemberDTO dto) {
		int result = 0;	
		getConn();
		try {
			String sql = "";
			sql += "select count(*) checkNo from member";
			if(!(dto.getPhone() == null || dto.getPhone().trim().equals(""))) {
				sql += " where id=? and phone=?";
			} else if (!(dto.getPasswd() == null || dto.getPasswd().trim().equals(""))) {
				sql += " where no=? and passwd=?";
			}			
			pstmt = conn.prepareStatement(sql);
			
			if(!(dto.getPhone() == null || dto.getPhone().trim().equals(""))) {
				pstmt.setString(1, dto.getId());
				pstmt.setString(2, dto.getPhone());
			} else if (!(dto.getPasswd() == null || dto.getPasswd().trim().equals(""))) {
				pstmt.setInt(1, dto.getNo());
				pstmt.setString(2, dto.getPasswd());
			}
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt("checkNo");
			}			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	//내정보 수정
	public int setUpdateMyInfo(MemberDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "";
			sql += "update member set ";
			sql += " name=?, birth=?, gender=?, email=?, phone=?,";
			sql += " addr_no=?, addr1=?, addr2=?, addr3=?";
			sql += " where no=?";			
			pstmt = conn.prepareStatement(sql);			
			pstmt.setString(1, dto.getName());
			pstmt.setDate(2, dto.getBirth());
			pstmt.setString(3, dto.getGender());
			pstmt.setString(4, dto.getEmail());
			pstmt.setString(5, dto.getPhone());
			pstmt.setInt(6, dto.getAddr_no());
			pstmt.setString(7, dto.getAddr1());
			pstmt.setString(8, dto.getAddr2());
			pstmt.setString(9, dto.getAddr3());		
			pstmt.setInt(10, dto.getNo());
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}	
	
	//회원가입
	public int setInsert(MemberDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "";
			sql += "insert into member";
			sql += " (no, id, passwd, name, birth, gender, email, phone, addr_no, addr1, addr2, addr3, regi_date, pwdUpd_date)";
						
//			sql += " select ifnull(max(no),0)+1,";
//			sql += " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, curdate(), curdate() from member";
			sql += " values(seq_member.nextval,";
			sql += " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, sysdate, sysdate)";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPasswd());
			pstmt.setString(3, dto.getName());
			pstmt.setDate(4, dto.getBirth());
			pstmt.setString(5, dto.getGender());
			pstmt.setString(6, dto.getEmail());
			pstmt.setString(7, dto.getPhone());
			pstmt.setInt(8, dto.getAddr_no());
			pstmt.setString(9, dto.getAddr1());
			pstmt.setString(10, dto.getAddr2());
			pstmt.setString(11, dto.getAddr3());		
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	//비밀번호 재설정
	public int setUpdatePasswd(MemberDTO dto) {
		int result = 0;	
		getConn();
		try {
			String sql = "";
			sql += "update member set passwd = ? ";			
			if(dto.getBeforePasswd() == null || dto.getBeforePasswd().equals("")) {
				sql += " where id = ?";
			} else {
				sql += "where no = ? and passwd = ?";				
			}			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getPasswd());
			if(dto.getBeforePasswd() == null || dto.getBeforePasswd().equals("")) {
				pstmt.setString(2, dto.getId());
			} else {
				sql += "where no = ? and passwd = ?";				
				pstmt.setInt(2, dto.getNo());
				pstmt.setString(3, dto.getBeforePasswd());
			}			
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	//회원별 장바구니 삭제 (회원탈퇴용)
	public int setDeleteMember(MemberDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "delete from member where no = ?";			
			pstmt = conn.prepareStatement(sql);			
			pstmt.setInt(1, dto.getNo());			
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	//회원별 장바구니 삭제 (회원탈퇴용)
	public int setDeleteCart(MemberDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "delete from cart where member_no=?";			
			pstmt = conn.prepareStatement(sql);			
			pstmt.setInt(1, dto.getNo());
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	//회원별 주문정보 비회원 전환(회원탈퇴용)
	public int setUpdateOrder(MemberDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "";
			sql += "update orderTB set member_no = '0'";
			sql += " where member_no = ?";
			pstmt = conn.prepareStatement(sql);			
			pstmt.setInt(1, dto.getNo());		
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	//회원별 문의정보 삭제 (회원탈퇴용)
	public int setDeleteInquiry(MemberDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "delete from inquiry where member_no = ?";			
			pstmt = conn.prepareStatement(sql);			
			pstmt.setInt(1, dto.getNo());
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
}
