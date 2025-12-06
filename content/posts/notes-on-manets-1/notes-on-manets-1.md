---
date: 2025-12-02
title: Notes on Mobile Ad-hoc Networks (MANets)
summary: ""
description: "Part 1 of a muli-part series on Mobile Ad-hoc Networks and Self-Routing Network Capsules as I explore them for disaster communication"
draft: false
toc: false
autonumber: false
readTime: true
math: true
tags: ["internet", "LoRa", "Ad-hoc", "networks"]
showTags: true
hideBackToTop: false
---
# Introduction
Traditional infrastructure networks, for example, the *internet*, requires a lot of complex setup and maintenance. It's setup once and while it's adaptabile, for the most part it *does not change* (unless you're [Pakistan and you want to take down Youtube for half the world](https://www.cnet.com/culture/how-pakistan-knocked-youtube-offline-and-how-to-make-sure-it-never-happens-again/)).

Because of that, routes are calculated and pre-determined: If you live in Africa and you want to reach a server in America, your ISP likely has a preferred route that your packets will take to get there. Your ISP chooses this route based on some factors (e.g. cost, shortest routes, agreements it has with other ISPs [^1]).
# What Are They?

## Why They're Interesting?


[^1]: The internet is a collection of Autonomous Systems (AS) not ISPs. An autonomous system can be something like a university, a lab, an Internet Service Provider, government, etc. Really, any large enough network (or [small one](https://en.wikipedia.org/wiki/RIPE_NCC)) can be an AS. All you need is a subnet of public IP (a bunch of IP addresses that are yours) and an ASN (Autonomous System Number). These are handled by the Internet Assigned Numbers Authority (IANA)
