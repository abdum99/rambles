---
date: <% tp.file.creation_date("YYYY-MM-DDTHH:mm:ss+03:00") %>
draft: "true"
title: <% tp.file.title %>
summary: "TODO Summary"
description: "TODO Description"
author: "Abdu"
toc: true
readTime: true
autonumber: true
math: true
tags: ["tag1"]
showTags: true
hideBackToTop: false
---
<% tp.file.move('/content/posts' + tp.file.title) %>