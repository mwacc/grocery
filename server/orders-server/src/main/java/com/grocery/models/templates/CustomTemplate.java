package com.grocery.models.templates;

import java.util.Iterator;

import org.springframework.data.mongodb.core.mapping.Document;

import com.grocery.models.grocery.GoodsGroup;


@Document( collection = "custom_templates" )
public class CustomTemplate extends Template {

	private static final long serialVersionUID = 1L;

	protected String type = "C";
	protected String ownerId; // user id
	
	
	@Override
	public String toString() {
		return "CustomTemplate [name=" + super.getName() + ", ownerId=" + ownerId + "]";
	}
	
	@Override
	public String getType() {
		return type;
	}
	
	public String getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}

	public CustomTemplate normalizeStructure() {
		if(goodsGroups != null) {
			Iterator<GoodsGroup<String>> it = goodsGroups.iterator();
			while( it.hasNext() ) {
				GoodsGroup<String> next = it.next();
				if( next == null ) it.remove();
				if( next.getItems() != null ) {
					Iterator<String> it2 = next.getItems().iterator();
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
	
}
