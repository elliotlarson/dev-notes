# Ubuntu Development Machine Notes

Notes about setting a Ruby/Rails, etc. development machine running Ubuntu Linux.

## Keyboar Shortcuts

* `super + up arrow` - maximize window
* `super + right arrow` - window takes up right side of screen
* `super + left arrow` - window takes up left side of screen

## System Monitoring Tools

* `htop` - Good interactive terminal UI for seeing what's happening with your computer's resources.  There's a nice view of all your cores.
* `glances` - Another tool like `htop` but provides some additional info about network, disk space, and IO
* `zellij` - terminal multiplexer like Tmux, but more modern and easier to use
* `fzf` - fuzzy finder for history and vim
* `neovim` 
* `ulauncher` - an application launcher (ctrl + space)

## Misc Info

* The default GUI for the operating system on Ubuntu is called `Gnome`


## Setting Up Vim

I chose to go with Neovim, which mostly works out of the box with my Vim config files.  One difference is that Vim looks for `~/.vimrc` as a config file entry point, and Neovim looks for `~/.config/nvim/init.vim`.  I just added the line `source ~/.vimrc` to the top of this file, and things worked out.

## Mounting Hard Drives

```bash
$ sudo mount -t xfs -o discard /dev/sda /mnt/ssd
```

```bash
$ sudo mount -t nfs 169.254.250.65:/volume1/ChiaPlots /mnt/chia-drive
```

## Allowing SSH Access to Machine

You need to install the SSH server, which doesn't come installed on Ubuntu desktop by default:

```bash
$ sudo apt install openssh-server
```

Check the status of the server:

```bash
$ sudo systemctl status ssh
```

Allow SSH traffic through the firewall:

```bash
$ sudo ufw allow ssh
```

## Setting Up Postgres

Add the database and related software:

```bash
$ sudo apt install postgresql postgresql-contrib libpq-dev
```

I updated the permissions:

```bash
$ sudo find / -name pg_hba.conf
# /etc/postgres/13/main/pg_hba.conf
$ sudo vim /etc/postgres/13/main/pg_hba.conf
```

TODO: I also created a user database for my user role and gave myself permission to create databases

## Setting Up Ruby

```bash
$ git clone https://github.com/rbenv/rbenv.gif ~/.rbenv
```

Install Ruby build:

```bash
$ git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
```

## Installing Nvidia drivers

Check which drivers you need:

```bash
$ ubuntu-drivers devices
```

Install missing drivers that you see:

```bash
$ sudo apt-get install nvidia-driver-460
```

Reboot

```bash
$ sudo reboot
```
