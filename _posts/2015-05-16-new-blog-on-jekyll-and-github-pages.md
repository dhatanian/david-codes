---
layout: post
title: New blog on Jekyll and Github pages
author: David Hatanian
---

I finally got tired of Blogger's very slow and overcomplicated interface, so when I bought the `hatanian.com` domain name I decided to also migrate to something lighter.

#Setting up

I wanted something that would accept markdown, display code nicely, accept git versioning. [Jekyll](http://jekyllrb.com) was a great fit, and since it works well on Github Pages, well I got hosting for free !

I won't explain how Jekyll and Github Pages work together, since Github has [a very clear](https://help.github.com/articles/using-jekyll-with-pages/) tutorial already.

By now, my new and empty Jekyll blog was hosted on `dhatanian.github.io` which is the default domain for Github Pages. I wanted it to be hosted on my new `hatanian.com` domain, so I first followed [Github's instructions on how to use a custom domain](https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/). Then it hit me : how will I add TLS, since this is not supported by Github Pages ?

Luckily Cloudflare has a [free plan](https://www.cloudflare.com/plans) that includes TLS (which they call SSL, weirdly). This was really a two-clicks setup, Cloudflare is perfectly integrated with Godaddy and in a few minutes I had a blog serving its (still empty) content over HTTPS. It is not perfect as the connection is only encrypted between the browser and Cloudflare, but not between Cloudflare and Github Pages. However it's good enough for a private blog !

It felt a bit strange to simply give Cloudflare access to my DNS settings on Godaddy and see that they were able to generate a certificate for my domain. Then again it's logical : a lot of certificate authorities check the domain ownership through the DNS entries.

#First tweaks

Anyway I now had a fresh new blog that I needed to fill in. I fixed up the default theme a little bit by jutifying the text by default and moving the navigation bar to the left of the screen.

Jekyll's default `index.html` is the list of blog posts. I don't think that's a great landing page and I prefer people to arrive on my latest post, so I used [this great hack by nimbupani](https://gist.github.com/nimbupani/1421828) to get it right :

<script src="https://gist.github.com/nimbupani/1421828.js"></script>

#Migrating Blogger's content

This was quite a piece of cake. Blogger allows you to export a XML file that contains all your blog posts and the associated comments (we'll talk about comments later).

I then used [Jekyll's Blogger import gem](http://import.jekyllrb.com/docs/blogger/), and it generated each blog post in html format, even keeping some code formatting.

The `<img>` tags where still linking to Blogger though, so I downloaded them manually (there were'nt so many) and put them on Github Pages along with the articles.

For some reason, Blogger set fixed `width` and `height` attributes for the images. This resulting in weird-looking image that were shrinked when viewed on small screens. Removing the `width` and `height` attributes from the `<img>` tags fixed the issue.

#Setting up a workflow

When I started working with images, I was faced with a problem : where do I put images associated with a given blog post ? I would prefer to store them next to the post, so I started creating dedicated folders for each post, with each time the html/md file along with the associated images. But Jekyll started to complain :

	Error:  invalid byte sequence in UTF8

Jekyll actually tries to process every file that is in the `_posts` folder, even ones that are clearly binaries. There is no way do define exclusions. The Jekyll documentation recommends that images and other assets be placed in a dedicated `assets` directory, but I did not want images from all my posts mixed together.

I eventually settled for an intermediate solution : each post will have an associated folder in the `assets` directory. My folder structure now looks like this :

	\david-codes
	|--\_posts
	|  |--- 2015-05-16-new-blog-on-jekyll-and-github-pages.md
	|
	|--\assets
	   |--\posts
	      |--\2015-05-16-new-blog-on-jekyll-and-github-pages.md
		     |--- image.png


It's not super convenient since images and posts are separated, but at least it's easy to find all the images for a given post.

Inside the post, a link to an image would look like this :

	<img src="assets/posts/2015-05-16-new-blog-on-jekyll-and-github-pages.md/image.png"/>


Which obviously is not really convenient to type and depends too much on the article's name. So I used a liquid tag :

{% raw %}
	<img src="/assets/{{ page.path | replace:'\_posts','posts' }}/image.png"/>
{% endraw %}


(ignore the `\` character which is here to fix [a very annoying issue in the atom editor](https://github.com/atom/language-gfm/issues/44))

I then created an atom snippet, that's a piece of code that I can generate quickly. The Cson configuration is like this :

	'.text.html, .source.gfm':
	  'jekyll.asset':
	    'prefix': 'img'
	    'body': '/assets/{% raw %}
{{ page.path | replace:\'\_posts\',\'posts\' }}{% endraw %}
/${1:image}.png$2'

Now when I type `img-TAB` the full liquid tag is automatically generated for me.

Finally, I wrote a quick shell script to create an article and the associated assets folder :

	title=$1
	slug=`echo $title | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g'`
	date_slug=`date +"%Y-%m-%d"`
	file="$date_slug-$slug.md"

	echo "Creating post $file"
	post_file="\_posts/$file"
	touch post_file
	mkdir assets/posts/$file
	echo "---" >> $post_file
	echo "layout: post" >> $post_file
	echo "title: $title" >> $post_file
	echo "author: David Hatanian" >> $post_file
	echo "---" >> $post_file
	echo "" >> $post_file

	atom $post_file

#Adding comments
Adding comments is absolutely trivial with [Disqus](https://disqus.com). This free service generates by default a comment thread per URL of your blog. You just have to insert some HTML and Javascript at the end of your page.

Because my posts can have several URLs (the latest post is also the root of the site), I slightly modified the Disqus initialization code to include a custom identifier, which is the post id extracted by a Liquide tag :

	<div id="disqus_thread"></div>
	<script type="text/javascript">

	var disqus_shortname = 'david-codes';
	var disqus_identifier = '{% raw %}{{ page.id }}{% endraw %}'; //Here's the trick

	(function() {
		var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
		dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
		(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
	})();
	</script>

Now I needed to import comments from Blogger to Disqus. Disqus has a very nice import system but it required comments in the `wxr` format (from Wordpress). Fortunately, a kind soul wrote a Google App Engine appengine [blogger2wordpress](https://blogger2wordpress.appspot.com/) service to convert the Blogger format to `wxr`.

The first import went well, but because the URLs had changed from Blogger to Github Pages, Disqus wouldn't load the old comment threads in my blog. I reuploaded the `wxr` after manually specifying the `disqus_identifier` on each thread :

	<item>
	  <title>How to provide seamless Single Sign On on Google Apps</title>
	  <link>http://david-codes.blogspot.com/2014/07/how-to-provide-seamless-single-sign-on.html</link>
	  <!-- Add this to identify the Disqus thread -->
	  <dsq:thread_identifier>/2014/07/03/how-to-provide-seamless-single-sign-on</dsq:thread_identifier>
	  <pubDate>Thu, 03 Jul 2014 04:18:00 -0700</pubDate>
	  <dc:creator>David Hatanian</dc:creator>

After that, I had a nice commenting interface, with my old comments loaded !

#Redirecting from Blogger to Github Pages

[This post by Suriya Prakash](http://blogtimenow.com/blogging/automatically-redirect-blogger-blog-another-blog-website/) explains well how to setup a redirection from Blogger.

I adapted it that way :

	<b:if cond='!data:mobile'>
	    <!-- posts -->
	    <div class='blog-posts hfeed'>

	      <b:include data='top' name='status-message'/>

	      <data:defaultAdStart/>
	      <b:loop values='data:posts' var='post'>
			<b:if cond='data:numPosts != 1'>
	          <script>location.href=&quot;https://david-codes.hatanian.com/allposts&quot;</script>
	        </b:if>
	       <script>
	           var d=&#39;<data:blog.url/>&#39;;
	           d=d.replace(/.*\/\/[^\/]*/, &#39;&#39;);
				var postPage = d.replace(/\/201[3-5]\/[0-1][0-9]\//,&#39;&#39;);
	           var timestamp=&#39;<data:post.timestampISO8601/>&#39;;
	         console.log(&quot;Post page : &quot;+postPage);
	         console.log(&quot;Timestamp : &quot;+timestamp);
			var dateUrl = timestamp.replace(/T.+/,&#39;&#39;).replace(/-/g,&#39;/&#39;);
	         var redirectUrl = &quot;https://david-codes.hatanian.com/&quot;+dateUrl+&quot;/&quot;+postPage;
			location.href = redirectUrl

			</script>

I also had to :
 * disable the mobile-specific theme
 * change my theme to the usual static one because otherwise it would always redirect to the latest post. Note : change the theme before inserting custom code.

One small issue was that the post files name were not exactly right after migration from Blogger. In Jekyll, a post starts with a date in `YYYY-mm-dd` format, for example this post is :

	2015-05-16-new-blog-on-jekyll-and-github-pages.md

This post has the following URL :

	2015/05/16/new-blog-on-jekyll-and-github-pages.md

But for some posts the date prefix was incorrect. For example the file name would be :

	2014-07-22-google-apis-checking-scopes-contained.html

But the URL would be off by one day :

	2014/07/21/google-apis-checking-scopes-contained.html

This was not on all posts. Because I mainly blogged from Vietnam and India, I guess this was a timezone issue. The solution was to remove the `date` header from the migrated articles :

	---
	layout: post
	title: '"Cloud Platform Orchestrator" - An App Engine/Compute Engine demo'
	date: '2014-05-06T05:05:00.004-07:00' --> REMOVE THIS
	author: David Hatanian
	tags:
	modified_time: '2014-05-06T05:05:55.659-07:00'
	thumbnail: http://4.bp.blogspot.com/--WuW40qT3vM/U2jQBN5c0lI/AAAAAAAAInU/BIKePHu2JTk/s72-c/createexecution.png
	blogger_id: tag:blogger.com,1999:blog-5219665179084602082.post-8680951713691172637
	blogger_orig_url: http://david-codes.blogspot.com/2014/05/cloud-platform-orchestrator-app.html
	---

#Conclusion#

That's all what is needed to move to Jekyll on Github pages ! The process was quite smooth, now I need to tweak a bit this default theme :-)
