package com.grocery.controllers;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ExceptionHandler;

public class BasicController {
	
	private static final Logger log = LoggerFactory.getLogger(BasicController.class);

	@ExceptionHandler(Throwable.class)
	public void handleApplicationExceptions(Throwable exception, HttpServletResponse response) throws IOException {
		log.error("Exception on processing web method" , exception);
		exception.printStackTrace();
		response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	}
	
}
