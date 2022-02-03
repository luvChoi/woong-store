package config;

import java.sql.*;

public class DB {
	
	public static Connection dbConn() {	
		String dbDriver = "oracle.jdbc.driver.OracleDriver";
		String dbUrl = "jdbc:oracle:thin:@localhost:1521/xe";
		String dbId = "woong_shop";
		String dbPasswd = "1234";
//		String dbDriver = "com.mysql.jdbc.Driver";
//		String dbUrl = "jdbc:mysql://localhost/soulofaiur";		
//		String dbId = "soulofaiur";
//		String dbPasswd = "d!00798ryu";
		
		Connection conn = null;
		try {
			Class.forName(dbDriver);
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			conn = DriverManager.getConnection(dbUrl, dbId, dbPasswd); //DB 접속 실패하면 예외처리로 감
		} catch(Exception e) {
			e.printStackTrace();
		}		 
		return conn;
	}
	
	public static void dbConnClose(ResultSet rs, PreparedStatement pstmt, Connection conn) {
		try {
			if (rs !=null ) { rs.close(); }			
		} catch(Exception e) {
			e.printStackTrace();
		}
		try {
			if (pstmt !=null) { pstmt.close(); }			
		} catch(Exception e) {
			e.printStackTrace();
		}
		try {
			if (conn !=null) { conn.close(); }			
		} catch(Exception e) {
			e.printStackTrace();
		}
	}	
}
