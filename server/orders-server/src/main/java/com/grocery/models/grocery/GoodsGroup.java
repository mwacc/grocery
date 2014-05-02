package com.grocery.models.grocery;

import java.io.Serializable;
import java.util.List;

public class GoodsGroup<T> implements Serializable {

	private static final long serialVersionUID = 1L;

	private int gid;
	private String name;
	private List<T> items;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<T> getItems() {
		return items;
	}
	public void setItems(List<T> items) {
		this.items = items;
	}
	public int getGid() {
		return gid;
	}
	public void setGid(int gid) {
		this.gid = gid;
	}
	
}
