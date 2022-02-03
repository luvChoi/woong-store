package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import config.DB;
import model.dto.RequestCancelDTO;

public class RequestCancelDAO {
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
	
	//취소사유 종류 호출
	public List<RequestCancelDTO> getCancelType() {
		List<RequestCancelDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "select * from cancelType order by no";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				RequestCancelDTO dto = new RequestCancelDTO();
				dto.setTypeNo(rs.getInt("no"));
				dto.setCancelTypeStr(rs.getString("cancel_type"));
				list.add(dto);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return list;
	}
	
	//취소사유 입력
	public int setInsert(RequestCancelDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "";
			sql += "insert into infoCancel(no, order_product_no, cancel_type, cancel_reason, cancel_date) values (";
			sql += " (select nvl(max(no), 0) + 1 from infoCancel), ?, ?, ?, sysdate)";			

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getOrder_product_no());
			pstmt.setInt(2, dto.getCancel_type());
			pstmt.setString(3, dto.getCancel_reason());
			result = pstmt.executeUpdate();	
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	public RequestCancelDTO getSelectInfo(RequestCancelDTO dto) {
		RequestCancelDTO dtoInfo = new RequestCancelDTO();
		getConn();
		try {
			String sql = "";
			sql += "select i.order_product_no, p.name product_name, o.volume_order, o.status, c.cancel_type, i.cancel_reason";
			sql += " from infoCancel i, cancelType c, orderTB o, product p";
			sql += " where (i.order_product_no = o.order_product_no";
			sql += " and i.cancel_type = c.no and o.product_no = p.no)";
			sql += " and o.order_product_no = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getOrder_product_no());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dtoInfo.setOrder_product_no(rs.getInt("order_product_no"));
				dtoInfo.setProduct_name(rs.getString("product_name"));
				dtoInfo.setVolume_order(rs.getInt("volume_order"));
				dtoInfo.setStatus(rs.getString("status"));
				dtoInfo.setCancelTypeStr(rs.getString("cancel_type"));
				dtoInfo.setCancel_reason(rs.getString("cancel_reason"));
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return dtoInfo;
	}	
}
