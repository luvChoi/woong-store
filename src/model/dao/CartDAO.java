package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import config.DB;
import model.dto.CartDTO;

public class CartDAO {
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
	
	//장바구니 수량확인
	public int getCartCnt(CartDTO dto) {
		int cartCnt = 0;
		getConn();
		try {
			String sql = "select count(*) cnt_cartOfMember from cart where member_no = ?";			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getMember_no());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				cartCnt = rs.getInt("cnt_cartOfMember");
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return cartCnt;
	}
	
	//장바구니 목록 조회
	public List<CartDTO> getCartList(CartDTO dto) {
		List<CartDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "";
			sql += "select cart_no, product_no, volume_order, add_sale, name, maker, selling_price, sale_percent, info_thumbImg";
			sql += " from cart c inner join product p";
			sql += " on c.product_no = p.no";
			sql += " where member_no = ?";
			if(dto.getCartNoList() != null) {
				sql += " and cart_no in (?";
				if(dto.getCartNoList().size() > 1) {
					for(int i = 2; i <= dto.getCartNoList().size(); i++) {
						sql += ",?";					
					}
				}
				sql += ")";				
			}
			sql += " order by c.regi_date desc, c.cart_no desc";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getMember_no());
			if(dto.getCartNoList() != null) {
				int i = 2;
				for(Integer k : dto.getCartNoList()) {					
					pstmt.setInt(i, k);
					i++;
				}
			}
			rs = pstmt.executeQuery();
			while(rs.next()) {
				CartDTO dtoList = new CartDTO();
				dtoList.setCart_no(rs.getInt("cart_no"));
				dtoList.setProduct_no(rs.getInt("product_no"));
				dtoList.setVolume_order(rs.getInt("volume_order"));
				dtoList.setAdd_sale(rs.getInt("add_sale"));
				dtoList.setProduct_name(rs.getString("name"));
				dtoList.setProduct_maker(rs.getString("maker"));
				dtoList.setSelling_price(rs.getInt("selling_price"));
				dtoList.setSale_percent(rs.getInt("sale_percent"));
				dtoList.setInfo_thumbImg(rs.getString("info_thumbImg"));
				list.add(dtoList);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return list;
	}
	
	//장바구니 추가
	public int setInsert(CartDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "insert into cart(cart_no, member_no, product_no, volume_order, add_sale, regi_date) ";
			sql += " values((select nvl(max(cart_no),0)+1 from cart), ?, ?, ?, ?, sysdate)";
			//String sql = "insert into cart(cart_no, member_no, product_no, volume_order, add_sale, regi_date) ";
			//sql += " select IFNULL(max(cart_no),0)+1, ?, ?, ?, ?, CURDATE() FROM cart";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getMember_no());
			pstmt.setInt(2, dto.getProduct_no());
			pstmt.setInt(3, dto.getVolume_order());
			pstmt.setInt(4, dto.getAdd_sale());
			result = pstmt.executeUpdate();			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	//장바구니 수정
	public int setUpdate(CartDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "update cart set volume_order = ? where cart_no = ?";	
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getVolume_order());
			pstmt.setInt(2, dto.getCart_no());
			result = pstmt.executeUpdate();		
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}	
	
	//장바구니 삭제
	public int setDelete(CartDTO dto) {
		int result = 0;
		int cartNoListSize = 0;
		if(dto.getCartNoList() != null) {
			cartNoListSize = dto.getCartNoList().size();
		}		
		getConn();
		try {
			String sql = "delete from cart where cart_no in (";
			if(cartNoListSize > 1) {
				for(int i=0; i < cartNoListSize - 1; i++) {
					sql += "?, ";
				}
			}
			sql +="?)";
			pstmt = conn.prepareStatement(sql);
			
			int k = 1;
			if(dto.getCartNoList() != null) {
				for(int cartNo : dto.getCartNoList()) {
					pstmt.setInt(k++, cartNo);
				}
			} else {
				pstmt.setInt(1, dto.getCart_no());
			}
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
}
