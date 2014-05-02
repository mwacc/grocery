package com.grocery.dao;

import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.testng.Assert;

import com.grocery.dao.logic.TemplatesCreator;
import com.grocery.models.templates.GeneralTemplate;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/spring-test.xml"})
public class GeneralTemplatesDaoTest {
	
	@Autowired
	private GeneralTemplatesDao dao;

	@Autowired
    private MongoTemplate mongoTemplate;
	
	private List<String> tmpIds = new ArrayList<String>();
	
	@Before
	public void setUp() {
		for( GeneralTemplate t : TemplatesCreator.getGeneralTemplate() ) {
			mongoTemplate.save(t);
			tmpIds.add(t.getId());
		}
		
	}
	
	@After
	public void tearDown() {
		for( String id : tmpIds ) {
			mongoTemplate.remove( mongoTemplate.findById(id, GeneralTemplate.class) );
		}
	}
	
	@Test
	public void getGeneralTemplatesByLangSuccess() {
		List<GeneralTemplate> templates = dao.getGeneralTemplatesByLang("EN");
		Assert.assertNotNull(templates);
		Assert.assertEquals(templates.size(), 1);
		
		Assert.assertEquals(templates.get(0).getName(), "name1");
		
		Assert.assertEquals(templates.get(0).getItems().size(), 1);
		
		Assert.assertEquals(templates.get(0).getItems().get(0).getItems().get(0), "Salmon");
	}
	
	@Test
	public void getGeneralTemplatesByLangUnSuccess() {
		List<GeneralTemplate> templates = dao.getGeneralTemplatesByLang("GB");
		Assert.assertNotNull(templates);
		Assert.assertEquals(templates.size(), 0);
	}
}
