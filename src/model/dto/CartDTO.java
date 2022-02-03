package model.dto;

import java.sql.Date;
import java.util.List;

public class CartDTO {
	//필드
	private int cart_no;
	private int member_no;
	private int product_no;
	private int volume_order;
	private int add_sale;
	private Date regi_date;
	
	//추가 필드 (조인용)
	private String product_name;
	private String product_maker;
	private int selling_price;
	private int sale_percent;
	private String info_thumbImg;
	private int delivery_charge; //배송비
	private String status; //진행상태
	
	private int cnt_cartOfMember; //회원별 장바구니 수량
	private List<Integer> cartNoList;
	
	//Getter&Setter
	public int getCart_no() {
		return cart_no;
	}
	public void setCart_no(int cart_no) {
		this.cart_no = cart_no;
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
	public Date getRegi_date() {
		return regi_date;
	}
	public void setRegi_date(Date regi_date) {
		this.regi_date = regi_date;
	}
	public int getCnt_cartOfMember() {
		return cnt_cartOfMember;
	}
	public void setCnt_cartOfMember(int cnt_cartOfMember) {
		this.cnt_cartOfMember = cnt_cartOfMember;
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
	public List<Integer> getCartNoList() {
		return cartNoList;
	}
	public void setCartNoList(List<Integer> cartNoList) {
		this.cartNoList = cartNoList;
	}
	public int getDelivery_charge() {
		return delivery_charge;
	}
	public void setDelivery_charge(int delivery_charge) {
		this.delivery_charge = delivery_charge;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
}
