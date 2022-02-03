package model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import config.DB;
import model.dto.CartDTO;
import model.dto.OrderDTO;

public class OrderDAO {
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
	
	//주문내역 row 카운팅 호출
	public int getCountRow(OrderDTO dto, Date searchStart, Date searchEnd) { // 날짜 필터링 해야함
		int result = 0;
		getConn();
		try {
			String sql = "";
			sql += "select count(*) rowCnt from";
			sql += " (select o.order_no, p.name, p.selling_price, p.sale_percent,";
			sql += " p.maker, p.info_thumbImg, o.volume_order, o.status, o.order_date";
			sql += " from product p, orderTB o";
			sql += " where (p.no = o.product_no) and o.member_no = ?";			
			sql += " and order_date between ? and to_date( ?, 'YY/MM/DD') + 0.99999";		
//			sql += " and order_date between ? and ?";
			sql += " order by order_date desc, order_no desc, o.order_product_no desc) tb";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getMember_no());			
			pstmt.setDate(2, searchStart);
			pstmt.setDate(3, searchEnd);				
			rs = pstmt.executeQuery();			
			if(rs.next()) {
				result = rs.getInt("rowCnt");
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
		
	//주문내역
	public List<OrderDTO> getSelectAll(OrderDTO dto, Date searchStart, Date searchEnd, int rowMultiple) { // 날짜 필터링 해야함
		List<OrderDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "";
			sql += "select rownum, A.* from";
//			sql += "select tb2.* FROM (select @rownum := @rownum + 1 as rnum, tb1.* FROM";
			sql += " (select o.order_no, o.order_product_no, p.name, p.selling_price, p.sale_percent, p.maker, p.info_thumbImg,";
			sql += "  o.product_no, o.volume_order, o.add_sale, o.status, o.order_date";
			sql += " from product p, orderTB o";
			sql += " where (p.no = o.product_no) and o.member_no = ?";
			
			sql += " and order_date between ? and to_date( ?, 'YY/MM/DD') + 0.99999";
			sql += " order by order_date desc, order_no desc, o.order_product_no desc) A";
			sql += " where rownum between 1 and (5 * ?)";
			
//			sql += " and order_date BETWEEN ? and ?) tb1, (select @rownum := 0) TMP";
//			sql += " order by order_date desc, order_no DESC, order_product_no DESC) tb2";
//			sql += " where rnum between 1 and (5 * ?)";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getMember_no());
			pstmt.setDate(2, searchStart);
			pstmt.setDate(3, searchEnd);
			pstmt.setInt(4, rowMultiple);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				OrderDTO dto2 = new OrderDTO();
				dto2.setOrder_no(rs.getInt("order_no"));
				dto2.setOrder_product_no(rs.getInt("order_product_no"));
				dto2.setProduct_name(rs.getString("name"));
				dto2.setSelling_price(rs.getInt("selling_price"));
				dto2.setSale_percent(rs.getInt("sale_percent"));
				dto2.setProduct_maker(rs.getString("maker"));
				dto2.setInfo_thumbImg(rs.getString("info_thumbImg"));
				dto2.setProduct_no(rs.getInt("product_no"));
				dto2.setVolume_order(rs.getInt("volume_order"));
				dto2.setAdd_sale(rs.getInt("add_sale"));
				dto2.setStatus(rs.getString("status"));
				dto2.setOrder_date(rs.getDate("order_date"));
				list.add(dto2);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return list;
	}
	
	//주문내역 상세보기
	public OrderDTO getSelectOne(OrderDTO dto) {
		OrderDTO orderDto = new OrderDTO();
		List<CartDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "";
			sql += "select o.*, p.name product_name, p.* from orderTB o, product p";
			sql += " where (o.product_no = p.no)";
			sql += " and o.order_no = ?";
			if(!(dto.getPhone() == null || dto.getPhone().equals(""))) {
				sql += " and o.phone = ?";
			}
			sql += " order by order_product_no";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getOrder_no());
			if(!(dto.getPhone() == null || dto.getPhone().equals(""))) {
				pstmt.setString(2, dto.getPhone());
			}			
			
			rs = pstmt.executeQuery();			
			while(rs.next()) {
				orderDto.setOrder_no(rs.getInt("order_no"));
				orderDto.setName(rs.getString("name"));
				orderDto.setPhone(rs.getString("phone"));
				orderDto.setAddr_no(rs.getInt("addr_no"));
				orderDto.setAddr1(rs.getString("addr1"));
				orderDto.setAddr2(rs.getString("addr2"));
				orderDto.setAddr3(rs.getString("addr3"));
				orderDto.setRequest_term(rs.getString("request_term"));
				orderDto.setStatus(rs.getString("status"));
				orderDto.setOrder_date(rs.getDate("order_date"));
				
				CartDTO cartDto = new CartDTO();
				cartDto.setCart_no(rs.getInt("order_product_no"));
				cartDto.setProduct_no(rs.getInt("product_no"));
				cartDto.setVolume_order(rs.getInt("volume_order"));
				cartDto.setAdd_sale(rs.getInt("add_sale"));
				cartDto.setStatus(rs.getString("status"));
				
				cartDto.setProduct_name(rs.getString("product_name"));
				cartDto.setProduct_maker(rs.getString("maker"));
				cartDto.setSelling_price(rs.getInt("selling_price"));
				cartDto.setSale_percent(rs.getInt("sale_percent"));
				cartDto.setInfo_thumbImg(rs.getString("info_thumbImg"));
				cartDto.setDelivery_charge(rs.getInt("delivery_charge"));
				
				list.add(cartDto);
			}			
			orderDto.setOrderProdList(list);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return orderDto;
	}
	
	//취소요청 상품 정보 호출
	public OrderDTO getInfoOrderOne(OrderDTO dto) {
		OrderDTO orderDto = new OrderDTO();
		getConn();
		try {
			String sql = "";
			sql += "select o.order_product_no, p.name product_name, o.volume_order, o.status";
			sql += " from orderTB o, product p";
			sql += " where (o.product_no = p.no)";
			sql += " and o.order_product_no = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getOrder_product_no());			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				orderDto.setOrder_product_no(rs.getInt("order_product_no"));
				orderDto.setProduct_name(rs.getString("product_name"));
				orderDto.setVolume_order(rs.getInt("volume_order"));
				orderDto.setStatus(rs.getString("status"));
			}			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return orderDto;
	}
		
	//주문번호 호출
	public int getRecenctOrderNo(OrderDTO dto) { //성공시 주문번호 호출
		int orderNo = 0;				
		getConn();
		try {			
			String sql = "select max(order_no) as order_no from orderTB where member_no = ?";			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getMember_no());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				orderNo = rs.getInt("order_no");
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return orderNo;
	}
	
	//주문하기 (장바구니에서)
	public int setInsertInCart(OrderDTO dto, int count) {
		int result = 0;
		getConn();
		try {
			String sql = "";
			sql += "insert into orderTB";
			sql += " select";
			sql += " (select nvl(max(order_no),0)";
//			sql += " (select ifnull(max(order_no),0)";
			if(count == 1) {
				sql += "+" + count;
			}			
			sql += " from orderTB),";			
			sql += " (select nvl(max(order_product_no),0)+1 from orderTB),";
//			sql += " (select ifnull(max(order_product_no),0)+1 from orderTB),";
			sql += " ?, product_no, volume_order, add_sale,";
			sql += " ?, ?, ?, ?, ?, ?, ?, '결제완료', sysdate";
//			sql += " ?, ?, ?, ?, ?, ?, ?, '결제완료', curdate()";
			sql += " from cart where cart_no=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getMember_no());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getPhone());
			pstmt.setInt(4, dto.getAddr_no());
			pstmt.setString(5, dto.getAddr1());
			pstmt.setString(6, dto.getAddr2());
			pstmt.setString(7, dto.getAddr3());
			pstmt.setString(8, dto.getRequest_term());
			pstmt.setInt(9, dto.getCartNo());
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	//주문하기 (상세보기에서)
	public int setInsertInView(OrderDTO dto, int count) {
		int result = 0;
		getConn();
		try {
			String sql = "";
			sql += "insert into orderTB values(";
			sql += " (select nvl(max(order_no),0)";
//			sql += " (select ifnull(max(order_no),0)";
			if(count == 1) {
				sql += "+" + count;
			}			
			sql += " from orderTB),";
			sql += " (select nvl(max(order_product_no),0)+1 from orderTB),";
			sql += " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '결제완료', sysdate";
			sql += ")";
			
//			sql += ", ifnull(max(order_product_no),0)+1,";
//			sql += " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'curdate()";
//			sql += " from orderTB";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getMember_no());
			pstmt.setInt(2, dto.getProduct_no());
			pstmt.setInt(3, dto.getVolume_order());
			pstmt.setInt(4, dto.getAdd_sale());
			pstmt.setString(5, dto.getName());			
			pstmt.setString(6, dto.getPhone());
			pstmt.setInt(7, dto.getAddr_no());
			pstmt.setString(8, dto.getAddr1());
			pstmt.setString(9, dto.getAddr2());
			pstmt.setString(10, dto.getAddr3());
			pstmt.setString(11, dto.getRequest_term());
			result = pstmt.executeUpdate();	
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
	
	//배송지 변경
	public int setUpdateAddr(OrderDTO dto) {
		int result = 0;		
		getConn();
		try {
			String sql = "";
			sql += "update orderTB set";
			sql += " name = ?, phone = ?, addr_no = ?, addr1 = ?, addr2 = ?, addr3 = ?, request_term = ?";
			sql += " where order_no = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getPhone());
			pstmt.setInt(3, dto.getAddr_no());
			pstmt.setString(4, dto.getAddr1());
			pstmt.setString(5, dto.getAddr2());
			pstmt.setString(6, dto.getAddr3());
			pstmt.setString(7, dto.getRequest_term());
			pstmt.setInt(8, dto.getOrder_no());		
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}	
	
	//주문 취소
	public int setCancel(OrderDTO dto) {
		int result = 0;
		getConn();
		try {
			String sql = "update orderTB set status = '취소완료' where order_product_no = ?";
			
			pstmt = conn.prepareStatement(sql);		
			pstmt.setInt(1, dto.getOrder_product_no());
			result = pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return result;
	}
}
