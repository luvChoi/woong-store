package model.dto;

import java.sql.Date;
import java.util.List;

public class InquiryDTO {
	//문의하기
	private int no;				//일련번호
	private int order_no;		//주문번호
	private int inq_prodNo; 	//문의상품번호
	private int member_no;		//회원번호
	private String subject;		//제목
	private String content;		//내용
	private int ref;			//문의번호
	private int ref_step;		//문의&답변 구분
	private Date regi_date;		//등록일
	//문의유형
	private int typeNo;			//문의유형번호
	private String typeStr;		//문의유형
	//조인필드
	private List<OrderDTO> prodList;	//주문상품리스트
	
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
