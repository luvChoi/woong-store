package model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import config.DB;
import model.dto.ProductDTO;

public class ProductDAO {
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
			
	//상품분류List
	public List<ProductDTO> getProductType() {
		List<ProductDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "select * from productType order by no";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setClassify_no(rs.getInt("no"));
				dto.setClassification(rs.getString("product_type"));
				list.add(dto);
			}			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}		
		return list;
	}
	
	//totalRecord (제품구분별 & 검색결과)
	public int getTotalRecord(String classification, String searchWord) {
		int totalRecord  = 0;
		getConn();
		try {
			String sql = "";
			sql += "select count(*) totalRecord from product where 1 = 1";
			if(!classification.equals("-") && searchWord.equals("-")) {
				sql += " and classification = ?";				
			} else if(classification.equals("-") && !searchWord.trim().equals("")) {
				sql += " and name like ? or description like ?";
			}
			pstmt = conn.prepareStatement(sql);
			if(!classification.equals("-") && searchWord.equals("-")) {
				pstmt.setString(1, classification);
			} else if(classification.equals("-") && !searchWord.trim().equals("")) {
				pstmt.setString(1, "%" + searchWord + "%");
				pstmt.setString(2, "%" + searchWord + "%");				
			}
			rs = pstmt.executeQuery();
			if(rs.next()) {
				totalRecord = rs.getInt("totalRecord");						
			}			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}		
		return totalRecord;
	}
	
	//제품목록 (제품군별 & 검색결과)
	public List<ProductDTO> getTypeOrSearch(String classification, String searchWord, String orderBy, int startRecord, int lastRecord) {
		List<ProductDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "";
			sql += "select * from (select rownum rnum, a.* from";
			sql += " (select * from (select (selling_price * (100 - sale_percent)) last_price, p.* from product p)";			
			if(!classification.equals("-") && searchWord.equals("-")) {
				sql += " where classification = ?";
			} else if(classification.equals("-") && !searchWord.trim().equals("")) {
				sql += " where name like ? or description like ?";
			}			
			sql += " order by " + orderBy + ") a) where rnum between ? and ?";
			
			pstmt = conn.prepareStatement(sql);
			int k = 1;
			if(!classification.equals("-") && searchWord.equals("-")) {
				pstmt.setString(k++, classification);		
			} else if(classification.equals("-") && !searchWord.trim().equals("")) {
				pstmt.setString(k++, "%" + searchWord + "%");
				pstmt.setString(k++, "%" + searchWord + "%");
			}
			pstmt.setInt(k++, startRecord);
			pstmt.setInt(k++, lastRecord);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setNo(rs.getInt("no"));
				dto.setClassification(rs.getString("classification"));
				dto.setInfo_thumbImg(rs.getString("info_thumbImg"));		
				dto.setName(rs.getString("name"));
				dto.setSelling_price(rs.getInt("selling_price"));
				dto.setSale_percent(rs.getInt("sale_percent"));
				dto.setDescription(rs.getString("description"));
				list.add(dto);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return list;
	}
		
	//신상 목록
	public List<ProductDTO> getNewProdList(Date searchStart, int endRecordNum) {
		List<ProductDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "";
			sql += "select * from (select rownum rnum, a.* from (select * from  product";
			sql += " where regi_date >= ? order by regi_date desc) a)";
			sql += " where rnum between 1 AND ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setDate(1, searchStart);
			pstmt.setInt(2, endRecordNum);	
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setNo(rs.getInt("no"));
				dto.setClassification(rs.getString("classification"));
				dto.setInfo_thumbImg(rs.getString("info_thumbImg"));				
				dto.setName(rs.getString("name"));
				dto.setSelling_price(rs.getInt("selling_price"));
				dto.setSale_percent(rs.getInt("sale_percent"));				
				list.add(dto);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return list;
	}
		
	//베스트 목록
	public List<ProductDTO> getBestProdList(Date searchStart, int endRecordNum) {
		List<ProductDTO> list = new ArrayList<>();
		getConn();
		try {
			String sql = "";
			sql += "select * from (select rownum rnum, tb.* from (select o.salesVol, p.* from product p,";
			sql += " (select product_no, sum(volume_order) salesVol from orderTB";
			sql += " where status != '취소완료' and order_date >= ? group by product_no) o";
			sql += " where p.no = o.product_no";
			sql += " order by o.salesVol desc, p.regi_date) tb) tbtb where rnum between 1 and ?";			
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setDate(1, searchStart);
			pstmt.setInt(2, endRecordNum);	
			rs = pstmt.executeQuery();			
			while(rs.next()) {
				ProductDTO dto = new ProductDTO();
				dto.setNo(rs.getInt("no"));
				dto.setClassification(rs.getString("classification"));
				dto.setInfo_thumbImg(rs.getString("info_thumbImg"));				
				dto.setName(rs.getString("name"));
				dto.setSelling_price(rs.getInt("selling_price"));
				dto.setSale_percent(rs.getInt("sale_percent"));				
				list.add(dto);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return list;
	}	
	
	//상세보기
	public ProductDTO getSelectOne(ProductDTO dto) {
		ProductDTO dtoView = new ProductDTO();
		getConn();
		try {
			String sql = "select * from product where no=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getNo());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dtoView.setNo(rs.getInt("no"));
				dtoView.setClassification(rs.getString("classification"));
				dtoView.setName(rs.getString("name"));
				dtoView.setMaker(rs.getString("maker"));
				dtoView.setPurchase_price(rs.getInt("purchase_price"));
				dtoView.setSelling_price(rs.getInt("selling_price"));
				dtoView.setSale_percent(rs.getInt("sale_percent"));
				dtoView.setStock(rs.getInt("stock"));
				dtoView.setInfo_thumbImg(rs.getString("info_thumbImg"));
				dtoView.setDescription(rs.getString("description"));
				dtoView.setRegi_date(rs.getDate("regi_date"));
				dtoView.setUpd_date(rs.getDate("upd_date"));
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			getConnClose();
		}
		return dtoView;
	}	
}
