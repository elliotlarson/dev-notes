# Ansible Notes

## Working with Vagrant

#### Setting up a Vagrant cluster of VMs

First you want to initialize Vagrant in the current directory:

```bash
$ vagrant init
```

This will give you a `Vagrantfile` with basic configuration.  Replace this with something that looks like:

```ruby
Vagrant.configure(2) do |config|
  config.vm.define 'acs' do |acs|
    acs.vm.box = 'ubuntu/trusty64'
    acs.vm.hostname = 'acs'
    acs.vm.network 'private_network', ip: '192.168.33.10'
  end

  config.vm.define 'web' do |web|
    web.vm.box = 'nrel/CentOS-6.5-x86_64'
    web.vm.hostname = 'web'
    web.vm.network 'private_network', ip: '192.168.33.20'
    web.vm.network 'forwarded_port', guest: 80, host: 8080
  end

  config.vm.define 'db' do |db|
    db.vm.box = 'nrel/CentOS-6.5-x86_64'
    db.vm.hostname = 'db'
    db.vm.network 'private_network', ip: '192.168.33.30'
  end
end
```

#### Viewing currently running VMs

After running `vagrant up`, you can view the currently running VMs with:

```bash
$ vboxmanage list runningvms
# "hands-on-ansible_acs_1461016412618_97165" {18cb2835-6c21-4213-ad1c-1ba846094798}
# "hands-on-ansible_web_1461017084126_8766" {847735bb-296c-4856-bfb2-3b6623c07837}
# "hands-on-ansible_db_1461017121270_37496" {301b9106-0efe-4988-8f34-1b76942e3444}
```

#### SSH into a specific VM

You can log into a specific VM via SSH with:

```bash
$ vagrant ssh acs
```

## Installing Ansible

#### On Debian

You can use the `apt` package manager:

```bash
$ sudo apt-get install ansible
```

#### On CentOS

Make sure you have the enterprise release packages installed:

```bash
$ sudo yum install epel-release
```

Then install Ansible with yum:

```bash
$ sudo yum install ansible
```

#### On Mac

The preferred way to install ansible on a Mac is via `pip`.

To install `pip`:

```bash
$ sudo easy_install pip
```

To upgrade `pip`:

```bash
$ sudo pip install --upgrade pip
```

To install Ansible:

```bash
$ sudo pip install ansible
```

## Ansible command anatomy

```text
$ ansible <system>
  -i <inventory file>
  -m <module>
  -u <username>
  -k <password prompt>
  -v <or vv or vvv or vvvv = debug level>
  -a <arguments>
```

The module is the Ansible module you want to execute. The default is the `command` module.

## Running ping

On your control server, you need to create an inventory file with the IP addresses of the servers you want to talk to:

```bash
$ ssh vagrant acs
```

Create an inventory file:

```bash
acs$ cat < inventory
192.168.33.20
192.168.33.30
# ctrl-d
```

Then have Ansible run a ping command:

```bash
acs$ ansible 192.168.33.20 -i inventory -u vagrant -m ping -k
# 192.168.33.20 | success >> {
#     "changed": false,
#     "ping": "pong"
# }
```

