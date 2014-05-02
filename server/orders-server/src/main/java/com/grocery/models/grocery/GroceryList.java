package com.grocery.models.grocery;

import java.io.Serializable;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;


public class GroceryList implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private List<GoodsGroup<GoodsItem>> goodsGroups = new LinkedList<GoodsGroup<GoodsItem>>();
	private String target;
	//private UserTypes targetType;
	private String language;
	
	public List<GoodsGroup<GoodsItem>> getGoodsGroups() {
		return goodsGroups;
	}
	public void setGoodsGroups(List<GoodsGroup<GoodsItem>> goodsGroups) {
		this.goodsGroups = goodsGroups;
	}
	public String getTarget() {
		return target;
	}
	public void setTarget(String target) {
		this.target = target;
	}
	
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	
	public GroceryList normalizeStructure() {
		if(goodsGroups != null) {
			Iterator<GoodsGroup<GoodsItem>> it = goodsGroups.iterator();
			while( it.hasNext() ) {
				GoodsGroup<GoodsItem> next = it.next();
				if( next == null ){
					it.remove();
					continue;
				}
				if( next.getItems() != null ) {
					Iterator<GoodsItem> it2 = next.getItems().iterator();
					while( it2.hasNext() ) {
						if( it2.next() == null ) it2.remove(); 
					}
				} else {
					it.remove();
				}
			}
		}
		return this;
	}
	
	public String getFlatGoods() {
		StringBuilder str = new StringBuilder();
		if(goodsGroups != null) {
			Iterator<GoodsGroup<GoodsItem>> it = goodsGroups.iterator();
			while( it.hasNext() ) {
				GoodsGroup<GoodsItem> next = it.next();
				if( next.getItems() != null ) {
					Iterator<GoodsItem> it2 = next.getItems().iterator();
					while( it2.hasNext() ) {
						str.append( it2.next().getName() + ", " );
					}
				} 
			}
		}
		return str.toString();
	}
	
	public String toString() {
		StringBuilder buf = new StringBuilder();
		for(GoodsGroup<GoodsItem> goodsGroup : goodsGroups) {
			buf.append( String.format("<br/> <b>%s</b>:", goodsGroup.getName()) );
			if( goodsGroup.getItems() != null ) {
				for(GoodsItem item : goodsGroup.getItems()) {
					buf.append( String.format("<br/>&nbsp;&nbsp;  %s <i>%s</i>", item.getName(), item.getC() != null ? item.getC() : "") );
				}
			}
		}
		
		return buf.toString();
	}
}
