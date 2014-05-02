package com.grocery.dao.logic;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.grocery.models.grocery.GoodsGroup;
import com.grocery.models.templates.CustomTemplate;
import com.grocery.models.templates.GeneralTemplate;

public class TemplatesCreator {
	
	public static List<GeneralTemplate> getGeneralTemplate() {
		List<GeneralTemplate> l = new ArrayList<GeneralTemplate>();
		
		GeneralTemplate template1 = new GeneralTemplate();
		template1.setLang("EN");
		template1.setName("name1");
		
		template1.setItems( getGoodGroups() );
		l.add(template1);
		
		GeneralTemplate template2 = new GeneralTemplate();
		template2.setLang("RU");
		template2.setName("name2");
		template1.setItems( getGoodGroups() );
		l.add(template2);
		
		return l;
	}
	
	public static List<CustomTemplate> getCustomTemplates() {
		List<CustomTemplate> l = new ArrayList<CustomTemplate>();
		
		CustomTemplate template1 = new CustomTemplate();
		template1.setName("name1");
		template1.setId("1");
		
		template1.setItems( getGoodGroups() );
		l.add(template1);
		
		CustomTemplate template2 = new CustomTemplate();
		template2.setName("name2");
		template2.setId("2");
		l.add(template2);
		
		return l;
	}
	
	public static CustomTemplate getCustomTemplate() {
		CustomTemplate template1 = new CustomTemplate();
		template1.setName("BUY");
		template1.setId("ghj235sff5y6gg");
		
		template1.setItems( getGoodGroups() );
		
		return template1;
	}
	
	private static List<GoodsGroup<String>> getGoodGroups() {
		List<GoodsGroup<String>> groups = new ArrayList<GoodsGroup<String>>();
		GoodsGroup<String> group = new GoodsGroup<String>();
		group.setName("Fish");
		group.setItems(Arrays.asList( new String[]{"Salmon","Beef"} ));
		groups.add(group);
		return groups;
	}

}
