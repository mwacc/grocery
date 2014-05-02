package com.grocery.controllers;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.grocery.dao.GeneralTemplatesDao;
import com.grocery.models.templates.GeneralTemplate;

@Controller
@RequestMapping("/s/templates/general")
public class GeneralTemplatesController extends BasicController {

	private static final Logger log = LoggerFactory.getLogger(GeneralTemplatesController.class);
	
	@Autowired
	private GeneralTemplatesDao generalTemplatesDao;
	
	@RequestMapping(value = "/{lang}", method = RequestMethod.GET)
    public @ResponseBody List<GeneralTemplate> getGeneralTemplates(@PathVariable String lang,
    		HttpServletRequest request, HttpServletResponse response) {
		log.info("Request general template by lang {}", lang);
		return generalTemplatesDao.getGeneralTemplatesByLang(lang.toUpperCase());
	}
	
	@RequestMapping(value = "/g/{id}", method = RequestMethod.GET)
    public @ResponseBody GeneralTemplate getGeneralTemplateById(@PathVariable String id,
    		HttpServletRequest request, HttpServletResponse response) {
		log.info("Request general template by id {}", id);
		GeneralTemplate generalTemplates = generalTemplatesDao.getGeneralTemplatesById(id);
		if( generalTemplates != null ) {
			return generalTemplates; 
		} else {
			response.setStatus(HttpServletResponse.SC_NO_CONTENT);
			return null;
		}
	}
	
}
