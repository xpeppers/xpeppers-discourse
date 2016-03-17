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

Configure Discourse by

```
cp discourse/samples/standalone.yml discourse/containers/app.yml
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

(Grab the container id first)

```
ansible discourse -i inventory/aws_hosts --private-key ~/.ssh/xpeppers/discourse.pem  -u ubuntu -m command -a "sudo docker ps"

ansible discourse -i inventory/aws_hosts --private-key ~/.ssh/xpeppers/discourse.pem  -u ubuntu -m command -a "sudo docker logs CONTAINER-ID"
```





# Notes

Ansibles `gather_facts` cannot be disabled.
