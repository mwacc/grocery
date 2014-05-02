package com.grocery.models.accounts;

public enum UserTypes {
	EMAIL("E"),
	TWITTER("T"),
	FB("F"),
	GOOGLE("G");
	
	String type;
	
	UserTypes(String type) {
		this.type = type;
	}
	
	public String getType() {
		return this.type;
	}

}
