package com.grocery.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

import com.grocery.models.accounts.MailUser;
import com.grocery.models.accounts.PersonalSettings;
import com.grocery.models.accounts.User;
import com.grocery.models.accounts.UserTypes;

@Repository
public class UsersDao {

	//private final static Logger log = LoggerFactory.getLogger(UsersDao.class);
	
	@Autowired
    private MongoTemplate mongoTemplate;
	
	public void registerNewUser(User newUser) {
		// TODO: spare index on email
		
	}
	
	public User checkUserAuth(String name, String password) {
		List<User> users = (List<User>) mongoTemplate.find(new Query(
				Criteria.
					where("email").is(name).
					and("password").is(password).
					and("type").is(UserTypes.EMAIL.getType())
			), User.class);
		
		if( users == null || users.size() != 1 ) {
			return null;
		} else {
			return users.get(0);
		}
	}
	
	public User getUserById(String id) {
		return mongoTemplate.findById(id, User.class);
	}
	
	public MailUser getUserByMail(String email) {
		List<MailUser> users = (List<MailUser>) mongoTemplate.find(new Query(
				Criteria.
					where("email").is(email).
					and("type").is(UserTypes.EMAIL.getType())
			), MailUser.class);
		
		if( users == null || users.size() != 1 ) {
			return null;
		} else {
			return users.get(0);
		}
	}
	
	public void save(User user) {
		mongoTemplate.save(user);
	}
	
	public boolean changePassword(String userId, String oldPass, String newPass) {
		List<User> users = (List<User>) mongoTemplate.find(new Query(
				Criteria.
					where("_id").is(userId).
					and("password").is(oldPass).
					and("type").is(UserTypes.EMAIL.getType())
			), User.class);
		
		if( users == null || users.size() != 1 ) {
			return false;
		} else {
			MailUser user = (MailUser) users.get(0);
			user.setPassword(newPass);
			mongoTemplate.save(user);
			return true;
		}
		
	}
	
	public boolean changePassword(String userId, String newPass) {
		List<User> users = (List<User>) mongoTemplate.find(new Query(
				Criteria.
					where("_id").is(userId).
					and("type").is(UserTypes.EMAIL.getType())
			), User.class);
		
		if( users == null || users.size() != 1 ) {
			return false;
		} else {
			MailUser user = (MailUser) users.get(0);
			user.setPassword(newPass);
			mongoTemplate.save(user);
			return true;
		}
		
	}
	
	public boolean updateUserSettings(String userId, PersonalSettings accSettings) {
		User user = mongoTemplate.findById(userId, User.class);
		user.setSettings(accSettings);
		mongoTemplate.save(user);
		return true;
	}
}
