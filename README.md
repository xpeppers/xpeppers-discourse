# ansible-discourse

example repo to provision of a machine to host the discourse platform

## Requirements

- vagrant (tested with *1.8.1*)
- Ansible (tested with *1.9.3*)


## Installation

Add an entry to your hosts file that maps the domain `discourse.dev` to the IP of the virtual machine:

```
192.168.11.3    discourse.dev
```

---

Create the virtual machine with vagrant:

```
vagrant up
```

---

Install the ansible roles:

```
[sudo] ansible-galaxy install -r requirements.yml
```

---

**IMPORTANT:**

Configure Discourse with

```
cp playbooks/roles/discourse/files/discourse/samples/standalone.yml playbooks/roles/discourse/files/app.yml
cp playbooks/roles/discourse/files/backup.cron.template.sh playbooks/roles/discourse/files/backup.cron.sh
```

and edit the files according to your configuration.

*Note: Ansible keeps track of changes to this file, and rebuilds the discourse installation accordinglt, as described [here](https://github.com/discourse/discourse/blob/master/docs/INSTALL-cloud.md#email-is-important)*

---

**This is a required step to provision the production machine**

Place the production ssl key and certificate under `playbooks/roles/discourse/files/` with the names:

`ssl.key` and `ssl.crt`

**XPeppers SSH Key**

Grab the PEM for XPeppers discourse from a coworker. Place it in `~/.ssh/xpeppers/discourse.pem`

---

Provision with

```
# Vagrant host
scripts/provision_vagrant
# or
scripts/provision_vagrant_only_machine

# AWS host
scripts/provision_aws
# or
scripts/provision_aws_only_machine
```

### Backup Discourse

```
scripts/cmd_aws "sudo sh /home/discourse/backup.cron.sh"
```


### Gather info about the machine

```
scripts/info_vagrant

# or

scripts/info_aws
```





### Machine logs

```
scripts/logs_vagrant

# or

scripts/logs_aws
```







### Execute arbitrary commands

```
scripts/cmd_aws "ls -lh /var/discourse"
scripts/cmd_aws "sudo docker ps"

scripts/cmd_aws [YOUR-PEM-LOCATION] "sudo docker ps"
```





# Notes

Ansibles `gather_facts` cannot be disabled.
