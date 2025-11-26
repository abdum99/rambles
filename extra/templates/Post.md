---
date: <% tp.file.creation_date("YYYY-MM-DDTHH:mm:ss+03:00") %>
draft: "false"
title: <% tp.file.title %>
summary: ""
description: ""
toc: false
readTime: true
math: true
tags: []
showTags: true
hideBackToTop: false
---
<% tp.file.move('/content/posts/' + tp.file.title + '/index.md') %>