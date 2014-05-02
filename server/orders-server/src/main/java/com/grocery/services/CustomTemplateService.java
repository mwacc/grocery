package com.grocery.services;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.grocery.dao.CustomTemplateDao;
import com.grocery.dao.GeneralTemplatesDao;
import com.grocery.models.templates.CustomTemplate;
import com.grocery.models.templates.GeneralTemplate;
import com.grocery.models.templates.Template;

@Service
public class CustomTemplateService {
	
	@Autowired
	private CustomTemplateDao dao;
	
	@Autowired
	private GeneralTemplatesDao generalTemplatesDao;
	
	public int createCustomTemplate(String userId, CustomTemplate template) {
		template.setOwnerId(userId);
		dao.addNewCustomTemplate(template);
		return 1;
	}

	public boolean removeCustomTemplate(String userId, String templateId) {
		return dao.removeCustomTemplate(templateId, userId);
	}
	
	public List<Template> getAvailableTemplates(String lang, String userId) {
		List<Template> list = new ArrayList<Template>(10);
		
		// TODO: get from family members too
		// family member -> family master, family master -> [family member1, famile member2, ...]
		list.addAll( dao.getTempaltesByFamile(new String[]{userId}) );
		
		for(GeneralTemplate gt : generalTemplatesDao.getGeneralTemplatesByLang(lang.toUpperCase())) {
			list.add(gt);
		}
		
		return list;
	}
	
	public Template getTemplateById(String id, String userId) {
		Template template = null;
		String uid = id.substring(1);
		if(id.startsWith("G")) {
			template = generalTemplatesDao.getGeneralTemplatesById(uid);
		} else if (id.startsWith("C")) {
			template = dao.getById(uid);
		}
		
		return template;
	}
}
