package com.grocery.models.templates;

import org.springframework.data.mongodb.core.mapping.Document;

@Document( collection = "general_templates" )
public class GeneralTemplate extends Template {

	private static final long serialVersionUID = 1L;

	private String lang;
	protected String type = "G";

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	@Override
	public String getType() {
		return type;
	}
	
}
