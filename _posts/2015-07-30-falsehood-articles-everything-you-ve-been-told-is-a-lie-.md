---
layout: post
title: Falsehood articles - everything you have been told is a lie
author: David Hatanian
---

I wrote last year [an article about dates]({% post_url 2014-09-10-why-you-should-not-try-to-deal-with %}), and how complicated it can get. I have updated it recently to included two excellent articles from Noah Sussman, a tester at Etsy who explains "falsehoods" about dates : thing we might hold for true, but that aren't. For example :

> Years have 365 days.

Yeah this one is easy, we have leap years with one more day.


> A week (or a month) always begins and ends in the same year.

OK, another obvious one, but I've seen this error before


> Human-readable dates can be specified in universally understood formats such as 05/07/11

This one is interesting. In France it would translate as the 5th of July while in the US it would be the 7th of May.


> One minute on the system clock has exactly the same duration as one minute on any other clock

Wrong, as can be expected

> Ok, but the duration of one minute on the system clock will be pretty close to the duration of one minute on most other clocks.

There are cases where clocks can go **really** adrift. But it's weird to imagine that even the duration of a minute could be very different from one clock to another. But the coup de grâce comes right after.

> Fine, but the duration of one minute on the system clock would never be more than an hour.

This one puzzled me. I couldn't imagine how a clock would suddenly make minutes last hours. Or, as Noah writes it :

> You can’t be serious.

He then gives an example of a clock for which some minutes would actually last hours :

> There was a fascinating bug in older versions of KVM on CentOS. Specifically, a KVM virtual machine had no awareness that it was not running on physical hardware. This meant that if the host OS put the VM into a suspended state, the virtualized system clock would retain the time that it had had when it was suspended. E.g. if the VM was suspended at 13:00 and then brought back to an active state two hours later (at 15:00), the system clock on the VM would still reflect a local time of 13:00. The result was that every time a KVM VM went idle, the host OS would put it into a suspended state and the VM’s system clock would start to drift away from reality, sometimes by a large margin depending on how long the VM had remained idle.

> There was a cron job that could be installed to keep the virtualized system clock in line with the host OS’s hardware clock. But it was easy to forget to do this on new VMs and failure to do so led to much hilarity. The bug has been fixed in more recent versions.

Funny right ? I find that kind of stuff very interesting. There are other such falsehood posts on other subjects, which I recommend reading :

* I think this is the oldest one, Patrick McKenzie's [Falsehoods Programmers Believe About Names](http://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/)
* The one which is quoted at the beginning of this post, Noah Sussman's [Falsehoods programmers believe about time](http://infiniteundo.com/post/25326999628/falsehoods-programmers-believe-about-time)
* A lot of people wanted to contribute to this list, so Noah compiled their falsehoods in a second post : [More falsehoods programmers believe about time; “wisdom of the crowd” edition](http://infiniteundo.com/post/25509354022/more-falsehoods-programmers-believe-about-time)
* Matthias Wesmann's [Falsehoods programmers believe about geography](http://wiesmann.codiferes.net/wordpress/?p=15187&lang=en)
* C. Scyphers' [Falsehoods Programmers Believe About Gender](http://www.cscyphers.com/blog/2012/06/28/falsehoods-programmers-believe-about-gender/)
