package com.grocery.dao;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

import com.grocery.models.templates.CustomTemplate;

@Repository
public class CustomTemplateDao {
	private final static Logger log = LoggerFactory.getLogger(CustomTemplateDao.class);
	
	@Autowired
	private MongoTemplate mongoTemplate;
	
	public CustomTemplate getById(String templateId) {
		return mongoTemplate.findById(templateId, CustomTemplate.class);
	}
	
	public void addNewCustomTemplate(CustomTemplate t) {
		mongoTemplate.save(t);
	}
	
	public boolean removeCustomTemplate(String customTemplateId, String userId) {
		CustomTemplate findById = mongoTemplate.findById(customTemplateId, CustomTemplate.class);
		if(findById == null) return false;
		
		if(findById.getOwnerId().equals( userId )) {
			mongoTemplate.remove(findById);
		} else {
			log.warn("User {} tried to delete customTemplate {} owned by another user {}",
					new String[]{userId, customTemplateId, findById.getOwnerId()});
			throw new SecurityException("Unauthorissed action");
		}
		return true;
	}
	
	
	public List<CustomTemplate> getTempaltesByFamile(String[] familyMembersId) {
		List<CustomTemplate> templates = (List<CustomTemplate>) mongoTemplate.find(new Query(
				Criteria.where("ownerId").in( (Object[])familyMembersId )
			), CustomTemplate.class);
		if(templates == null) {
			return new ArrayList<CustomTemplate>(0);
		} else {
			return templates;
		}
	}
	
}
