package model.dto;

import java.sql.Date;
import java.util.List;

public class OrderDTO {
	//필드
	/* 주문상품 정보 */
	private int order_no;
	private int order_product_no;
	private int member_no;
	private int product_no;
	private int volume_order;
	private int add_sale;
	
	//추가 필드 (조인용)
	private String product_name;
	private String product_maker;
	private int selling_price;
	private int sale_percent;
	private String info_thumbImg;
	
	/* 수령인 정보 */
	private String name;
	private String phone;
	private int addr_no;
	private String addr1;
	private String addr2;
	private String addr3;	
	private String request_term;
	private String status;	//status 테이블 필요
	private Date order_date;
	
	private int cartNo;
	private List<Integer> cartNoList;
	private List<CartDTO> orderProdList;
	
	//Getter&Setter
	public int getOrder_no() {
		return order_no;
	}
	public void setOrder_no(int order_no) {
		this.order_no = order_no;
	}
	public int getOrder_product_no() {
		return order_product_no;
	}
	public void setOrder_product_no(int order_product_no) {
		this.order_product_no = order_product_no;
	}
	public int getMember_no() {
		return member_no;
	}
	public void setMember_no(int member_no) {
		this.member_no = member_no;
	}
	public int getProduct_no() {
		return product_no;
	}
	public void setProduct_no(int product_no) {
		this.product_no = product_no;
	}
	public int getVolume_order() {
		return volume_order;
	}
	public void setVolume_order(int volume_order) {
		this.volume_order = volume_order;
	}
	public int getAdd_sale() {
		return add_sale;
	}
	public void setAdd_sale(int add_sale) {
		this.add_sale = add_sale;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
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
	public String getRequest_term() {
		return request_term;
	}
	public void setRequest_term(String request_term) {
		this.request_term = request_term;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getOrder_date() {
		return order_date;
	}
	public void setOrder_date(Date order_date) {
		this.order_date = order_date;
	}
	public List<Integer> getCartNoList() {
		return cartNoList;
	}
	public void setCartNoList(List<Integer> cartNoList) {
		this.cartNoList = cartNoList;
	}
	public String getProduct_name() {
		return product_name;
	}
	public void setProduct_name(String product_name) {
		this.product_name = product_name;
	}
	public String getProduct_maker() {
		return product_maker;
	}
	public void setProduct_maker(String product_maker) {
		this.product_maker = product_maker;
	}
	public int getSelling_price() {
		return selling_price;
	}
	public void setSelling_price(int selling_price) {
		this.selling_price = selling_price;
	}
	public int getSale_percent() {
		return sale_percent;
	}
	public void setSale_percent(int sale_percent) {
		this.sale_percent = sale_percent;
	}
	public String getInfo_thumbImg() {
		return info_thumbImg;
	}
	public void setInfo_thumbImg(String info_thumbImg) {
		this.info_thumbImg = info_thumbImg;
	}
	public List<CartDTO> getOrderProdList() {
		return orderProdList;
	}
	public void setOrderProdList(List<CartDTO> orderProdList) {
		this.orderProdList = orderProdList;
	}
	public int getCartNo() {
		return cartNo;
	}
	public void setCartNo(int cartNo) {
		this.cartNo = cartNo;
	}
	
}
