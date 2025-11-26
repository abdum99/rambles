---
date: <% tp.file.creation_date("YYYY-MM-DDTHH:mm:ss+03:00") %>
title: <% tp.file.title %>
summary: ""
description: ""
draft: false
toc: false
autonumber: false
readTime: true
math: true
tags: []
showTags: false
hideBackToTop: false
---
<% tp.file.move('/content/posts/' + tp.file.title + '/index.md') %>