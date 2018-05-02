# vagrant-php5.3.10

A Vagrant Box for PHP 5.3.10 on Ubuntu 12.04 LTS

## Introduction
I really like Laravel's Homestead project for hosting several projects on a single vagrant box.  It saves a lot of time and trouble, because it's ready to go without a lot of tweaking, and running just one vagrant box saves system resources.

However, Homestead only supports PHP versions as far back as PHP 5.5.  And I have several projects which are still running on PHP 5.3.  I wanted a vagrant box which could host several PHP projects on their own vhosts, like Homestead, but handle PHP 5.3.  So I forked this project for project for spinning up a PHP 5.3 vagrant box, and added a few tweaks, mostly around supporting multiple vhosts.

I built it for my own needs, but I've attempted to make it generic enough that others might benefit as well.

All the heavy lifting is done in install.sh.  I've done my best to make this script idempotent (ie. you can run it over and over and nothing bad happens).  If I missed something, feel free to submit a PR.

If you submit updates and additions, that's really cool.  Please make sure your modifications to install.sh are also idempotent.  We want to be able to run `vagrant provision` safely at any time.

## Setup
1. This vagrant config assumes your projects are all in sibling directories.  Open a terminal and cd to the parent directory in which all your projects live. `cd ~/Code` or something like that
1. Clone this project into that directory. `git clone git@github.com:eimajenthat/vagrant-php5.3.10.git`
1. Change directories into the new project. `cd vagrant-php5.3.10`
1. Make a copy of vhost-example.conf in vhosts/ folder for each vhost you want. `cp vhost-example.conf vhosts/{{myvhost}}.conf`
1. Edit your vhost files and fill in the placeholder values as appropriate.
1. Edit your local hosts file so that all the hostnames you used in your vhosts file point to 10.5.5.5.
1. Take a look at install.sh.  This is the provisioning script which will configure your machine after vagrant builds and starts it.  It should work fine AS IS, but you may want to add some lines, or remove some.
1. Build and run your vagrant box with `vagrant up`.

## To Do
- Right now, you have to create the vhosts manually.  I'd like to implement a barebones config file, kind of like Homestead's, which takes paths, hostnames, environment variables, and a few other datapoints, and generates vhost files on the fly.  If we did that, we'd probably still want a fallback where we supply our own vhost files, in case the vhost needs some extra config 
- It might be cool to have install.sh split up into a directory full of scripts.  Then you could have some sort of config to choose which ones to run.  This way, we could easily add new features, but not make them optional.  For instance, I don't want MySQL, because I run it on the host, but you might.  It would be nice to have a script to setup MySQL, which could be enabled on your config, and disabled on mine.
- The example vhost probably ought to have RewriteRules enabled, something like:
    ```
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule . /index.php [L]
    ```
  I didn't need it for my projects at the time, so I didn't fool with it.