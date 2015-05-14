---
layout: post
title: Cloud computing and the tragedy of the commons
date: '2014-09-20T01:48:00.001-07:00'
author: David Hatanian
tags:
modified_time: '2014-11-24T21:52:11.863-08:00'
blogger_id: tag:blogger.com,1999:blog-5219665179084602082.post-5896971818955184810
blogger_orig_url: http://david-codes.blogspot.com/2014/09/cloud-computing-and-tragedy-of-commons.html
---

It occurred recently to me that Cloud Computing is extremely exposed to an interesting
    manifestation of the <a href="http://en.wikipedia.org/wiki/Tragedy_of_the_commons">tragedy of the commons</a>.

##Whazzat ?##

The tragedy of the commons describes a situation where several parties share a limited
    resource and, by acting according to their self-interest, actually behave contrary to the whole group's best
    interest. Traditional examples of the tragedy in the commons include people littering in the street, and more
    generally any misuse of a public good.

When you subscribe to an IAAS, PAAS or SAAS service, you will inevitably share a
    limited resource, which is the time the company in charge of the service can spend on your specific needs.

##And it happens all the time##

To take a concrete example, a customer recently complained that a support ticket we
    file against a third party PAAS was not progressing fast enough. When we asked the support team for an update, they
    simply answered "Our engineers are working on it, in the meanwhile here's a workaround [...]".

Indeed we had already setup the workaround, and it was satisfying enough, so the
    ticket resolution was not urgent for us. But my customer found their answer "absolutely inacceptable", even after
    admitting that they were not impacted since we had setup the workaround. He simply could not accept that we had to
    wait, and wanted the issue dealt with immediately.

##Cloud Computing and the tragedy of the commons##

<div style="text-align: justify;">Since the provider company has a limited amount of engineers to dispatch on problems
    (not to mention that engineers are not interchangeable), they usually try to deal with tickets that have high impact
    first, this is usually :
</div>
<ul>
    <li style="text-align: justify;">Tickets that severely prevent the service to work</li>
    <li style="text-align: justify;">Tickets that impact a lot of customers</li>
    <li style="text-align: justify;">Tickets that, when solved, could help sign an interesting contract</li>
</ul>
Our issue was none of those, and indeed if, as customers, we have a severe
    blocking issue, I would have preferred they fix it rather than some small issue for which a workaround exist.
</div>

Nonetheless, if you remain focused too hard on the problem at hand, and forget the big
    picture, it is easy to get carried away and <b>demand</b>&nbsp;that you be serviced as you think you're entitled to.
    Even though that's useless, not efficient, and whatever else.


This issue with software support was here way before Cloud Computing : lots of people
    use Microsoft Office and if you contact the Office support it makes sense to expect use cases more grave than yours
    to be fixed first by Microsoft.

But Cloud Computing makes that issue way worse, for two reasons :
<ol>
    <li><b>There are more shared resources than before</b>&nbsp;: Sure, when you installed Office, you shared this piece
        of software with millions of other users around the world. But you installed MS Office on workstations that you
        owned and managed. And the macros you build on MS office where ones your developped and managed as well.
        Nowadays all this is more and more externalized, and becomes a common resource that you must share.
    </li>
    <li><b>It is harder to work around the issue by yourself</b>&nbsp;:&nbsp;because you often do not master the systems
        on which the faulty service is built, it is extremely hard to come up with a dirty, hopefully temporary fix. As
        a result a lot more issues need to go through the support process.&nbsp;</li>
</ol>
I do not believe there is any solution for this. Even more, I do not think we should
    be looking for a solution. All the point about As-A-Service resources is that you get a better service for a cheaper
    price. It is obvious that you cannot expect it to be bespoke as well.
