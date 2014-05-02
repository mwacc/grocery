package com.grocery.filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.grocery.models.accounts.User;
import com.grocery.services.UsersService;

public class AuthFilter implements Filter {
	
	@Autowired
	private UsersService usersService;
	
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse,
			FilterChain filterChain) throws IOException, ServletException {
		final HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
        final HttpServletResponse httpResponse = (HttpServletResponse) servletResponse;
        
        if( httpRequest.getCookies() != null ) {
        	boolean isAuth = false;
	        for(Cookie cookie : httpRequest.getCookies() ) {
	        	if( Cookies.AUTH_COOKIE.equals(cookie.getName()) ) {
	        		User user = usersService.checkAutherization( cookie.getValue() );
	        		if( user != null ) {
	        			servletRequest.setAttribute(HeaderValues.userId, cookie.getValue());
	        			isAuth = true;
	        		}
	        	} else if( Cookies.LANG_COOKIE.equals(cookie.getName()) ) {
	        		servletRequest.setAttribute(HeaderValues.lang, cookie.getValue());
	        	}
	        }
	        if( isAuth ) {
	        	filterChain.doFilter(httpRequest, httpResponse);
    	        return;
	        }
        }
        
        httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        httpResponse.sendRedirect("../index.jsp");
	}
	

	@Override
	public void init(FilterConfig config) throws ServletException {
		WebApplicationContext springContext = 
		        WebApplicationContextUtils.getWebApplicationContext(config.getServletContext());
		this.usersService = springContext.getBean("usersService", UsersService.class);
	}

}
