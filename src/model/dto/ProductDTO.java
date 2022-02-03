package model.dto;

import java.sql.Date;

public class ProductDTO {
	//필드	
	private int no;
	private String classification;
	private String name;
	private String maker;
	private int purchase_price;
	private int selling_price;
	private int sale_percent;
	private int stock;
	private String info_thumbImg;	
	private String description;
	private Date regi_date;
	private Date upd_date;	
	private int delivery_charge; //배송비
	
	//조인필드
	private int classify_no;
	private int maker_no;
		
	//Getter&Setter
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getClassification() {
		return classification;
	}
	public void setClassification(String classification) {
		this.classification = classification;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}	
	public String getMaker() {
		return maker;
	}
	public void setMaker(String maker) {
		this.maker = maker;
	}
	public int getPurchase_price() {
		return purchase_price;
	}
	public void setPurchase_price(int purchase_price) {
		this.purchase_price = purchase_price;
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
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}	
	public String getInfo_thumbImg() {
		return info_thumbImg;
	}
	public void setInfo_thumbImg(String info_thumbImg) {
		this.info_thumbImg = info_thumbImg;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public Date getRegi_date() {
		return regi_date;
	}
	public void setRegi_date(Date regi_date) {
		this.regi_date = regi_date;
	}
	public Date getUpd_date() {
		return upd_date;
	}
	public void setUpd_date(Date upd_date) {
		this.upd_date = upd_date;
	}
	public int getDelivery_charge() {
		return delivery_charge;
	}
	public void setDelivery_charge(int delivery_charge) {
		this.delivery_charge = delivery_charge;
	}
	public int getClassify_no() {
		return classify_no;
	}
	public void setClassify_no(int classify_no) {
		this.classify_no = classify_no;
	}
	public int getMaker_no() {
		return maker_no;
	}
	public void setMaker_no(int maker_no) {
		this.maker_no = maker_no;
	}	
}
