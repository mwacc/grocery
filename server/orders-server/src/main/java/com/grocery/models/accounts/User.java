package com.grocery.models.accounts;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.mongodb.core.mapping.Document;

import com.grocery.models.MongoDocument;

@Document( collection = "users" )
public abstract class User extends MongoDocument {

	private static final long serialVersionUID = 1L;

	public abstract String getUniqueName();
	
	private String lang;
	private String type;
	
	private PersonalSettings settings;
	
	
	private List<String> lastRecipients = new ArrayList<String>(10);
	
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	
	
	public PersonalSettings getSettings() {
		return settings;
	}
	public void setSettings(PersonalSettings settings) {
		this.settings = settings;
	}
	
	public List<String> getLastRecipients() {
		return lastRecipients;
	}
	public void setLastRecipients(List<String> lastRecipients) {
		this.lastRecipients = lastRecipients;
	}
	
}
