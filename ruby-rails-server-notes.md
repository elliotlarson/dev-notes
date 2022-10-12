# Ruby Rails Server Notes

Notes on setting up a basic VPS server for hosting a hobby Rails app.

## Make sure you are on the latest and greatest

Login as root:

```bash
$ ssh root@ipaddress
```

Then upgrade the OS:

```bash
$ apt-get update && apt-get dist-upgrade -y
```

## Use ZSH shell

Install the dependencies:

```bash
$ apt-get install build-essential curl file git git-core neovim -y
```

Install zsh:

```bash
$ apt install zsh -y
```

Reboot machine:

```bash
$ reboot
```

Use oh-my-zsh:

```bash
$ sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Add a deploy user

This will ask for a password for the deploy user.  You can enter it in and keep track of it somewhere, but we are going to only allow users to login with SSH keys.  This is setup by default on Digital Ocean.

```bash
$ adduser deploy
$ adduser deploy sudo # adds to the sudoer group
```

## Allow the deploy user to login

On digital ocean the root user has your SSH key by default when you setup a droplet.

Copy the `.ssh` directory from root to deploy to get the authorized keys:

```bash
$ cp -R .ssh /home/deploy/
```

Then change the permissions on it

```bash
$ chown -R deploy:deploy /home/deploy/.ssh
```

You should now be able to login as the deploy user.

## Add oh-my-zsh to deploy user

Logout and login as the deploy user:

```bash
$ sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

Add some custom config to zsh:

```bash
$ nvim ~/.zshrc.local
```

```text
# General config
export EDITOR="nvim"
alias vim="nvim"

alias applog="cd /var/www/<appname>/shared/log && ls -l"
alias appconfig="cd /var/www/<appname>/shared/config && ls -l"
alias appcurrent="cd /var/www/<appname>/current && ls -l"
alias appconsole="cd /var/www/<appname>/current && bundle exec rails c"
alias apprake="cd /var/www/<appname>/current && bundle exec rake"

alias c="cd"
alias l="ls -l"
alias u="cd ../"
```

And then source the file in the `.zshrc` file:

```bash
$ nvim .zshrc
```

Add the text:

```text
source .zshrc.local
```

## Allow deploy user to sudo without password

Login as root

```bash
$ visudo
```

Add this to the end of the file:

```text
deploy ALL=(ALL) NOPASSWD:ALL
```

## Install Ruby with Rbenv

Login as deploy:

Make sure your dependencies are all installed:

```bash
$ sudo apt install git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev -y
```

Install Rbenv:

```bash
$ curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
```

Add some config to your shell's profile:

```bash
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc.local
$ echo 'eval "$(rbenv init -)"' >> ~/.zshrc.local
```

Logout and login again.

Install a version of Ruby:

```bash
$ rbenv install 3.1.2
```

Make this Ruby the globally used Ruby:

```bash
$ rbenv global 3.1.2
```

Install gems without documentation:

```bash
$ echo "gem: --no-document" > ~/.gemrc
```

## Add in nodenv

```bash
# install the base app
git clone https://github.com/nodenv/nodenv.git ~/.nodenv

# add nodenv to system wide bin dir to allow executing it everywhere
sudo ln -vs ~/.nodenv/bin/nodenv /usr/local/bin/nodenv

# compile dynamic bash extension to speed up nodenv - this can safely fail
cd ~/.nodenv
src/configure && make -C src || true
cd ~/

# install plugins
mkdir -p "$(nodenv root)"/plugins
git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build
git clone https://github.com/nodenv/nodenv-aliases.git $(nodenv root)/plugins/nodenv-aliases

# install a node version to bootstrap shims
nodenv install 14.15.4
nodenv global 14

# make shims available system wide
sudo ln -vs $(nodenv root)/shims/* /usr/local/bin/
```

Install yarn package manager:

```bash
$ curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
$ echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$ sudo apt-get update
$ sudo apt-get install yarn -y
```

Make sure the `yarn` command is available:

```bash
$ sudo ln -s /home/deploy/.nodenv/shims/yarn /usr/local/bin/yarn
```

## Install Postgres

Login as deploy:

```bash
$ sudo apt-get install postgresql postgresql-contrib libpq-dev -y
```

Login as the postgres user:

```bash
$ sudo -u postgres psql
postgres=> create user <username> with password '<password>';
postgres=> alter role <username> superuser createrole createdb replication;
postgres=> create database hello_bugs_production owner <username>;
```

You also need to alter the config file

```bash
$ sudo nvim /etc/postgresql/14/main/pg_hba.conf
```

Change the config line for all to use password (change 'peer' to 'md5'):

```text
local   all             all                                     md5
```

Then restart postgres

