package com.grocery.models.templates;

import java.util.LinkedList;
import java.util.List;

import com.grocery.models.MongoDocument;
import com.grocery.models.grocery.GoodsGroup;

public abstract class Template extends MongoDocument {

	private static final long serialVersionUID = 1L;
	
	protected String name;
	protected List<GoodsGroup<String>> goodsGroups = new LinkedList<GoodsGroup<String>>();
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	// C - custom, G- general
	public abstract String getType();
	
	public List<GoodsGroup<String>> getGoodsGroups() {
		return goodsGroups;
	}

	public void setGoodsGroups(List<GoodsGroup<String>> goodsGroups) {
		this.goodsGroups = goodsGroups;
	}

	@Override
	public String toString() {
		return "Template [name=" + name + ", goodsGroups=" + goodsGroups
				+ ", toString()=" + super.toString() + "]";
	}
	
	
}
