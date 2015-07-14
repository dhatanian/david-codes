---
layout: post
title: Using HTTP sessions with Google Cloud Endpoints
author: David Hatanian
---

I like how easy [Google Cloud Endpoints](https://cloud.google.com/appengine/docs/java/endpoints/) makes it to create a REST API on Google App Engine. Granted, there are other solutions in the Java world (I also used RestX and Spring) but I still like the simplicity of Google Cloud Endpoints.

However, one problem with Cloud Endpoints is the authentication : by default it only supports Google's OAuth2 authentication protocol. Because my application uses sessions for other purposes, I wanted to authenticate the user based on his session. Endpoints authentication is actually extensible through an almost undocumented class called [Authenticator](https://cloud.google.com/appengine/docs/java/endpoints/javadoc/com/google/api/server/spi/config/Authenticator).

{% highlight java %}
public interface Authenticator {
  User authenticate(HttpServletRequest request);
}
{% endhighlight %}


Another issue is that this authenticator does not have access to the session either... The Endpoints infrastructure strips off the cookies and session information before injecting the `HttpServletRequest` in `Authenticator.authenticate()`.

The solution I found is to send the session id in a header. In App Engine, sessions are stored in memcache and the datastore, so I can extract those sessions easily. Here's how it works :

{% highlight java %}
public class OAuth2EndpointsAuthenticator implements Authenticator {
    private static final Logger log = Logger.getLogger(OAuth2EndpointsAuthenticator.class.getName());
    private DatastoreService datastoreService = DatastoreServiceFactory.getDatastoreService();
    private MemcacheService memcacheService = MemcacheServiceFactory.getMemcacheService();

    @Override
    public User authenticate(HttpServletRequest httpServletRequest) {
        HttpSession session = httpServletRequest.getSession(false);
        if (session == null) {
            String jSessionId = httpServletRequest.getHeader("X-MYAPP-JSESSIONID");
            if (jSessionId == null) {
                return null;
            }
            MyAppUser user = getUserFromSessionInDatastore(jSessionId);
            return toEndpointsUser(user);
        } else {
            Object user = session.getAttribute(OAuth2UserService.USER_SESSION_PROPERTY);
            if (user != null && user instanceof MyAppUser) {
                return toEndpointsUser((MyAppUser) user);
            } else {
                return null;
            }
        }
    }

    private MyAppUser getUserFromSessionInDatastore(String jSessionId) {
        String entityId = "_ahs" + jSessionId;
        String memcacheId = "cacheduser/" + entityId;
        SessionDataInMemcache sessionDataInMemcache = (SessionDataInMemcache) memcacheService.get(memcacheId);
        if (sessionDataInMemcache == null || sessionDataInMemcache.isExpired()) {
            Entity session;
            try {
                session = datastoreService.get(KeyFactory.createKey("_ah_SESSION", entityId));
            } catch (EntityNotFoundException e) {
                return null;
            }
            Long expires = (Long) session.getProperty("_expires");
            if (expires < System.currentTimeMillis()) {
                return null;
            }
            Blob values = (Blob) session.getProperty("_values");
            Map valuesMap;
            try (ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(values.getBytes())) {
                try (ObjectInputStream objectInputStream = new ObjectInputStream(byteArrayInputStream)) {
                    valuesMap = (Map) objectInputStream.readObject();
                } catch (ClassNotFoundException e) {
                    throw new RuntimeException(e);
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            MyAppUser user = (MyAppUser) valuesMap.get(OAuth2UserService.USER_SESSION_PROPERTY);
            sessionDataInMemcache = new SessionDataInMemcache();
            sessionDataInMemcache.setExpirationTime(expires);
            sessionDataInMemcache.setUser(user);
            memcacheService.put(memcacheId, sessionDataInMemcache);
            return user;
        } else {
            return sessionDataInMemcache.getUser();
        }
    }

    public static class EndpointUser extends User {

        public EndpointUser(String email) {
            super(email);
        }

		//You can put here additional attributes if you wish to

    }

	private User toEndpointsUser(MyAppUser currentUser) {
        if (currentUser == null) {
            return null;
        }
        EndpointUser user = new EndpointUser(currentUser.getEmail());
        //If you have extra attributes in your session, put them here
        return user;
    }

	public static class SessionDataInMemcache implements Serializable {
	    private User user;
	    private long expirationTime;

	    public User getUser() {
	        return user;
	    }

	    public void setUser(User user) {
	        this.user = user;
	    }

	    public long getExpirationTime() {
	        return expirationTime;
	    }

	    public void setExpirationTime(long expirationTime) {
	        this.expirationTime = expirationTime;
	    }

	    public boolean isExpired() {
	        return expirationTime <= System.currentTimeMillis();
	    }
	}
}
{% endhighlight %}

In this code, the `Authenticator` gets the session id from the `X-MYAPP-JSESSIONID` HTTP header. It then tries to fetch and deserialize the session info from memcache. If this fails, the session is retrieved from the datastore.

**Important** : this only works correctly if you invalidate the session when the user logs out and then logs back in. If one given session can be associated with more than one `MyAppUser`, or if the `MyAppUser` object changes during the session's life (for example if you update attributes) then the `SessionDataInMemcache` object will be out of sync. This was not a problem for my application.

Then all I need to do is configure jQuery to include the session ID as a header when it makes AJAX calls, here's how it's done :

{% highlight javascript %}
var sessionId = Cookies.get('JSESSIONID');
$.ajaxSetup({headers: {"X-MYAPP-JSESSIONID": sessionId}})
{% endhighlight %}

The `Cookies` class here is provided by a small [Cookies.js](https://github.com/ScottHamper/Cookies) library.

All we have to do now is to configure our Cloud Endpoints API. Note the `authenticators` parameter on the `@Api` annotation.

{% highlight java %}
@Api(name = "myapi", version = "v1", authenticators = {OAuth2EndpointsAuthenticator.class})
public class LandingPage {
    @ApiMethod
    public HelloMessage sayHello(User endpointUser) throws ForbiddenException {
        OAuth2EndpointsAuthenticator.EndpointUser user = checkUser(endpointUser);
        return new HelloMessage("Hello, "+user.getEmail());
    }

    private OAuth2EndpointsAuthenticator.EndpointUser checkUser(User endpointUser) throws ForbiddenException {
        if (endpointUser == null) {
            throw new ForbiddenException("User must be authenticated");
        }
        if (!(endpointUser instanceof OAuth2EndpointsAuthenticator.EndpointUser)) {
            throw new ForbiddenException("Expected user with opco information");
        }
        return (OAuth2EndpointsAuthenticator.EndpointUser) endpointUser;
    }
}
{% endhighlight %}

That's it ! We are now ready to roll with a Google Cloud Endpoints service protected by Java's standard HTTP sessions.