This tells the Ansible binary where the inventory file is (current directory and it's a file named "inventory"), we're logging onto a server with the username of "vagrant", and we're executing the "ping" command with the `-k` flag.

You can run this command on all servers:

```bash
acs$ ansible all -i inventory -u vagrant -m ping -k
# 192.168.33.20 | success >> {
#     "changed": false,
#     "ping": "pong"
# }
# 192.168.33.30 | success >> {
#     "changed": false,
#     "ping": "pong"
# }
```

## Debug modes

There are different levels of debug.  Level 1 debug is `-v`, level 2 is `-vv`, and level 3 is `-vvv`.  The ping command only really provides information at level 3 debug:

```bash
acs$ ansible 192.168.33.20 -i inventory -u vagrant -m ping -k -vvv
# 192.168.33.20> ESTABLISH CONNECTION FOR USER: vagrant
# <192.168.33.20> REMOTE_MODULE ping
# <192.168.33.20> EXEC ['sshpass', '-d6', 'ssh', '-C', '-tt', '-q', '-o', 'ControlMaster=auto', '-o', 'ControlPersist=60s', '-o', 'ControlPath=/home/vagrant/.ansible/cp/ansible-ssh-%h-%p-%r', '-o', 'Port=22', '-o', 'GSSAPIAuthentication=no', '-o', 'PubkeyAuthentication=no', '-o', 'ConnectTimeout=10', '192.168.33.20', "/bin/sh -c 'mkdir -p  $HOME/.ansible/tmp/ansible-tmp-1461021240.6-70949762191242 && chmod a+rx $HOME/.ansible/tmp/ansible-tmp-1461021240.6-70949762191242 && echo $HOME/.ansible/tmp/ansible-tmp-1461021240.6-70949762191242'"]
# <192.168.33.20> PUT /tmp/tmpeJZyA7 TO /home/vagrant/.ansible/tmp/ansible-tmp-1461021240.6-70949762191242/ping
# <192.168.33.20> EXEC ['sshpass', '-d6', 'ssh', '-C', '-tt', '-q', '-o', 'ControlMaster=auto', '-o', 'ControlPersist=60s', '-o', 'ControlPath=/home/vagrant/.ansible/cp/ansible-ssh-%h-%p-%r', '-o', 'Port=22', '-o', 'GSSAPIAuthentication=no', '-o', 'PubkeyAuthentication=no', '-o', 'ConnectTimeout=10', '192.168.33.20', "/bin/sh -c '/usr/bin/python /home/vagrant/.ansible/tmp/ansible-tmp-1461021240.6-70949762191242/ping; rm -rf /home/vagrant/.ansible/tmp/ansible-tmp-1461021240.6-70949762191242/ >/dev/null 2>&1'"]
# 192.168.33.20 | success >> {
#     "changed": false,
#     "ping": "pong"
# }
```

## The inventory file

The inventory is where you set the addresses of the hosts you plan to configure.  lets say we have the following file named `inventory`:

```text
web1 web1.rpm.dev
web2 web2.rpm.dev
db1 db1.rpm.dev
```

With this in place, you can execute ping on the web1 server:

```bash
$ ansible web1 -i inventory -u vagrant -m ping -k
```

The inventory file allows you to group servers together to run commands on more than one server with a single ansible command.  Lets say you have the following `inventory` file, with a `webservers` group:

```text
web1 web1.rpm.dev
web2 web2.rpm.dev
db1 db1.rpm.dev

[webservers]
web1
web2
```

This allows you to execute this command:

```bash
$ ansible webservers -i inventory -u vagrant -m ping -k
```

You can also create groups of groups.  In this case you need to use the `children` modifier to let ansible know you are working with groups instead of webservers.  

Here we'll create a datacenter group:

```text
web1 web1.rpm.dev
web2 web2.rpm.dev
db1 db1.rpm.dev

[webservers]
web1
web2

[dbservers]
db1

[datacenter:children]
webservers
dbservers
```

#### Setting variables

You can set variables on a line by line basis:

```text
web1 web1.rpm.dev ssh_user=vagrant ssh_password=vagrant
```

You can also set group variables:

```text
[webservers:vars]
ssh_user=vagrant
ssh_password=vagrant
```

## Playbooks

Playbooks are the repeatable recipes you use to configure systems.  Playbooks are in yaml format, and you execute them with the `ansible-playbook command`.  

Lets say you have the playbook `my-app.yml`.  You would execute it like:

```bash
$ ansible-playbook my-app.yml
```

#### Hosts

A playbook starts by identifying the hosts you want to work with.  You can identify a single host, group of hosts, or a combination:

Single host:

```yaml
---
- hosts: web1
```

A group:

```yaml
---
- hosts: webservers
```

A combination:

```yaml
---
- hosts: webservers:dbservers
```

This last one will execute on servers in the webservers group *or* the in the dbservers group.

#### Users

The hosts directive is followed by the user you want to execute as:

```yaml
---
- hosts: webservers
  remote_user: root
```

This tells Ansible to run commands on the server as the root user for this playbook.

#### Tasks

The meat of a playbook is in it's tasks, where you use individual Ansible modules to configure your system:

```yaml
- hosts: webservers
  remote_user: root

  tasks:
    - name: System Config | Updating the MOTD
      template:
        src: "templates/motd.j2"
        dest: "/etc/motd"
```

Here we're using the template module to change the MOTD on the server.

If you have a number of tasks that are related, you can put them in a separate file and include them:

```yaml
- hosts: webservers
  remote_user: root

  tasks:
    - include_tasks: tasks/sytem-config.yml
```

##### Registers

You can use the output of one task in anther by using the register directive:

```yaml
tasks:
  - name: get current user
    command: whoami
    register: current_user

  - name: copy random file to current user's home directory
    file:
      src: files/random-file.txt
      dest: /home/{{ current_user }}/random-file.txt
```

##### Handlers

You can interact with services after a particular task has completed.  For example, once a configuration file is updated, a related service can be restarted:

```yaml
tasks:
  - name: nginx config file
    template:
      src: templates/nginx.conf.j2
      dest: /etc/nginx/sites-available/my-app
    notify: start Nginx service

handlers:
  - name: start Nginx service
    service: name=nginx state=restarted
```

Here, the nginx service is restarted if the my-app configuration file is changed.

#### Vars

You can create variables in your playbooks, and use them with Jinja template syntax:

```yaml
- hosts: webservers
  remote_user: root
  vars:
    app_path: /home/deploy/my-app
    app_shared_path: {{ app_path }}/shared

  tasks:
    - name: MyApp | setting up app shared logs directory  
      path={{ app_shared_path }}/config
      state=directory
      recurse=true  
```

## SSH agent forwarding

This allows you to do things like check out code from a remote repository on GitHub, using the public key on your own system.  This way you don't need to setup an SSH keypair on remote machines and then add the public key to GitHub as a deploy key.  

In order to use agent forwarding, you need to run this on your local machine:

```bash
$ ssh-add
```

Then in you `~/.ssh/config` file, you can add the following:

```text
Host *.rpm.
  ForwardAgent yes
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
```

## Vaults

To create a vault file:

```bash
$ ansible-vault create foo.yml --vault-password-file ~/.vault_pass.txt
```

Edting a vault:

```bash
$ ansible-vault edit foo.yml --vault-password-file ~/.vault_pass.txt
```

## Tags

You can add tags to tasks, and you can run only tasks with specified tasks for a playbook.  For example, I needed to run this one task multiple times to get the regex and the process restarting to work propery:

```text
- name: Postgres | Give deploy user password access to db
  become: yes
  replace: dest='/etc/postgresql/9.3/main/pg_hba.conf' regexp='^(local\s*all\s*all\s*)(peer)$' replace='\1md5'
  notify: 
    - restart postgresql
  tags:
    - appdb
```

With the tag `appdb` added to the task, I can run it like:

```bash
$ ansible-playbook·-i·inventory.local·app-server.yml --tags appdb
```

This only runs these tasks tagged with `appdb`.
## Resources

* http://hakunin.com/six-ansible-practices
* SSH Agent forwarding with capistrano: http://dchua.com/2013/08/29/properly-using-ssh-agent-forwarding-in-capistrano/
