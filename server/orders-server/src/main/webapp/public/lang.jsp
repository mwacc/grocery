<%@page import="java.util.Properties"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.grocery.filters.Cookies"%>

<%
   String language = null;
   String theme = "1";
   boolean isAuth = false;
   Cookie cookie = null;
   Cookie[] cookies = null;
   // Get an array of Cookies associated with this domain
   cookies = request.getCookies();
   if( cookies != null ){
      for (int i = 0; i < cookies.length; i++){
         cookie = cookies[i];
         if( Cookies.LANG_COOKIE.equals( cookie.getName() ) ) {
         	language = cookie.getValue();
         } else  if( Cookies.AUTH_COOKIE.equals( cookie.getName() ) ) {
        	isAuth = true; 
         } else if( Cookies.THEME_COOKIE.equals( cookie.getName() ) ) {
        	 theme = cookie.getValue();
         }
      }
  }
   
  if(language == null) {
	  // try to get language from request
	  Properties supportedLanguages = new Properties();
	  supportedLanguages.put("uk", "ru");
	  supportedLanguages.put("ru", "ru");
	  supportedLanguages.put("be", "ru");
	  supportedLanguages.put("kk", "ru"); // Kazakstan
	  supportedLanguages.put("ka", "ru"); // Georgian language
	  
	  Enumeration locales = request.getLocales();
	  while (locales.hasMoreElements()) {
	      Locale locale = (Locale) locales.nextElement();
	      Enumeration langPrefix = supportedLanguages.keys();
	      while( langPrefix.hasMoreElements() ) {
		      if ( locale.getLanguage().toLowerCase().startsWith( (String)langPrefix.nextElement() ) ) {
		    	  language = (String) supportedLanguages.get( locale.getLanguage() );
		          break;
		      }
	      }
	      if( language != null ) break;
	  }
  }
  
  if(language == null) {
	  language = "en";
  }
  
  // set request attributes 
  pageContext.setAttribute("language", language);
  pageContext.setAttribute("isAuth", isAuth);
  pageContext.setAttribute("schema", theme);
%>
<fmt:setLocale value="${language}" />
<fmt:setBundle basename="com.grocery.i18n.messages" />