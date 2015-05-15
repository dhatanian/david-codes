---
layout: post
title: 'OpenAM and Kerberos authentication : how to provide a fallback for devices
who do not have Kerberos enabled ?'
date: '2014-12-12T01:39:00.000-08:00'
author: David Hatanian
tags:
- windowsdesktopsso
- openam
- kerberos
modified_time: '2014-12-12T01:39:23.026-08:00'
thumbnail: http://2.bp.blogspot.com/-vs-iRQI7rxE/VIqxi6RSoDI/AAAAAAAALW8/Fzu2l9Z4pjI/s72-c/2014-12-12_16-12-14.png
blogger_id: tag:blogger.com,1999:blog-5219665179084602082.post-186362447455906515
blogger_orig_url: http://david-codes.blogspot.com/2014/12/openam-and-kerberos-authentication-how.html
---

<div style="text-align: justify;">OpenAM is very commonly used with the Kerberos and SPNEGO protocols to provide
    seamless authentication inside a company's network.
</div>
<div style="text-align: justify;">
</div>
<div style="text-align: justify;">Those are the protocols used by OpenAM's Windows Desktop SSO module. It is extremely
    convenient : no need to input a password, you are automatically logged in.
</div>
<div style="text-align: justify;">
</div>
<div style="text-align: justify;">When we deployed Kerberos, we usually face an issue with devices not configured for
    Kerberos authentication : phones, tablets, macbooks or Windows computers that were not configured by the company's
    administrators. Those users would see an "HTTP 401" error when attempting to authenticate to Kerberos.
</div>
<div style="text-align: justify;">
</div>
<div style="text-align: justify;">If you did not change your default error page, it would look like this on Apache
    Tomcat :
</div>
<div style="text-align: justify;">
</div>
<div class="separator" style="clear: both; text-align: center;"><a
        href="/assets/{{ page.path | replace:'_posts','posts' }}/tomcat_401.png"
        imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0"
                                                                          src="/assets/{{ page.path | replace:'_posts','posts' }}/tomcat_401.png"
                                                                          height="328" width="640"/></a></div>
<div style="text-align: justify;">
</div>
<div style="text-align: justify;">The usual workaround is to edit the default 401 error page to redirect the user to a
    different authentication solution.
</div>
<div style="text-align: justify;">
</div>
<div style="text-align: justify;">The problem with this method is that the user's original request is lost : OpenAM will
    not know anymore what application the user wanted to access. The usual solution is either to redirect the user
    arbitrarily to the most commonly used application, or to display a list of applications for the user to choose from.
</div>
<div style="text-align: justify;">
</div>
<div style="text-align: justify;">We came around a better way to do this, without losing the user's original request.
    Here is how it works :
</div>
<div style="text-align: justify;"></div>
<ul>
    <li>When the user fails the Kerberos authentication, a custom 401 page is displayed to the user. This 401 page sends
        the user back to the page he was trying to access (the login form), but with an additional request in the query
        string.
    </li>
    <li>When the user hits this page, he is redirected to <i>https://sso.company.com/UI/Login?.....&<b>ignoreHttpCallback=true </b>.
    </i>The last parameter is added by the custom 401 page.
    </li>
    <li>A custom filter added in OpenAM's <i>web.xml</i>&nbsp;detected the <i>ignoreHttpCallback</i>&nbsp;parameter and
        injects a fake <i>Authorization</i>&nbsp;header into the request, to make OpenAM believe that the client is
        trying to use Kerberos
    </li>
    <li>With this, the Windows Desktop SSO module is started, and its authentication fails. If you have another module
        in the authentication chain (typically an Active Directory module), it will be used instead of the Windows
        Desktop SSO module.
    </li>
</ul>
<div>Note that for this workaround to work, you must use an authentication chain containing the Windows Desktop SSO
    module (in level SUFFICIENT) and another fallback module, such as Active Directory, also in level SUFFICIENT.
</div>
<div>
</div>
<a
        href="/assets/{{ page.path | replace:'_posts','posts' }}/modules.png"
        imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0"
                                                                          src="/assets/{{ page.path | replace:'_posts','posts' }}/modules.png">

Here is the code of a simple custom 401 error page :


{% highlight java %}
<%@ page language="java" isErrorPage="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String redirectURL = null;
    try {
        redirectURL = request.getAttribute("javax.servlet.forward.request_uri") + "?" + request.getAttribute("javax.servlet.forward.query_string") +
                "&ignoreHttpCallback=true";
    } catch (Exception e) {
        throw new RuntimeException("Unable to generate target URL", e);
    }
    if(!response.containsHeader("WWW-Authenticate")){
        response.addHeader("WWW-Authenticate", "Negotiate");
    }
%>
<html>
<head>
    <meta http-equiv="refresh" content="1; <%=redirectURL%>"/>
</head>
<body>
<h1>Error during transparent authentication.</h1>
<p>You will be automatically redirected to the login/password fallback.</p>
<p>If the redirection does not happen, please <a href="<%=redirectURL%>">click here for manual redirection</a>.</p>
</body>
</html>
{% endhighlight java %}


And here is the code of the HttpFilter we use to simulate a Kerberos ticket, based on the
<i>ignoreHttpCallback </i>parameter :



<pre class="prettyprint linenums lang-java">
public class KerberosFallbackFilter implements Filter {
	private static final String IGNORE_PARAMETER = &quot;ignoreHttpCallback&quot;;

	@Override
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
          if (request.getParameter(IGNORE_PARAMETER) != null) {
            request = new AuthorisationHeaderEnhancedRequest((HttpServletRequest) request);
          }
		chain.doFilter(request, response);
	}

	public class AuthorisationHeaderEnhancedRequest extends HttpServletRequestWrapper {
		private static final String AUTHORIZATION_HEADER = &quot;Authorization&quot;;
		private static final String FAKE_HEADER = &quot;Negotiate FAKE_HEADER&quot;;

		public AuthorisationHeaderEnhancedRequest(HttpServletRequest req) {
			super(req);
		}

		@Override
		public String getHeader(String key) {
			if (key != null && key.trim().equalsIgnoreCase(AUTHORIZATION_HEADER)) {
				return FAKE_HEADER;
			} else {
				return super.getHeader(key);
			}
		}
	}
}
</pre>