```bash
$ sudo service postgresql restart
```

## Install Nginx

```bash
$ sudo apt-get install nginx -y
```

## Setup Nginx with Letsencrypt

## Using Capistrano to deploy

Add capistrano to your app's Gemfile:

```ruby
group :development do
  gem "capistrano", "~> 3.17", require: false
end
```

Run the install command:

```bash
$ bundle exec cap install
```

Setup Capistrano to have a binstub in your app locally:

```bash
$ bin/bundler binstub capistrano
```

On the server add the app directory:

```bash
$ sudo mkdir -p /var/www/<appname>
$ sudo mkdir -p /var/www/<appname>/shared/config
$ sudo chown -R deploy:deploy /var/www/<appname>
```

Add environment variables file:

```bash
$ nvim /var/www/<appname>/shared/config/app.env
```

Put things like a secret key base in it.

You can generate one with the rails command: `rake secret`

```text
export RACK_ENV=production
export RAILS_ENV=production
export SECRET_KEY_BASE=bd25345fa18783a8a627e85061f8686b0bd1bda0e85efc92e2e3f7126536881972c73a3f5a024576abd3d68f86c731224b26dfa05b72486ba20c8e03df769bed
export DATABASE_NAME=appname_production
export DATABASE_USER=deploy
export DATABASE_PASS=%n2On4p8m920
```

Then source the secrets in your `.zshrc` file:

```bash
$ nvim ~/.zshrc
```

Add the following:

```text
source /var/www/<appname>/shared/config/app.env
```

Setup your key so you can deploy.  If you don't do this when you try to deploy you will see a `Permission denied` error when Capistrano tries to access the repo.

```bash
# start the ssh-agent in the background
eval "$(ssh-agent -s)"
# Agent pid 6273
ssh-add ~/.ssh/id_rsa -k
#=> Identity added: /Users/username/.ssh/id_rsa (/Users/username/.ssh/id_rsa)
```

Add config files locally (this will stick the puma and nginx config file templates in the config dir):

```bash
$ rails g capistrano:nginx_puma:config
```

Add Capistrano config files to server:

```bash
$ bin/cap production puma:config
$ bin/cap production puma:nginx_config
$ bin/cap production puma:systemd:config puma:systemd:enable
```

This will stick a SystemD config file:

* `/etc/systemd/system/puma_<appname>_production.service`

Note that the default systemctl file does not seem to be valid.  I had to rewrite mine to:

```text
# /etc/systemd/system/puma_<appname>_production.service
[Unit]
Description=Puma HTTP Server for <appname> (production)
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/var/www/<appname>/current
# Support older bundler versions where file descriptors weren't kept
# See https://github.com/rubygems/rubygems/issues/3254
Environment=RBENV_ROOT=/home/deploy/.rbenv
Environment=RBENV_VERSION=3.1.2
# Needed to add `cd /var/www/<appname>/current && . /home/deploy/.zshrc &&` so it could find the .bundle directory
# ExecStart=cd /var/www/<appname>/current && . /home/deploy/.zshrc && /home/deploy/.rbenv/bin/rbenv exec bundle exec --keep-file-descriptors puma -C /var/www/<appname>/shared/config/puma.rb
ExecStart=/usr/bin/zsh -lc 'cd /var/www/<appname>/current && . /home/deploy/.zshrc && /home/deploy/.rbenv/bin/rbenv exec bundle exec --keep-file-descriptors puma -C /var/www/<appname>/shared/config/puma.rb'
ExecReload=/bin/kill -USR1 $MAINPID
StandardOutput=append:/var/www/<appname>/shared/log/puma_access.log
StandardError=append:/var/www/<appname>/shared/log/puma_error.log
Restart=always
RestartSec=1
SyslogIdentifier=puma

[Install]
WantedBy=multi-user.target
```

Remove the `default` nginx symlink:

```bash
$ sudo rm -rf /etc/nginx/sites-enabled/default
$ sudo systemctl restart nginx
```

Add a `database.yml` file.  Login to the server as deploy:

```bash
$ nvim /var/www/<appname>/shared/config/database.yml
```

Add the following:

```text
production:
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  database: <%= ENV['APP_DATABASE_NAME'] %>
  username: <%= ENV['APP_DATABASE_USER'] %>
  password: <%= ENV['APP_DATABASE_PASS'] %>
```

Logout.

Then you can run the cap command, which will error out because we don't have everything in place, but this will setup some directories for us:

```bash
$ bin/cap production deploy
```

Note that I also had to run the `assets:precompile` command on it's own to get the `application.js` file to be generated.

```bash
$ bin/cap production deploy:assets:precompile
```

## Setting up log rotate

## Setup database backups

## Upload basic profile aliases
