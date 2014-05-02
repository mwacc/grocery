package com.grocery.dao;

import java.util.LinkedList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

import com.grocery.models.templates.GeneralTemplate;

@Repository
public class GeneralTemplatesDao {
	
	//private static final Logger log = LoggerFactory.getLogger(GeneralTemplatesDao.class);
		
	@Autowired
	private MongoTemplate mongoTemplate;
	

	public List<GeneralTemplate> getGeneralTemplatesByLang(String langCode) {
		List<GeneralTemplate> list = new LinkedList<GeneralTemplate>();
		
		List<GeneralTemplate> qResult = mongoTemplate.find(new Query(Criteria.where("lang").is(langCode)), 
				GeneralTemplate.class);
		if( qResult != null ) {
			list.addAll(qResult);
		}
		return list;
	}
	
	public GeneralTemplate getGeneralTemplatesById(String id) {
		return mongoTemplate.findById(id, GeneralTemplate.class);
	}
	
	
}
