package model.dto;

import java.sql.Date;

public class RequestCancelDTO {
	//필드 : 주문취소
	private int no;
	private int order_product_no;
	private int cancel_type;
	private String cancel_reason;
	private Date cancel_date;	
	//필드 : 취소타입
	private int typeNo;
	private String cancelTypeStr;	
	//필드 : 조인을 위함
	private String product_name;
	private int volume_order;
	private String status;
	
	//Getter&Setter
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public int getOrder_product_no() {
		return order_product_no;
	}
	public void setOrder_product_no(int order_product_no) {
		this.order_product_no = order_product_no;
	}
	public int getCancel_type() {
		return cancel_type;
	}
	public void setCancel_type(int cancel_type) {
		this.cancel_type = cancel_type;
	}
	public String getCancel_reason() {
		return cancel_reason;
	}
	public void setCancel_reason(String cancel_reason) {
		this.cancel_reason = cancel_reason;
	}
	public int getTypeNo() {
		return typeNo;
	}
	public void setTypeNo(int typeNo) {
		this.typeNo = typeNo;
	}
	public String getCancelTypeStr() {
		return cancelTypeStr;
	}
	public void setCancelTypeStr(String cancelTypeStr) {
		this.cancelTypeStr = cancelTypeStr;
	}
	public Date getCancel_date() {
		return cancel_date;
	}
	public void setCancel_date(Date cancel_date) {
		this.cancel_date = cancel_date;
	}
	public String getProduct_name() {
		return product_name;
	}
	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}
	public int getVolume_order() {
		return volume_order;
	}
	public void setVolume_order(int volume_order) {
		this.volume_order = volume_order;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}	
}
