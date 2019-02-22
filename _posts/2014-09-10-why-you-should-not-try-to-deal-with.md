---
layout: post
title: Why you should not try to deal with dates manually
author: David Hatanian
tags:
blogger_id: tag:blogger.com,1999:blog-5219665179084602082.post-226740451674924868
blogger_orig_url: http://david-codes.blogspot.com/2014/09/why-you-should-not-try-to-deal-with.html
---

When you're writing a program, you will always have to deal with dates and times at one point of the other.

It could be because you want to setup a scheduled task, or because you want a feature that provides reporting of his last month's activities to the user.

Date handling can be very tricky, and a lot of users still try to handle this manually. If you read [The Daily WTF](http://thedailywtf.com), you'll notice that probably a third of the poor coding examples have something to do with dates.

Microsoft's Azure platform experienced an [outage last year](http://azure.microsoft.com/blog/2012/03/09/summary-of-windows-azure-service-disruption-on-feb-29th-2012/) due to incorrect handling of leap years in 2013.

This articles is an attempt to list the gotchas you will encounter working with dates. There are two type of tricky aspects in handling dates : the date system itself, with its timezone, leap years and daylight saving time; and the technical aspect, that is how our computer systems manage dates.

## Timezones and daylight saving time

Aaah timezones... certainly easy to compute, right ? Just a signed `int` to indicate how many hours from UTC to store in the database.

But wait, did you know that some timezones have 30 minutes offset as well ? Check out Tehran (UTC+4:30) or New Delhi (UTC+5:30).

Countries also change timezones from time to time, usually for economical or political purpose, that is to get closer to a partner country or to show distance with a neighbour a bit too invasive. [Samoa switched timezone 3 years ago](http://www.timeanddate.com/news/time/samoa-dateline.html) to get closer to Australia.

What about daylight saving time ? Did you know that some country change the DST at the last minute ? For example, [Morocco has already done this quite a couple of times](http://www.timeanddate.com/news/time/egypt-morocco-dst-ramadan-2014.html), to prepare for the religious month of Ramadan. I experienced this when I was working there, all our clocks on our Windows laptops and servers were 1 hour late... If you run a calendar app and provide notification services, your Moroccan users probably received the notifications one hour too late during those days.

Another interesting consequence of daylight saving time : in a given timezone, there are dates (date here is understood as a combination of year, month, day, hour, minute, second, millisecond, etc) that occur twice ! For the same reason, some dates do not occur. [This StackExchange question](http://travel.stackexchange.com/questions/10419/problems-with-certain-times-occuring-twice-or-not-at-all-on-night-of-daylight) sums it up pretty well :

> In most of Europe, when the clocks are set from daylight saving time to standard time, at 3 AM the clocks are set back to 2 AM. Thus, a time like 2:29 happens twice in that night. In spring, the clocks go from 1:59 to 3 AM straight. Thus, 2:29 does not happen at all.


## Leap years

Enough about country-specific aspects, what about universal aspects of our calendar, such as leap years ? In those years, the year counts 366 days instead of the usual 365. Here's how to know if you're in a leap year [according to Wikipedia](http://en.wikipedia.org/wiki/Leap_year#Algorithm) :

{% highlight bash %}
if (year is not exactly divisible by 4) then (it is a common year)
else
if (year is not exactly divisible by 100) then (it is a leap year)
else
if (year is not exactly divisible by 400) then (it is a common year)
else (it is a leap year)
{% endhighlight %}

If Microsoft made the mistake, we can expect others to do it as well.

Now, let us say you have circumvented the problem by using a reliable date library (more on that later) and good unit testing. You're not done yet because our computer systems make date management even trickier...

## Trusting the user's clock
If you're developing a rich web application, a mobile application or an old school desktop application, you will have to deal with the user's clock.

That clock can be improperly set, and your time-sensitive operations might fail
        because of this. Let us say you have a javascript application that can ask a server for data at a certain time.
        To stay in the calendar example, let us imagine that the client code retrieves a list of events for a given set
        of start and end date.

If you client's clock is wrong, you will end up requesting the list of events for
        yesterday when the user wants the list for tomorrow.

One very time-sensitive type of operations is authentication. A lot of
        authentication protocols use timestamps (OAuth, Kerberos for example) and the authentication will fail if the
        client's clock is set wrong.

Even is the user's clock is correctly set, you know have two clocks in play at least (the client and the server), which are possibly in different timezones. When you pass dates from one system to another (for example with AJAX calls), make sure to pass them in a timezone-insensitive way and then to translate in the server's timezone during deserialization, otherwise you will have surprises.

## Parsing and printing dates

Did you write any application that does not either parse a date or prints somewhere (screen, name of a file, a web-service) ?

Try as much as possible to avoid parsing dates that are locale-dependent. Something
    that is written "Tuesday, September 3rd" might be written "Mardi 3 Septembre" on another machine.

Also, if you're displaying dates in a user interface, take into account that the
    length of month names depend on the language : July and Juillet are the same month but do not have the same length.
    Beware of text that does not fit and overflows or becomes partly hidden.

When parsing/printing a date, do not forget the TimeZone, otherwise you'll be off by
    several hours.

My recommendations :

  * Use ms or ns since epoch when for technical purposes (web-services, storing in a file etc)</li>
  * When you still want the date to be readable by the user, use the [ISO 8601 format](http://en.wikipedia.org/wiki/ISO_8601) that is easier to parse. It is also compatible with alphabetical
        sorting

<a href="https://xkcd.com/1179/">
<img src="https://imgs.xkcd.com/comics/iso_8601.png"
  alt="XKCD comic on ISO8601" title="ISO 8601 was published on 06/05/88 and most recently amended on 12/01/04."
  style="margin:auto; display:block;"
  />
</a>

## Is that all ?

Not really, [Noah Sussman](http://noahsussman.com/), who is a tester at Etsy, listed all the things programmers believe about dates and that turn out to be wrong in two posts :

 * [Falsehoods programmers believe about time](http://infiniteundo.com/post/25326999628/falsehoods-programmers-believe-about-time)
 * [More falsehoods programmers believe about time; “wisdom of the crowd” edition](http://infiniteundo.com/post/25509354022/more-falsehoods-programmers-believe-about-time)

 (If you want to know more about falsehoods, check out [this post]({% post_url 2015-07-30-falsehood-articles-everything-you-ve-been-told-is-a-lie- %}) where I list other similar blog articles)

## Who will save us ?

In Java, the `java.util.Date` and `java.util.Calendar` APIs are good enough for most simple
    use cases. The [Joda time library](http://www.joda.org/joda-time) gives easiest access to most date and
    time-related operations.

The [Why Joda Time](http://www.joda.org/joda-time/#Why_Joda-Time)
    section of the above link summarizes the advantages of this library as follows :


<blockquote>
        <ul>
            <li><b>Easy to Use</b>. Calendar makes accessing 'normal' dates difficult, due to the lack of simple
                methods. Joda-Time has straightforward&nbsp;<a href="http://www.joda.org/joda-time/field.html"
                                                               style="color: #000099; text-decoration: none;">field
                    accessors</a>&nbsp;such as&nbsp;<tt>getYear()</tt>&nbsp;or&nbsp;<tt>getDayOfWeek()</tt>.
            </li>
            <li><b>Easy to Extend</b>. The JDK supports multiple calendar systems via subclasses
                of&nbsp;<tt>Calendar</tt>. This is clunky, and in practice it is very difficult to write another
                calendar system. Joda-Time supports multiple calendar systems via a pluggable system based on
                the&nbsp;<tt>Chronology</tt>&nbsp;class.
            </li>
            <li><b>Comprehensive Feature Set</b>. The library is intended to provide all the functionality that is
                required for date-time calculations. It already provides out-of-the-box features, such as support for
                oddball date formats, which are difficult to replicate with the JDK.
            </li>
            <li><b>Up-to-date Time Zone calculations</b>. The&nbsp;<a
                    href="http://www.joda.org/joda-time/timezones.html" style="color: #000099; text-decoration: none;">time
                zone implementation</a>&nbsp;is based on the public&nbsp;<a class="externalLink"
                                                                            href="http://www.iana.org/time-zones"
                                                                            style="color: #000099; padding-right: 15px; text-decoration: none;">tz
                database</a>, which is updated several times a year. New Joda-Time releases incorporate all changes made
                to this database. Should the changes be needed earlier,&nbsp;<a
                        href="http://www.joda.org/joda-time/tz_update.html"
                        style="color: #000099; text-decoration: none;">manually updating the zone data</a>&nbsp;is easy.
            </li>
            <li><b>Calendar support</b>. The library currently provides 8 calendar systems. More will be added in the
                future.
            </li>
            <li><b>Easy interoperability</b>. The library internally uses a millisecond instant which is identical to
                the JDK and similar to other common time representations. This makes interoperability easy, and
                Joda-Time comes with out-of-the-box JDK interoperability.
            </li>
            <li><b>Better Performance Characteristics</b>. Calendar has strange performance characteristics as it
                recalculates fields at unexpected moments. Joda-Time does only the minimal calculation for the field
                that is being accessed.
            </li>
            <li><b>Good Test Coverage</b>. Joda-Time has a comprehensive set of developer tests, providing assurance of
                the library's quality.
            </li>
            <li><b>Complete Documentation</b>. There is a full&nbsp;<a
                    href="http://www.joda.org/joda-time/userguide.html" style="color: #000099; text-decoration: none;">User
                Guide</a>&nbsp;which provides an overview and covers common usage scenarios. The&nbsp;<a
                    href="http://www.joda.org/joda-time/apidocs/index.html"
                    style="color: #000099; text-decoration: none;">javadoc</a>&nbsp;is extremely detailed and covers the
                rest of the API.
            </li>
            <li><b>Maturity</b>. The library has been under active development since 2002. Although it continues to be
                improved with the addition of new features and bug-fixes, it is a mature and reliable code base. A
                number of&nbsp;<a href="http://www.joda.org/joda-time/related.html"
                                  style="color: #000099; text-decoration: none;">related projects</a>&nbsp;are now
                available.
            </li>
            <li><b>Open Source</b>. Joda-Time is licenced under the business friendly&nbsp;<a
                    href="http://www.joda.org/joda-time/license.html" style="color: #000099; text-decoration: none;">Apache
                License Version 2.0</a>.
            </li>
        </ul>
</blockquote>

Note that since Java 8, a [new Date and Time
    API](http://java.dzone.com/articles/introducing-new-date-and-time) has been introduced in the JDK, and its creation involved the author of the Joda Time library.
