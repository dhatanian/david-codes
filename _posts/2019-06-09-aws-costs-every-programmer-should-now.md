---
layout: post
title: AWS costs every programmer should know
author: David Hatanian
---

The title for this blog post is a direct reference to [Latency Numbers Every Programmer Should Know](https://people.eecs.berkeley.edu/~rcs/research/interactive_latency.html). There are several versions of those numbers available now, and I could not find the original author with certainty. Some people attribute the original numbers to [Jeff Dean](https://twitter.com/jeffdean).

When working on a project that will reach a certain scale, you need to balance several concerns. What assumptions am I making and how do I confirm them? How can I get to market quickly? Will my design support the expected scale?

One of the issues associated with scale, is the cost of your infrastructure. Cloud providers allow you to provisions thousands of CPUs and store terabytes of data at the snap of a finger. But that comes at a cost, and what is negligible for a few thousand users might become a burning hole in your budget when you reach millions of users.

In this article, I'm going to list reference numbers I find useful to keep in mind when considering an architecture. Those numbers are not meant for accurate budget estimation. They're here to help you decide if your design makes sense or is beyond what you could ever afford. So consider the orders of magnitude and relative values rather than the absolute values.

Also consider that your company may get discounts from AWS, and those can make a massive difference.

# Compute #

What's the cost of a CPU these days? I used the wonderful [ec2instances.info](https://www.ec2instances.info/) interface to extract the median price of a vCPU.

You can get the source data out of [their Github repo](https://github.com/powdahound/ec2instances.info/blob/master/www/instances.json). I copied it and processed it using a python script [that you can find on Github](https://github.com/dhatanian/aws-ec2-costs). All prices are for the eu-west-1 region.

||Median monthly cost|
|---|---|
|1 modern vCPU (4 AWS ECUs)| 58 $/month |
|With 1 year convertible reservation (all up front)| 43 $/month |
|With 3 years convertible reservation (all up front)| 30 $/month |
|With spot pricing (estimated)| 30 $/month |

<br/>
I estimated spot pricing based on anecdotal data I got from various sources. As the prices vary within a day and I could not find a reliable data source for it.

AWS represents the computing power of its machines in Elastic Compute Units, and 4 ECUs represent more or less the power of a modern CPU. So the prices above are for one CPU or core, not one instance.

Here's the price of 1 ECU in $ per hour across all instance types I looked at:

<img src="/assets/{{ page.path | replace:'_posts','posts' }}/ecu-memory-cost.png"
  alt="Price of 1 ECU in $ per hour"
  style="margin:auto; display:block;"
  />

And here's how on-demand compares with 1 year and 3 year reservations (both convertible, upfront payments):

<img src="/assets/{{ page.path | replace:'_posts','posts' }}/ondemand-vs-reserved.png"
  alt="How many more reserved instances can you pay for the same price as on-demand"
  style="margin:auto; display:block;"
  />

# Storage #

So you want low latency, high throughput and are planning to store everything in Redis? Then on top of those CPU costs, you'll need to pay for RAM.

I used the same approach to extract the median price of 1GB of RAM on EC2. Elasticache is more or less twice as expensive for on-demand but prices drop quite quickly when looking at reserved instances.

||Median monthly cost|
|---|---|
|1 GB RAM | 10 $/month |
|1 GB RAM 1 year convertible reservation (all up front)| 8 $/month |
|1 GB RAM 3 years convertible reservation (all up front)| 5 $/month |
|SSD| 0.11 $/month |
|Hard Disk| 0.05 $/month |
|S3| 0.02 $/month |
|S3 Glacier| 0.004 $/month |
