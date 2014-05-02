package com.grocery.statistic.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.grocery.statistic.RestPerformanceMonitor;

@Component
@Aspect
public class PerformanceHijackAroundMethod {
	
	private static final Logger performanceMonitor = LoggerFactory.getLogger(RestPerformanceMonitor.class);

	 
	@Around("execution(public * com.grocery.controllers.UsersController*.*(..))")
	public Object invoke(ProceedingJoinPoint joinPoint) throws Throwable {
		long startAt = System.currentTimeMillis();
		try {
			// proceed to original method call
			Object result = joinPoint.proceed();
			return result;
		} finally {
			long endAt = System.currentTimeMillis();
			performanceMonitor.info(String.format("%s,%s", joinPoint.getSignature().getName(), (endAt - startAt)));
		}
	}

}
