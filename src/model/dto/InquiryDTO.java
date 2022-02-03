package model.dto;

import java.sql.Date;
import java.util.List;

public class InquiryDTO {
	//문의하기
	private int no;
	private int order_no;
	private int inq_prodNo;
	private int member_no;
	private String subject;
	private String content;
	private int ref;
	private int ref_step;
	private Date regi_date;
	
	//조인필드
	private int typeNo;
	private String typeStr;	
	private List<OrderDTO> prodList;
	
	//Getter&Setter
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public int getOrder_no() {
		return order_no;
	}
	public void setOrder_no(int order_no) {
		this.order_no = order_no;
	}	
	public int getInq_prodNo() {
		return inq_prodNo;
	}
	public void setInq_prodNo(int inq_prodNo) {
		this.inq_prodNo = inq_prodNo;
	}
	public int getMember_no() {
		return member_no;
	}
	public void setMember_no(int member_no) {
		this.member_no = member_no;
	}
	public int getTypeNo() {
		return typeNo;
	}
	public void setTypeNo(int type_no) {
		this.typeNo = type_no;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getRef() {
		return ref;
	}
	public void setRef(int ref) {
		this.ref = ref;
	}
	public int getRef_step() {
		return ref_step;
	}
	public void setRef_step(int ref_step) {
		this.ref_step = ref_step;
	}
	public Date getRegi_date() {
		return regi_date;
	}
	public void setRegi_date(Date regi_date) {
		this.regi_date = regi_date;
	}	
	public String getTypeStr() {
		return typeStr;
	}
	public void setTypeStr(String typeStr) {
		this.typeStr = typeStr;
	}
	public List<OrderDTO> getProdList() {
		return prodList;
	}
	public void setProdList(List<OrderDTO> prodList) {
		this.prodList = prodList;
	}	
}
