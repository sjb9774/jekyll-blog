---
layout: post
title:  "Getting Started with a Cloud Server"
date:   2020-06-04 12:00:00 -0600
categories: aws cloud update centos web dev dev-guide
---
Thoughts
* Creating your first server in AWS
* What does every piece mean? This is a very specific guide so we can give specific explanations
  * SSH keys
  * Security group
  * IP/DNS
  * Subnet
  * Image
* Demonstrate ssh access

Notes
* aws.amazon.com/console -> Create AWS Account if no Account
  * Free tier included great for testing and getting started
    * Can host a free micro server for free indefinitely
* Once account created, navigate to My Account > AWS Management Console
* Navigate to Services > Compute > EC2
* Click Instances > Instances
* Click Launch Instance
  * For me, I'm using a Centos7 image
    * image id: ami-0a4e0492247630fe1
  * Select desired image size, in this case the t2.micro for Free Tier
* Configure instance
  * Defaults should be fine
  * VPC is good to know about
    * Details here: https://aws.amazon.com/vpc/
    * General idea is that VPC allows you to isolate your resources and define traffic rules that apply only to instances in this group
  * Subnets allow further grouping within VPCs and are isolated to certain availability zones within the VPC
    * https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html
  * Add storage
    * Relatively self-explanatory, defaults fine
  * Add tags
    * Helpful for distinguishing instances from others in the UI, but primarily useful for the AWS API
  * Configure security group
    * This one is important
    * Starts with SSH enabled, which is good
    * Often I'll change the SSH source to be "My IP" but keep that in mind if you're coming from other IPs
    * If you plan to install a webserver on this instance you'll want to add an HTTP and HTTPS rule
      * During development I restrict the HTTP/S access to my IP, then change it to "anywhere" when appropriate
  * Launch
    * Create Key pair
    * Describe use of ssh key
    * example ssh command
