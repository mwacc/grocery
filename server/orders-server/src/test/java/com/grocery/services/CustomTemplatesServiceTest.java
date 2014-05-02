package com.grocery.services;

import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.testng.annotations.Test;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
        locations = {"classpath:/log-parsing-env-test.xml", "classpath*:/log-transfering.xml"},
        inheritLocations = true)
public class CustomTemplatesServiceTest {

  @Test
  public void createCustomTemplate() {
	  
    throw new RuntimeException("Test not implemented");
  }

  @Test
  public void deleteCustomTemplate() {
    throw new RuntimeException("Test not implemented");
  }

  @Test
  public void getCustomTemplatesByUser() {
    throw new RuntimeException("Test not implemented");
  }
}
