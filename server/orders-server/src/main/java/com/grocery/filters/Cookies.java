package com.grocery.filters;

public interface Cookies {

	public static final String AUTH_COOKIE = "epath";
	public static final int AUTH_COOKIE_TTL_SECONDS = 20*60; // 20 minutes 
	public static final String LANG_COOKIE = "lang";
	public static final String THEME_COOKIE = "th";
	public static final int THEME_COOKIE_TTL_SECONDS = 5*365*24*60*60; // 5 years

}