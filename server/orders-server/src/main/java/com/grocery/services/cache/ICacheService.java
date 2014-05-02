package com.grocery.services.cache;

public interface ICacheService <T> {

	public void putElement(String key, T value, int ttl);
	
	public void putElement(String key, T value);
	
	public T getElement(String key);
	
	public void updateTtl(String key);
	
	public void remove(String key);
}
