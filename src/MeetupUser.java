package MeetupNow;

import com.google.appengine.api.datastore.Key;

import org.scribe.oauth.Token;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable
public class MeetupUser {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Key key;

	@Persistent
	private String reqToken;

	@Persistent
	private String reqTokenSecret;

	public MeetupUser() {
		reqToken = null;
		reqTokenSecret = null;
	}

   	public Key getKey() {
    	    	return key;
    	}

	public String getReqToken() {
		return reqToken;
	}

	public String getReqTokenSecret() {
		return reqTokenSecret;
	}

	public void setReqToken(String r) {
		reqToken = r;
	}

	public void setReqTokenSecret(String a) {
		reqTokenSecret = a;
	}

}
