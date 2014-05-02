package com.grocery.controllers;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.CookieGenerator;

import com.grocery.filters.Cookies;
import com.grocery.models.accounts.PersonalSettings;
import com.grocery.models.accounts.User;
import com.grocery.services.UsersService;
import com.grocery.statistic.UserLoginLog;

/** This path excluded from auth filter */
@Controller
public class UsersController {
	

	private static final Logger log = LoggerFactory.getLogger(UsersController.class);
	private static final Logger loginMonitor = LoggerFactory.getLogger(UserLoginLog.class);
	
	
	@Autowired
	private UsersService usersServices;
	
	@RequestMapping(value="/users/new", method = RequestMethod.POST)
	public void registerNewUser(@RequestBody User user, 
			HttpServletRequest request, HttpServletResponse response) {
		log.info("Try to register new user {}", user);
		usersServices.registerNewUser(user);
	}
	
	@RequestMapping(value="/users/try2restore", method = RequestMethod.POST)
	public void tryRestorePassword( 
			HttpServletRequest request, HttpServletResponse response) {
		String mail = request.getParameter("mail");
		log.info("User with email {} requested password chages from ip {}", mail, ControllerUtil.getRemoteIp(request));
		if( usersServices.userForgotPassword(mail) ) {
			response.setStatus(HttpServletResponse.SC_OK);
		} else {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}
	
	@RequestMapping(value="/users/register", method = RequestMethod.POST)
	public void tryToRegister( 
			HttpServletRequest request, HttpServletResponse response) {
		
		if( request.getParameter("pass").length() < 5 || request.getParameter("pass").length() > 30 || 
				request.getParameter("mail").length() > 40 ) {
			log.warn("Someone from ip {} tried to fuck up us w/ mail {}", request.getRemoteAddr(), request.getParameter("mail"));
		} else {
			log.info("User registration with mail {} from ip {}", request.getParameter("mail"), request.getRemoteAddr());
			usersServices.register(request.getParameter("mail"), 
					request.getParameter("pass"), request.getParameter("lang"), request.getParameter("refId"));
			response.setStatus(HttpServletResponse.SC_OK);
		}
	}
	
	@RequestMapping(value="/users/restore/{key}", method = RequestMethod.POST)
	public void restore(@PathVariable String key, HttpServletRequest request, HttpServletResponse response) {
		String pass = request.getParameter("pass");
		String repass = request.getParameter("repass");
		
		if( pass == null || repass == null || !pass.equals(repass) ) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		
		User user = usersServices.getUserForPasswordRestoring(key);
		if( user == null ) {
			log.warn("User tried to restore password by key {} from ip {}", key, ControllerUtil.getRemoteIp(request));
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		} else {
			log.info("User id {} email {} restore his password from ip {}", new String[]{user.getId(), user.getUniqueName(), ControllerUtil.getRemoteIp(request)});
			if( usersServices.changePassword(user.getId(), repass) ) {
				response.setStatus(HttpServletResponse.SC_OK);
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
		}
	}
	
	@RequestMapping(value="/users/signin", method=RequestMethod.POST)
    public void signInUser(HttpServletRequest request, HttpServletResponse response) {
		String login = request.getParameter("email");
		String pass = request.getParameter("pass");
		
		User user = usersServices.signInUser(login, pass);
		if( user != null ) {
			loginMonitor.info(login);
			/*Cookie cookie = new Cookie(Cookies.AUTH_COOKIE, user.getId());
			cookie.setSecure(true);
			cookie.setMaxAge(Cookies.AUTH_COOKIE_TTL_SECONDS*60);
			response.addCookie(cookie);*/
			CookieGenerator cookieGenerator = new CookieGenerator();
			cookieGenerator.setCookieName(Cookies.AUTH_COOKIE);
			cookieGenerator.setCookieMaxAge(Cookies.AUTH_COOKIE_TTL_SECONDS);
			cookieGenerator.addCookie(response, user.getId());
			
			cookieGenerator.setCookieName(Cookies.THEME_COOKIE);
			cookieGenerator.setCookieMaxAge(Cookies.THEME_COOKIE_TTL_SECONDS);
			PersonalSettings personalSettings = usersServices.getPersonalSettings(user.getId());
			cookieGenerator.addCookie(response, personalSettings.getTheme());
			
			response.setStatus(HttpServletResponse.SC_OK);
		} else {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
		}
	}
	
	// prefix 's' means secured urls 
	
	@RequestMapping(value="/s/users/signout", method=RequestMethod.POST)
    public void signOutUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String userId = ControllerUtil.getUserIdFromRequest(request);
		usersServices.signOutUser(userId);
		response.setStatus(HttpServletResponse.SC_OK);
	}
	
	@RequestMapping(value="/s/users/changepass", method=RequestMethod.POST)
    public void changePassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String userId = ControllerUtil.getUserIdFromRequest(request);
		
		String oldPass = request.getParameter("oldpass");
		String pass = request.getParameter("newpass");
		String repass = request.getParameter("renewpass");
		
		if( pass == null || repass == null || oldPass == null || !pass.equals(repass) ) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		} else {
			if( usersServices.changePassword(userId, oldPass, pass) ) {
				response.setStatus(HttpServletResponse.SC_OK);
			} else {
				response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
		}
	}
	
	@RequestMapping(value="/s/users/accsettings", method=RequestMethod.GET)
	public @ResponseBody PersonalSettings getPersonalSettings(HttpServletRequest request, HttpServletResponse response) {
		String userId = ControllerUtil.getUserIdFromRequest(request);
		PersonalSettings personalSettings = usersServices.getPersonalSettings(userId);
		
		response.setStatus(HttpServletResponse.SC_OK);
		return personalSettings;
	}
	
	@RequestMapping(value="/s/users/updateaccsettings", method=RequestMethod.POST)
	public void updatePersonalSettings(@RequestBody PersonalSettings accSettings,
			HttpServletRequest request, HttpServletResponse response) {
		String userId = ControllerUtil.getUserIdFromRequest(request);
		usersServices.updatePersonalSettings(accSettings, userId);
		
		CookieGenerator cookieGenerator = new CookieGenerator();
		cookieGenerator.setCookieName(Cookies.THEME_COOKIE);
		cookieGenerator.setCookieMaxAge(Cookies.THEME_COOKIE_TTL_SECONDS);
		cookieGenerator.addCookie(response, accSettings.getTheme());
		
		response.setStatus(HttpServletResponse.SC_OK);
	}
	
	
	// TODO only for debugging purposes
	@RequestMapping(value = "/users/test", method = RequestMethod.GET, produces = "text/plain; charset=utf-8")
	@ResponseBody
	public String test(){
		return "сало з огірком";
	}
	
	
	@RequestMapping(value="/users/ex", method = RequestMethod.GET)
    public void getException() throws Exception {
		throw new Exception("Expected exception");
	}
	
	@RequestMapping(value="/users/er", method = RequestMethod.GET)
    public void getError() {
		throw new Error("Expected error");
	}
	
	
}
