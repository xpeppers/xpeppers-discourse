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
cp playbooks/files/discourse/samples/standalone.yml playbooks/files/discourse/containers/app.yml
```

and edit this file accordingly to your configuration.

---

Provision with

```
scripts/provision_vagrant

# or

scripts/provision_aws
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
```





# Notes

Ansibles `gather_facts` cannot be disabled.
