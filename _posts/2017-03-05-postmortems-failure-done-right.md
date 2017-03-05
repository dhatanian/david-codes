---
author: David Hatanian
date: 2017-03-05 10:10:00 +00:00
layout: post
asset-type: post
slug: postmortems-failure-done-right
title: 'Postmortems: failure done right'
---

A postmortem is a document in which a team reflects on a recent outage and think of ways to prevent it from happening again. After an outage or security breach, the team gathers and writes a document discussing the event and what they’ve learnt from it.

I am fascinated by these documents and read any postmortem that I encounter. They are a great way for a team to reflect on their practices and improve upon them. Because postmortems address the failure of a system managed by the team, writing them is also an exercise in humility.

Every time I read a postmortem, I think "can something similar happen in my project?". There is always something to learn from other people’s postmortems. We all have been in situations where we forgot something or made mistakes that we would have never thought of. It is also a good reminder that we are fallible. By reading other postmortems we learn from other people’s mistakes and we reflect on ours.

Some companies use the name RCA, or Root Cause Analysis for such documents. I prefer the term "postmortem", because RCA sounds like the work stops at identifying a cause. The value of the process is rather in discussing the solutions and lessons learned rather than focusing on the cause of the issue.

## How to write a postmortem document

### Gather the team

After an outage, gather the team in a room to edit the postmortem together. Make sure you include everyone who was involved in detecting the problem and implementing the solution. If there were a lot of teams involved, get at least a representative of each team.

If you cannot gather everyone together (remote workers, people too busy), you can collaboratively edit a document on Google Docs or something similar.

### Describe the outage

Start with an introduction describing in one paragraph what the issue was, what its impact has been, and when it occurred.

Then write up a precise timeline of the events. Include any meaningful even such as:

* An alert was received

* An action was taken

* An action was completed

* An engineer made an important realisation on the problem at hand

* Something was communicated externally

* Impact started/stopped being noticeable by users

### Discuss causes and learnings

Once this is done, you have a good basis to discuss causes and learnings. Start by having a look at what went right. Did your escalation process work correctly? Did an engineer follow one of your operations playbooks with success? If so, do mention it here. It is an acknowledgement of how much the team has already accomplished to improve the system’s resiliency.

Then have a look at what did not go well. Explore each issue, and look for the causes. What made things difficult? Why did this system fail, or why was this alert ignored? There is usually more than one cause, so do not stop at the first one you find. Iterate on those causes to get a better understanding of what caused the problem. Use a technique such as [5 Why’s](https://en.wikipedia.org/wiki/5_Whys) to achieve this.

### Agree on actions

Finally, list out all the actions that need to be taken to prevent similar problems from occurring. You will probably want to patch your code to fix the issue you found, but you should consider other actions, for example:

* Improving documentation on solving this kind of issue

* Adding an alert to surface an issue earlier

* Improving the incident response process if necessary

* Communicating the postmortem to other teams so that they learn from it

* Reviewing the system for similar vulnerabilities that would not have been found yet

* Planning for a repetition of the incident to ensure that the steps taken work

Like any action plan, name an owner for each of the actions, to make sure they’re dealt with. You should also agree on a date to check on those actions’ progress.

## What is a good postmortem?

### Precise

The most important quality of a good postmortem is being factual. In particular, the timeline should be as precise as possible and describe all the events from the first symptoms to the resolution. Be concise and stay away from vagueness. Take a statement such as:

> *the latency increased after deploying the new version*

It should be replaced with a more precise version, such as:

> *the 99th percentile latency grew from 300ms to 1.2s within 3 minutes of the deployment, and **stayed** that way during 12 minutes before going down to the nominal value of 300-400ms*

### Blameless

Second, a postmortem is blameless. It does not judge, it describes the events and the actions taken to solve it. If a postmortem is not blameless, people cannot be candid about the errors they made. With a blameful postmortem, you will not reach the right conclusion. This is a tricky exercise. By the time the outage is over, people are exhausted. To make sure that a postmortem does not blame anybody, it is better to write it after everyone had a good night’s sleep.

### Facilitated

An external facilitator can be very helpful. They will gather the facts and ask questions to people involved in the outage. This will result in a more factual, blameless postmortem. The worst option is for the manager of the people involved to lead the postmortem meeting! For a lot of people, it is harder to discuss openly a mistake they made in front of the person who assesses their performance and will decide on their salary bump in a couple of months. Postmortem meetings lead by managers will always be less transparent that ones led by independent facilitators.

### Constructive

Postmortems and their quality are a reflection of your team and company’s dynamic. A team who feels safe owning their mistakes will write candid, transparent postmortems. A team worried about deflecting blame and securing their next performance review will not. Teams where members do not feel safe to speak their mind will provide a biased version of the postmortem and will avoid addressing the actual causes. Fix the team issues, and the postmortems will improve by themselves.

## Conclusion

Today, more companies are transparent and publish their postmortems on their blog. This is an extraordinary occasion to see the challenges faced by other engineers. You can see how Google, Facebook, Microsoft, or smaller startups address issues. We should acclaim companies and engineers who publish such documents. It takes a lot of humility to admit failure and expose mistakes for the world to see.

The resource section below contains examples of interesting postmortems published by famous companies. Take the time to read a couple of these, they read like a thriller and I guarantee you will learn a lot!

I hope this article was helpful to you. Do get in touch at [@dhatanian](https://twitter.com/dhatanian) if you want to discuss systems resiliency or share interesting postmortems with me!

## Some examples of postmortems

* [2017-02-15 Heroku users experience elevated error rates due to improper versioning of the code that upgrades containers](https://engineering.heroku.com/blogs/2017-02-15-filesystem-corruption-on-heroku-dynos/)

* [2012-02-29 Generation certificate code that was not written to handle leap days make VM creation on Azure fail](https://azure.microsoft.com/en-us/blog/summary-of-windows-azure-service-disruption-on-feb-29th-2012/)

* [2017-01-31 After several erroneous manipulations on the database, Gitlab wipe their production database and discover that backups are not available](https://about.gitlab.com/2017/02/10/postmortem-of-database-outage-of-january-31/)

* [Another database-related postmortem at Gitlab](https://docs.google.com/document/d/1ScqXAdb6BjhsDzCo3qdPYbt1uULzgZqPO8zHeHHarS0/preview?sle=true&hl=en&forcehl=1#heading=h.dfbilqgnc5sf)

* [Not exactly a postmortem, but an article about how my colleague Franziska learned from her failure after taking down our company blog by mistake](https://codurance.com/2015/07/14/learning-from-our-failures/)

### Additional resources on postmortems:

* [The postmortem culture at Google, part of the Google SRE book that I highly recommend](https://landing.google.com/sre/book/chapters/postmortem-culture.html)

* [An example of postmortem on a fake Shakespeare service, from the same book](https://landing.google.com/sre/book/chapters/postmortem.html)

* [Postmortem lessons by Dan Luu](http://danluu.com/postmortem-lessons/)

* [A list of Postmortems by the same author](https://github.com/danluu/post-mortems)
