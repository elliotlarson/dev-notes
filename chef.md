# Chef Notes

## Resources and Misc

* testing: https://github.com/test-kitchen/test-kitchen
* organization: http://peterjmit.com/blog/a-better-workflow-with-chef-and-vagrant.html
* https://github.com/tobami/littlechef 
* veewee: https://github.com/jedi4ever/veewee
* https://github.com/Nordstrom/chef-vault

## Vagrant

#### copying ssh public key to vagrant box

	$ ssh-copy-id vagrant@33.33.33.10
	# password "vagrant"

#### Generating an SSH key

	$ ssh-keygen -t rsa -C "my comment"


## Berkshelf with Vagrant setup instructions

#### 1. SETUP KITCHEN

	$ mkdir myapp
	$ cd myapp
	$ rbenv local 1.9.3-p448
	$ cat 'myapp' > .ruby-gemset
	$ rbenv rehash
	$ gem install bundler 
	$ bundle 
	$ bundle exec berks install
	$ bundle exec knife solo init . # it figures out if you have berkshelf installed


#### 2. DEPLOY TO VAGRANT VM

	$ vagrant init wheezy64 https://dl.dropboxusercontent.com/s/xymcvez85i29lym/vagrant-debian-wheezy64.box
	$ vagrant up
	$ vagrant ssh-config --host vagrant >> ~/.ssh/config
	$ bundle exec knife solo prepare vagrant

	# edit the node file /nodes/vagrant.json
	# add cookbooks to the run list
	# e.g. "recipe[nginx]"

	$ vagrant snapshot take prepared
	$ knife solo cook vagrant

	BAM!

## Data Bags

#### resources

* http://docs.opscode.com/config_rb_knife.html
* http://jtimberman.housepub.org/blog/2011/08/06/encrypted-data-bag-for-postfix-sasl-authentication/
* https://github.com/Nordstrom/chef-vault
* https://github.com/Nordstrom/chef-vault/issues/58

#### generating a data bag secret

	$ openssl rand -base64 512 > ~/.chef/encrypted_data_bag_secret

#### setting up data bag secret

add the following to the knife.rb file (it's in mysite/.chef/knife.rb):

	knife[:editor] = '/usr/bin/vim'
	knife[:data_bag_path] = 'data_bags/'
	knife[:secret_file] = '~/.chef/encrypted_data_bag_secret'

#### generate a data bag

	$ knife solo data bag create users deploy

#### view the data bag

	$ knife solo data bag show users deploy

#### view the data bag in json

	$ knife solo data bag show users deploy -F json

#### using in a recipe

	deploy_user = Chef::EncryptedDataBagItem.load("users", "deploy", secret_key) # secret key is optional, default /etc/chef/encrypted_data_bag_secret
	deploy_user["password"] # will be decrypted

	deployer_password = `openssl passwd -1 #{deployer_user['password']}`.chomp

#### using data bags with 

check out this article: https://blog.engineyard.com/2014/encrypted-data-bags

## Standard Server Setup

#### package software:

* nodejs
* logrotate
* fail2ban
* git
* nginx
* openssl
* postgresql
* htop
* tree
* ack
* tmux
* curl
* rbenv

#### server config

* [x] add deployer user with public and private keys from data bag
	* [x] make sure deployer can sudo without password
	* [x] add in bashrc with convenience aliases for app
	* [x] add public keys for elliot, arum, ricky to deploy user authorized keys file
* [x] openssh
	* [x] make sure root user can't login 
* [x] update the hostname of the server
* [x] update motd file with name of server
* [x] setup rails
	* [x] add shared directory
	* [x] add shared/config directory
	* [x] add environment variables file with api keys from data bag 
			(use this for application secret key, database user and password, and API keys)
* [x] postgres
	* [x] install database
	* [x] add in application database and user
* [x] nginx
	* add in config file for app
* [x] rbenv 
	* install ruby 2.0.0-p247
* [x] thin 
	* configure to run rails app and add in config file
* [ ] redis and sidekiq
* [ ] logrotate
	* add in config to rotate app logs
* [ ] ufw firewall 
	* lock down all ports except 80, 443, and SMTP
* [ ] tmux
	* add Elliot .tmux.conf
* [ ] vim 
	* add in standard Elliot config
* [ ] setup monit
	* monitor thin/ puma
	* monitor nginx
	* monitor postgres

## Goals

* write a chef kitchen for wpbinc job tracker
* abstract out standard rails single server from wpbinc job tracker kitchen
* integrate cookbook for monit
* change out thin for puma
* create kitchen for ACADIA
* run kitchens for WPB and ACADIA on amazon instances and get apps up and running
* create cookbook for setting up onehouse workstation machine


## Questions

* How do I override settings in community gems in my kitchen?
* How do I provision a server and deploy a Rails app?
* How do I provision a server for db, web server, and app server and deploy a rails app to it?
* What's the landscape, i.e. what are the tools available?
* How do I organize my files, cookbooks, recipes?
* How do I create users with Chef?
* After testing an app kitchen with Vagrant, how do I deploy to a real server?
* How do I automate dealing with environment variable application settings?


## Setting up on Amazon EC2

note: when logging into ubuntu instance the default user name is ubuntu




