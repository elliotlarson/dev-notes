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

Use oh-my-zsh:

```bash
$ sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Make neovim the default editor

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

```bash
$ sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Make neovim the default editor

Login as root

```bash
$ echo 'export EDITOR="nvim"' >> ~/.zshrc
$ echo 'export EDITOR="nvim"' >> /home/deploy/.zshrc
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

## Add in ASDF

This allows you to install and manage different versions of languages.

Login as the deploy user.

Download the library:

```bash
$ git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
```

Add this to your `~/.zshrc` file:

```bash
. $HOME/.asdf/asdf.sh
```

Make sure you have dependencies:

```bash
$ sudo apt-get install dirmngr gpg curl gawk
```

Add the nodejs plugin:

```bash
$ asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
```

Add a nodejs version

```bash
$ asdf install nodejs 16.15.0
```

Use this version globally:

```bash
$ asdf global nodejs 16.15.0
```

Add Ruby:

```bash
$ sudo apt-get install -y libssl-dev zlib1g-dev
$ asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
$ asdf install ruby 3.1.2
$ asdf global ruby 3.1.2
```

## Install Postgres

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
$ nvim /etc/postgresql/12/main/pg_hba.conf
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

## Install Yarn for asset precompilation

Log onto the server

```bash
$ curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
$ echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$ sudo apt update
$ sudo apt install yarn -y
```

## Using Capistrano to deploy

On the server add the app directory:

```bash
$ sudo mkdir /var/www/hello_bugs
$ sudo chown deploy:deploy /var/www/hello_bugs
```

Setup your key so you can deploy.  If you don't do this when you try to deploy you will see a `Permission denied` error when Capistrano tries to access the repo.

```bash
# start the ssh-agent in the background
eval "$(ssh-agent -s)"
# Agent pid 6273
ssh-add ~/.ssh/id_rsa -k
#=> Identity added: /Users/username/.ssh/id_rsa (/Users/username/.ssh/id_rsa)
```

Setup Capistrano to have a binstub in your app locally:

```bash
$ bin/bundler binstub capistrano
```

Then you can run the cap command, which will error out because we don't have everything in place, but this will setup some directories for us:

```bash
$ bin/cap production deploy
```

Then log onto the server and create `/var/www/<appname>/shared/application.yml` with a `SECRET_KEY_BASE` value.

You can run the `$ bin/rails secret` command to get a secret.

```yml
SECRET_KEY_BASE: 1234
```

## Setup server to restart on reboot

