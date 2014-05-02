package com.grocery.services;

import java.util.Locale;
import java.util.Properties;
import java.util.ResourceBundle;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.grocery.models.accounts.User;
import com.grocery.models.grocery.GroceryList;

@Service
public class MailService {
	
	private JavaMailSenderImpl sender;
	
	@Autowired
	private UsersService userService;
	
	private static final Logger log = LoggerFactory.getLogger(MailService.class);
	
	public MailService(){
		sender = new JavaMailSenderImpl();
		sender.setHost("smtpout.europe.secureserver.net");
		sender.setPort(465);
		sender.setProtocol("smtps");
		sender.setUsername("notify@grocering.me");
		sender.setPassword("pinokio777");
		Properties p = new Properties();
		p.setProperty("mail.smtps.auth", "true");
		sender.setJavaMailProperties(p);
	}
	
	public boolean sendGroceryList(String userId, GroceryList groceryList) {
		// TODO: use factory to get correct addresat (mail, twitter so on)
		User fromUser = userService.getUser(userId);
		String userName = fromUser.getUniqueName();
				
		User mailContact = userService.getUserByMail(groceryList.getTarget());
		if( mailContact != null && mailContact.getSettings() != null && 
				!mailContact.getSettings().isAllowMailing() ) return true;
		
		//Get the client's Locale
	    Locale locale = new Locale(groceryList.getLanguage().toLowerCase());
	    ResourceBundle bundle = ResourceBundle.getBundle(
	        "com.grocery.i18n.messages",locale);
	    MimeMessage mimeMessage = sender.createMimeMessage();
	    try {
			MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, false, "utf-8");
			helper.setFrom("notify@grocering.me");
			helper.setSubject( bundle.getString("grocerylist.mailsubject") );
			helper.setTo(groceryList.getTarget());
			mimeMessage.setContent(String.format(bundle.getString("grocerylist.mailcontent"), userName) +
					groceryList.toString(), "text/html; charset=utf-8");
			
			this.sender.send(mimeMessage);
		} catch (MessagingException e) {
			log.error("Can't sent grocery list to {}", groceryList.getTarget(), e);
			return false;
		}
	    
	    userService.pushNewTargetUser(userId, groceryList.getTarget());
		
		return true;
	}
	
	public boolean putEmailOnForgottenPassword(String toEmail, String guid, String toLocale) {
		//Get the client's Locale
	    Locale locale = new Locale(toLocale.toLowerCase());
	    ResourceBundle bundle = ResourceBundle.getBundle(
	        "com.grocery.i18n.messages",locale);
	    
		SimpleMailMessage msg = new SimpleMailMessage();
		msg.setFrom("notify@grocering.me");
		msg.setSubject( bundle.getString("restore.mailsubject") );
		msg.setTo(toEmail);
		msg.setText( String.format(bundle.getString("restore.mailcontent"), guid, guid) );
		
		try{
            this.sender.send(msg);
        }
        catch(MailException ex) {
            ex.printStackTrace();
            return false;
        }
		
		return true;
	}

}
