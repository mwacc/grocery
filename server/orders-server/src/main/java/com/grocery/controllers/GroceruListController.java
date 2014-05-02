package com.grocery.controllers;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.grocery.models.accounts.User;
import com.grocery.models.grocery.GroceryList;
import com.grocery.services.MailService;
import com.grocery.services.UsersService;
import com.grocery.statistic.GoodsListLogger;

@Controller
@RequestMapping("/s/grocery")
public class GroceruListController extends BasicController {
	
	private static final Logger logGrocery = LoggerFactory.getLogger(GoodsListLogger.class);

	@Autowired
	private UsersService userService;
	
	@Autowired
	private MailService mailService;
	
	@RequestMapping(method = RequestMethod.POST)
    public void createGroceryList(@RequestBody GroceryList groceryList, HttpServletRequest request, HttpServletResponse response) {
		
		if( !StringUtils.hasText( groceryList.getTarget() ) ) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		GroceryList normalized = groceryList.normalizeStructure();
		
		String userId = ControllerUtil.getUserIdFromRequest(request);
		
		if( mailService.sendGroceryList(userId, normalized) ) {
			logGrocery.info( normalized.getFlatGoods() );
			response.setStatus(HttpServletResponse.SC_OK);
		} else {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}
	
	@RequestMapping(value="/lasttargets", method = RequestMethod.GET)
	public @ResponseBody List<String> getTargetUsers(HttpServletRequest request, HttpServletResponse response) {
		String userId = ControllerUtil.getUserIdFromRequest(request);
		
		User fromUser = userService.getUser(userId);
		return fromUser.getLastRecipients();
	}
	
}
