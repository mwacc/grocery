package com.grocery.controllers;

import java.util.List;

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

import com.grocery.models.templates.CustomTemplate;
import com.grocery.models.templates.Template;
import com.grocery.services.CustomTemplateService;

@Controller
@RequestMapping("/s/templates/custom")
public class CustomTemplatesController extends BasicController {

	private static final Logger log = LoggerFactory.getLogger(CustomTemplatesController.class);
	
	@Autowired
	private CustomTemplateService customTemplatesService;

	
	@RequestMapping(method = RequestMethod.POST)
    public void createCustomTemplate(@RequestBody CustomTemplate customTemplate, 
    		HttpServletRequest request, HttpServletResponse response) {
		String userId = ControllerUtil.getUserIdFromRequest(request);
		log.info("Request to create custom template {} with owner id {}", customTemplate, userId);
		
		int status = customTemplatesService.createCustomTemplate(userId, customTemplate.normalizeStructure());
		if( status != -1 ) {
			response.setStatus(HttpServletResponse.SC_CREATED);
		} else {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}
	
	@RequestMapping(value = "/{lang}", method = RequestMethod.GET)
	public @ResponseBody List<Template> getAvailableTemplates(@PathVariable String lang,
    		HttpServletRequest request, HttpServletResponse response) {
		String userId = ControllerUtil.getUserIdFromRequest(request);
		log.info("Get all templates for user {} with lang {}", userId, lang);
		
		return customTemplatesService.getAvailableTemplates(lang, userId);
	}
	
	@RequestMapping(value = "/g/{id}", method = RequestMethod.GET)
    public @ResponseBody Template getTemplateById(@PathVariable String id,
    		HttpServletRequest request, HttpServletResponse response) {
		String userId = ControllerUtil.getUserIdFromRequest(request);
		log.info("Request template id {} by user {}", id, userId);
		Template template = customTemplatesService.getTemplateById(id, userId);
		
		if( template != null ) {
			return template; 
		} else {
			response.setStatus(HttpServletResponse.SC_NO_CONTENT);
			return null;
		}
	}
	
	@RequestMapping(value = "/{templateId}", method = RequestMethod.DELETE)
	public void deleteCustomTemplateById(@PathVariable String templateId, HttpServletRequest request, HttpServletResponse response) {
		String userId = ControllerUtil.getUserIdFromRequest(request);
		templateId = templateId.substring(1);
		log.info("User userId {} removes custom templates by templateId {}", userId, templateId);
		if( customTemplatesService.removeCustomTemplate(userId, templateId) ) {
			response.setStatus(HttpServletResponse.SC_ACCEPTED);
		} else {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
		}
	}
	
	
}
