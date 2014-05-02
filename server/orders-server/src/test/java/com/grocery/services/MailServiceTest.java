package com.grocery.services;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.grocery.models.grocery.GroceryList;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/spring-test.xml"})
public class MailServiceTest {
	
	@Autowired
	private MailService service;
	
	@Test
	public void sendMail() {
		GroceryList gl = new GroceryList();
		gl.setLanguage("RU");
		gl.setTarget("inte@list.ru");
		
		service.sendGroceryList( "test user", gl );
	}

}
