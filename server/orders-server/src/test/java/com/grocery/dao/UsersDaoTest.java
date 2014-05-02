package com.grocery.dao;

import java.util.List;

import junit.framework.Assert;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.grocery.dao.logic.TemplatesCreator;
import com.grocery.models.accounts.User;
import com.grocery.models.templates.CustomTemplate;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/spring-test.xml"})
public class UsersDaoTest {
	
	@Autowired
    private MongoTemplate mongoTemplate;
	
	@Autowired
	private UsersDao dao;
	
	private String tmpUserId = null;
	
	@Before
	public void setUp() {
		User user = new User();
		user.setEmail("e@e.com");
		user.setLang("EN");
		
		user.setGoodsGroups( TemplatesCreator.getCustomTemplates() );
		
		mongoTemplate.save(user);
		tmpUserId = user.getId();
	}
	
	@After
	public void tearDown() {
		if( tmpUserId != null )
			mongoTemplate.remove( mongoTemplate.findById(tmpUserId, User.class) );
	}

	@Test
	public void addNewCustomTemplate() {
		User user = mongoTemplate.findById(tmpUserId, User.class);
		int prevSize = user.getTemplates().size();
		
		CustomTemplate customTemplate = TemplatesCreator.getCustomTemplate();
	    dao.addNewCustomTemplate(tmpUserId, customTemplate);
	    
	    user = mongoTemplate.findById(tmpUserId, User.class);
	    List<CustomTemplate> templates = user.getTemplates();
	    
	    Assert.assertEquals(prevSize+1, templates.size());
	}
	
	@Test
	public void checkUserAuth() {
	    throw new RuntimeException("Test not implemented");
	}
	
	@Test
	public void getUserById() {
	    User u = dao.getUserById(tmpUserId);
	    Assert.assertEquals("e@e.com", u.getEmail());
	}
	
	@Test
	public void registerNewUser() {
	    throw new RuntimeException("Test not implemented");
	}
	
	@Test
	public void removeCustomTemplate() {
		User user = mongoTemplate.findById(tmpUserId, User.class);
		int prevSize = user.getTemplates().size();
		CustomTemplate customTemplate = user.getTemplates().get(0);
		Assert.assertNotNull(customTemplate.getId());
	    dao.removeCustomTemplate(tmpUserId, customTemplate.getId());
	    
	    user = mongoTemplate.findById(tmpUserId, User.class);
	    Assert.assertEquals(prevSize-1, user.getTemplates().size());
	}
	
	@Test
	public void updateCustomTemplate() {
		User user = mongoTemplate.findById(tmpUserId, User.class);
		int prevSize = user.getTemplates().size();
		
		CustomTemplate customTemplate = user.getTemplates().get(0);
		String id = customTemplate.getId();
		customTemplate.setName("NEW_NAME");
		
	    dao.updateCustomTemplate(tmpUserId, customTemplate);
	    
	    user = mongoTemplate.findById(tmpUserId, User.class);
	    
	    Assert.assertEquals(prevSize, user.getTemplates().size());
	    for(CustomTemplate ct : user.getTemplates()) {
	    	if( id.equals(ct.getId()) ) {
	    		Assert.assertEquals("NEW_NAME", ct.getName());
	    	}
	    }
	}
}
