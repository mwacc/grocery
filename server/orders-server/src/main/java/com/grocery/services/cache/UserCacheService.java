package com.grocery.services.cache;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import com.grocery.filters.Cookies;
import com.grocery.models.accounts.User;
import com.hazelcast.config.Config;
import com.hazelcast.config.MapConfig;
import com.hazelcast.core.Hazelcast;
import com.hazelcast.core.HazelcastInstance;

@Service
@Scope("singleton")
//@PropertySource("classpath:/app.properties")
public class UserCacheService implements ICacheService<User> {
	
	private static final Logger log = LoggerFactory.getLogger(UserCacheService.class);
	private static final String userPrefix = "users";
	
	//@Value("${memcache.host.port}")
	//private String memcacheHostPort = "127.0.0.1:11211";
	
	private HazelcastInstance c;
	
	
	public UserCacheService() {
		Config cfg = new Config();
		MapConfig mapConfig = new MapConfig(userPrefix);
		mapConfig.setMaxIdleSeconds(Cookies.AUTH_COOKIE_TTL_SECONDS);
		mapConfig.setBackupCount(0);
		cfg.addMapConfig(mapConfig);
		c = Hazelcast.newHazelcastInstance(cfg);
	}

	@Override
	public void putElement(String key, User value, int ttl) {
		c.getMap(userPrefix).put(key, value);
	}

	@Override
	public void putElement(String key, User value) {
		c.getMap(userPrefix).put(key, value);
	}

	@Override
	public User getElement(String key) {
		return (User) c.getMap(userPrefix).get(key);
	}

	@Override
	public void updateTtl(String key) {
		throw new UnsupportedOperationException();
	}

	@Override
	public void remove(String key) {
		c.getMap(userPrefix).remove(key);
	}

}
