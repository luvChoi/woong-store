package model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import config.DB;
import model.dto.InquiryDTO;
import model.dto.OrderDTO;

public class InquiryDAO {
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

	//문의유형 호출
	public List<InquiryDTO> getInquiryType() {
		List<InquiryDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "select * from inquiryType order by no";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				InquiryDTO dto = new InquiryDTO();
				dto.setTypeNo(rs.getInt("no"));
				dto.setTypeStr(rs.getString("inquiry_type"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return list;
	}
	
	//주문번호별 상품리스트 호출
	public List<OrderDTO> getProdList(int ordertNo) {
		List<OrderDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "";
			sql += "select o.order_product_no, p.name from orderTB o, product p";
			sql += " where (o.product_no = p.no)";
			sql += " and order_no = ?";
			sql += " order by o.order_product_no";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ordertNo);
			rs = pstmt.executeQuery();			
			while(rs.next()) {
				OrderDTO dto = new OrderDTO();
				dto.setOrder_product_no(rs.getInt("order_product_no"));
				dto.setProduct_name(rs.getString("name"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return list;
	}
	
	//max(ref) 호출
	public int getMaxRef() {
		int maxRef = 0;
		getConn();
		try {
			String sql = "select nvl(max(ref), 0) max_ref from inquiry";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				maxRef = rs.getInt("max_ref");
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return maxRef;
	}
	
	//회원별 문의목록 총 record 수
	public int getTotalRecord(int memberNo, Date searchDate, int cntRef) {
		int result = 0;
		getConn();
		try {
			String sql = "select count(*) totRecord from";
			sql += " (select ref from inquiry where (member_no = ? and regi_date >= ?)";
			sql += " group by ref";
			if(cntRef == 1 || cntRef == 2) {
				sql += " having count(ref) = ?";
			}
			sql += " order by ref desc) a";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, memberNo);
			pstmt.setDate(2, searchDate);
			if(cntRef == 1 || cntRef == 2) {
				pstmt.setInt(3, cntRef);			
			}
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt("totRecord");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}	
	
	//회원별 문의목록
	public List<InquiryDTO> getInquiryList(int memberNo, Date searchDate, int cntRef, int startRecord, int lastRecord) { //cntRef는 답변여부 확인 변수
		List<InquiryDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "";
			sql += "select i.order_no, i.ref, i.ref_step, i_type.inquiry_type, i.subject, i.content, i.regi_date,";
			sql += " p.no, p.name, p.maker, p.info_thumbimg";
			sql += " from inquiry i, orderTB o, inquiryType i_type, product p";
			sql += " where (i.type_no = i_type.no and i.inq_prodNo = o.order_product_no";
			sql += " and o.product_no = p.no)";						
			sql += " and ref in (select ref from (select rownum rnum, a.* from (select ref from inquiry";
			sql += " where member_no = ? and regi_date >= ? group by ref";
			if(cntRef == 1 || cntRef == 2) {
				sql += " having count(ref) = ?";
			}
			sql += " order by ref desc) a) b";			
			sql += " where rnum between ? and ?)";			
			sql += " order by ref_step";		
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, memberNo);
			pstmt.setDate(2, searchDate);
			int k = 0;
			if(cntRef == 1 || cntRef == 2) {
				pstmt.setInt(3, cntRef);
				k ++;
			}
			pstmt.setInt(k + 3, startRecord);
			pstmt.setInt(k + 4, lastRecord);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				InquiryDTO dto = new InquiryDTO();
				dto.setOrder_no(rs.getInt("order_no"));
				dto.setRef(rs.getInt("ref"));
				dto.setRef_step(rs.getInt("ref_step"));
				dto.setTypeStr(rs.getString("inquiry_type"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setRegi_date(rs.getDate("regi_date"));
				//상품정보
				OrderDTO orderDto = new OrderDTO();
				orderDto.setProduct_no(rs.getInt("no"));
				orderDto.setProduct_name(rs.getString("name"));
				orderDto.setProduct_maker(rs.getString("maker"));
				orderDto.setInfo_thumbImg(rs.getString("info_thumbImg"));
				
				List<OrderDTO> orderList = new ArrayList<>();
				orderList.add(orderDto);
				dto.setProdList(orderList);
				
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return list;
	}	
	
	//문의하기 등록
	public int setRegist(InquiryDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "";
			sql += "insert into inquiry values (";
			sql += "seq_inquiry.nextval, ?, ?, ?, ?, ?, ?, ?, ?";
			sql += ", sysdate)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getOrder_no());
			pstmt.setInt(2, dto.getInq_prodNo());
			pstmt.setInt(3, dto.getMember_no());
			pstmt.setInt(4, dto.getTypeNo());
			pstmt.setString(5, dto.getSubject());
			pstmt.setString(6, dto.getContent());
			pstmt.setInt(7, dto.getRef());
			pstmt.setInt(8, dto.getRef_step());
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	public int setDelete(InquiryDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "delete from inquiry where ref = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getRef());
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}	
}
