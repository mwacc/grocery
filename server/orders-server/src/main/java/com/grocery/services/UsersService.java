package com.grocery.services;

import java.util.UUID;

import org.apache.commons.codec.digest.DigestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import com.grocery.dao.UsersDao;
import com.grocery.models.accounts.MailUser;
import com.grocery.models.accounts.PersonalSettings;
import com.grocery.models.accounts.User;
import com.grocery.services.cache.RestorePasswordCache;
import com.grocery.services.cache.UserCacheService;
import com.grocery.statistic.UserRegistrator;

@Service
@Scope("singleton")
public class UsersService {
	
	private static final Logger registrator = LoggerFactory.getLogger(UserRegistrator.class);
	
	@Autowired
	private UsersDao dao;
	
	@Autowired
	private UserCacheService cache;
	
	@Autowired
	private RestorePasswordCache passCache;
	
	@Autowired
	private MailService mailService;
	
	public void registerNewUser(User newUser) {
		// TODO: object validation
		dao.registerNewUser(newUser);
	}
	
	public User signInUser(String mail, String password) {
		User user = dao.checkUserAuth(mail, DigestUtils.md5Hex(password));
		if( user != null ) {
			cache.putElement(user.getId(), user);
		}
		return user;
	}
	
	public void signOutUser(String userId) {
		cache.remove(userId);
	}
	
	public boolean userForgotPassword(String userMail) {
		User user = dao.getUserByMail(userMail);
		if( user != null ) {
			String guid = UUID.randomUUID().toString();
			passCache.putElement(guid, user.getId());
			
			return mailService.putEmailOnForgottenPassword(userMail, guid, "en");
		} else {
			return false;
		}
	}
	
	public boolean register(String mail, String password, String lang, String refId) {
		registrator.info( String.format("{'email':'%s', 'password':'%s', 'type':'E', 'lang':'%s', 'refId':'%s', '_class':'com.grocery.models.accounts.MailUser'}", 
				new Object[]{mail, DigestUtils.md5Hex(password), lang.toUpperCase(), refId}) );
		return true;
	}
	
	public User getUserForPasswordRestoring(String key) {
		String userId = passCache.getElement(key);
		passCache.remove(key);
		if( userId == null ) {
			return null;
		}
		return dao.getUserById(userId);
	}
	
	/** 
	 * @return instance if session is present in cache
	 */
	public User checkAutherization(String sessionId) {
		return cache.getElement(sessionId);
	}
	
	public boolean changePassword(String userId, String oldPass, String newPass) {
		return dao.changePassword(userId, DigestUtils.md5Hex(oldPass), DigestUtils.md5Hex(newPass));
	}
	
	public boolean changePassword(String userId, String newPass) {
		return dao.changePassword(userId, DigestUtils.md5Hex(newPass));
	}
	
	public PersonalSettings getPersonalSettings(String userId) {
		User user = cache.getElement(userId);
		return user != null && user.getSettings() != null ? user.getSettings() : personalSettings;
	}
	
	public void updatePersonalSettings(PersonalSettings accSettings, String userId) {
		dao.updateUserSettings(userId, accSettings);
		User user = cache.getElement(userId);
		user.setSettings(accSettings);
	}
	
	public User getUser(String userId) {
		return cache.getElement(userId);
	}
	
	public MailUser getUserByMail(String email) {
		return dao.getUserByMail(email);
	}
	
	public void pushNewTargetUser(String userId, String targetContact) {
		User cachedUser = cache.getElement(userId);
		
		if( !cachedUser.getLastRecipients().contains(targetContact) ) {
			User user = dao.getUserById(userId);
			user.getLastRecipients().add(targetContact);
			dao.save(user);
			cache.putElement(userId, user);
		}
	}

	private static PersonalSettings personalSettings = new PersonalSettings();
	static {
		personalSettings.setTheme("1");
	}
	
}
