package com.grocery.models.accounts;

import org.springframework.data.mongodb.core.index.Indexed;

public class MailUser extends User {

	private static final long serialVersionUID = 1L;
	
	@Indexed(unique=true)
	private String email;
	private String password;
	
	private String showedName;
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getShowedName() {
		return showedName;
	}
	public void setShowedName(String showedName) {
		this.showedName = showedName;
	}
	public String getUniqueName() {
		return getEmail();
	}
	@Override
	public String toString() {
		return "User [login=" + getEmail() + ", type=" + super.getType() + "]";
	}
}
