package model.dto;

import java.sql.Date;

public class MemberDTO {	
	//필드
	private int no;
	private String id;	
	private String passwd;
	private String passwdChk;
	private String name;
	private Date birth;
	private String gender;
	private String email;
	private String phone;
	private int addr_no;
	private String addr1;
	private String addr2;
	private String addr3;
	private Date regi_date;
	private Date pwdUpd_date;
	
	private int passChg_period;
	private int cart_cnt;
	private String beforePasswd;
	
	//Getter & Setter
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPasswd() {
		return passwd;
	}
	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}
	public String getPasswdChk() {
		return passwdChk;
	}
	public void setPasswdChk(String passwdChk) {
		this.passwdChk = passwdChk;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getBirth() {
		return birth;
	}
	public void setBirth(Date birth) {
		this.birth = birth;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public int getAddr_no() {
		return addr_no;
	}
	public void setAddr_no(int addr_no) {
		this.addr_no = addr_no;
	}
	public String getAddr1() {
		return addr1;
	}
	public void setAddr1(String addr1) {
		this.addr1 = addr1;
	}
	public String getAddr2() {
		return addr2;
	}
	public void setAddr2(String addr2) {
		this.addr2 = addr2;
	}
	public String getAddr3() {
		return addr3;
	}
	public void setAddr3(String addr3) {
		this.addr3 = addr3;
	}
	public Date getRegi_date() {
		return regi_date;
	}
	public void setRegi_date(Date regi_date) {
		this.regi_date = regi_date;
	}
	public Date getPwdUpd_date() {
		return pwdUpd_date;
	}
	public void setPwdUpd_date(Date pwdUpd_date) {
		this.pwdUpd_date = pwdUpd_date;
	}
	public int getPassChg_period() {
		return passChg_period;
	}
	public void setPassChg_period(int passChg_period) {
		this.passChg_period = passChg_period;
	}
	public int getCart_cnt() {
		return cart_cnt;
	}
	public void setCart_cnt(int cart_cnt) {
		this.cart_cnt = cart_cnt;
	}
	public String getBeforePasswd() {
		return beforePasswd;
	}
	public void setBeforePasswd(String beforePasswd) {
		this.beforePasswd = beforePasswd;
	}	
}
