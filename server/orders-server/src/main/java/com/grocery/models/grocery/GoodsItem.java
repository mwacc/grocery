package com.grocery.models.grocery;

import java.io.Serializable;

public class GoodsItem implements Serializable {

	private static final long serialVersionUID = 1L;

	private String name;
	private String c; // comment or quantity

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getC() {
		return c;
	}

	public void setC(String c) {
		this.c = c;
	}
	
	
}
