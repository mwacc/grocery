package com.grocery.models;

import java.io.Serializable;

import org.springframework.data.annotation.Id;

public abstract class MongoDocument implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	private String id;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	
}
