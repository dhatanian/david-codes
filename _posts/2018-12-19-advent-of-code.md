---
author: David Hatanian
date: 2018-12-19 20:38:00 +00:00
layout: post
asset-type: post
slug: advent-of-code
title: 'Advent of Code 2018'
---

As a kid, my parents would buy [advent calendars](https://en.wikipedia.org/wiki/Advent_calendar) for my siblings and I before Christmas. If you have never seen one, an advent calendar counts down the days from December 1st to Christmas day or Christmas eve.

A typical advent calendar would countain a chocolate per day (bear with me, we'll be talking about code soon). Although these days you could get anything in those calendars: perfume, protein balls, cereal bars...

<img src="/assets/{{ page.path | replace:'_posts','posts' }}/adventcalendar.jpg"
  alt="An example of an advent calendar, courtesy of Wikimedia"
  style="margin:auto; display:block;"
  />

This year in addition to that typical advent calendar, I am taking part in [Advent Of Code](https://adventofcode.com). Created and run by [Eric Wastl](http://was.tl/), Advent of Code has been running since 2015. The website offers a new coding problem each day over the 25 days from December 1st to Christmas.

<img src="/assets/{{ page.path | replace:'_posts','posts' }}/adventofcode.png"
  alt="The Advent Of Code man page, listing the riddles you've already solved and the upcoming ones"
  style="margin:auto; display:block;"
  />

Each problem follows the same general structure :
 * a description of the problem, with some background story (usually around helping Santa's elves to save Christmas)
 * some examples of input data and expected result
 * an input file that needs to be parsed and processed to get the answer
 * a second part for the problem, that you can only access when you've solved the first part. Very often, the second part looks like `let's make the input data 100 times bigger`

Here's what a problem looks like:

```
 Below the message, the device shows a sequence of changes in frequency (your puzzle input).
 A value like +6 means the current frequency increases by 6;
 a value like -3 means the current frequency decreases by 3.

For example, if the device displays frequency changes of +1, -2, +3, +1, 
then starting from a frequency of zero, the following changes would occur:

Current frequency  0, change of +1; resulting frequency  1.
Current frequency  1, change of -2; resulting frequency -1.
Current frequency -1, change of +3; resulting frequency  2.
Current frequency  2, change of +1; resulting frequency  3.

In this example, the resulting frequency is 3.

Here are other example situations:

+1, +1, +1 results in  3
+1, +1, -2 results in  0
-1, -2, -3 results in -6

Starting with a frequency of zero, what is the resulting frequency 
after all of the changes in frequency have been applied?
```

This is the [first problem](https://adventofcode.com/2018/day/1) of the advent of code 2018, and also the easiest. Subsequent problems get harder.

The input data is **different for each participant**. This amazes me. Eric had to come up with an original problem, and then write a generator to provide different input to each participant (70 000 people solved the first problem)!

Clearly Advent of Code is a successful formula. To the point that Eric had to ask people to [stop sending spammy requests to track their leaderboard](https://www.reddit.com/r/adventofcode/comments/a1qovy/please_dont_spam_requests_to_aoc/).

Personally I like it because it allows me to play with technologies that I don't get to use every day. This year I tried to solve it in Scala, although I might finish it in Go. It's also a good way to review concepts such as algorithmic complexity, breadth-first versus depth-first or [Dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm).

Reading other people's point of views on Reddit or on my company Slack, we all have different reasons to take part, and enjoy different types of problems. Some of my colleagues enjoy the parsing of the input file, while like me enjoy when the problem challenges me to think about algorithmic complexity and find clever ways to solve issues with large datasets.

If you're bored during the winter holidays, or want to try out a new language, do check out Advent of Code. And if you're curious, [my solutions to the problems is on Github](https://github.com/dhatanian/adventofcode).