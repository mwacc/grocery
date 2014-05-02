package com.grocery.models.accounts;

import java.io.Serializable;

public class PersonalSettings implements Serializable {
	private static final long serialVersionUID = 1L;

	private String theme;
	private boolean allowMailing;
	
	public String getTheme() {
		return theme;
	}

	public void setTheme(String theme) {
		this.theme = theme;
	}

	public boolean isAllowMailing() {
		return allowMailing;
	}

	public void setAllowMailing(boolean allowMailing) {
		this.allowMailing = allowMailing;
	}
	
}
