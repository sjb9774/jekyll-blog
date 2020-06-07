---
layout: post
title:  "Getting Started with Jekyll"
date:   2020-06-04 12:00:00 -0600
categories: jekyll update centos web blog dev dev-guide
---
Jekyll is an appealing platform for developers as it allows you to easily manage your blog content simply with familiar tools, in some cases it's as simple as using git and your preferred text editor. However, if you're not intimately familiar with the Ruby ecosystem (I am not) or aren't immediately sure how you might get your blog set up on a server and ready for publishing, this guide should help clear up some of these issues.

<sup>_First and foremost, if you're familiar with Ansible (not necessary), you can refer to the playbook I set up and used to get my server set up in a repeatable fashion:_ [https://github.com/sjb9774/jekyll-blog-server][jekyll-github]</sup>

Outline
* Create CentOS server through AWS
  * Ensure SSH key is set up
  * Provide CentOS image
  * Ensure inbound/outbound rules are setup correctly
* Create a new user to use for blog
  * Start with centos user
  * Add new user
    * Add SSH key to authorized_keys
    * Add user to sudoers
* Install ruby
  *
* Can use apache or nginx, example with nginx





[jekyll-github]: https://github.com/sjb9774/jekyll-blog-server
