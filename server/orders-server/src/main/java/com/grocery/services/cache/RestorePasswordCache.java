package com.grocery.services.cache;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import com.hazelcast.config.Config;
import com.hazelcast.config.MapConfig;
import com.hazelcast.core.Hazelcast;
import com.hazelcast.core.HazelcastInstance;

@Service
@Scope("singleton")
// save guid -> userid
public class RestorePasswordCache implements ICacheService<String> {
	
	private HazelcastInstance c;
	private static final String restorePass = "restore";
	
	private static final int TTL = 60*60*2; // 2 hours
	
	public RestorePasswordCache() {
		Config cfg = new Config();
		MapConfig mapConfig = new MapConfig(restorePass);
		mapConfig.setMaxIdleSeconds( TTL );
		mapConfig.setBackupCount(0);
		cfg.addMapConfig(mapConfig);
		c = Hazelcast.newHazelcastInstance(cfg);
	}
	
	@Override
	public void putElement(String key, String value, int ttl) {
		throw new UnsupportedOperationException();
	}

	@Override
	public void putElement(String key, String value) {
		c.getMap(restorePass).put(key, value);
	}

	@Override
	public String getElement(String key) {
		return (String) c.getMap(restorePass).get(key);
	}

	@Override
	public void updateTtl(String key) {
		throw new UnsupportedOperationException();
	}

	@Override
	public void remove(String key) {
		c.getMap(restorePass).remove(key);
	}

	

}
