# <img src="content/images/cloud.png">

TODO / roadmap: 

- ~~Get everything to build again, ideally directly from cyclone~~
- ~~view integration with templates~~
- ~~support index pages. Should have a top-level index, and should also have "index" route in a controller that will be routed to if an empty route is specified for the controller (EG: "/demo2/" or "/demo2")~~
- make a working demo and have it do something interesting
- provide basic project description, installation/build instructions 
- and usage
- ~~REST integration, add support for get/post/put/delete methods~~
- as part of that, need to be able to receive POST args (and PUT/DELETE, are those the same?)
- as part of that, also need a way to format returned sexps as json/xml/other.
  basically will want to call a function that accepts an expression and does all of the
  writing to stdout for the object
- then get models working at some level (maybe postgres integration?)
- Deployment. It may not make sense to deploy the whole tree, do we have a convenience way to package up the app/content/views for deploying a site?
- Program to generate scaffolding, and docs for it
  This is the Command line tool called cloudburst
- Cyclone-winds package to install everything
- github action to build and test everything
  build and run example from github action, including http server hosting the fcgi app

- TODO: consider refactor to use explicit fcgi puts function instead of wrapping current output port and using display. Seems like it would be more efficient. Temple will still use current output though...
    
# Overview

Cloudburst is a FastCGI-based web framework for Cyclone Scheme.

# Install Dependencies

## Ubuntu

    sudo apt-get install libfcgi-dev spawn-fcgi

Right now we are using nginx instead, but this would be nice to figure out, too:
(lighthttpd setup https://www.linuxcloudvps.com/blog/how-to-install-lighttpd-on-ubuntu-18-04/ )

## Arch Linux

    pacman -Sy
    pacman -S pacman
    pacman -S nginx fcgi fcgiwrap spawn-fcgi

# Installation

    sudo cyclone-winds install cloudburst

# Usage

Layout/usage/etc for Controllers, Models, Views

How to deploy an application
How to run an application




