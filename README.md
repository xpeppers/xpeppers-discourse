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

Configure Discourse by

```
cp discourse/samples/standalone.yml discourse/containers/app.yml
```

and edit this file accordingly to your configuration.

---

Provision the vagrant machine:

```
ansible-playbook playbooks/main.yml -i inventory/vagrant_hosts --private-key ~/.vagrant.d/insecure_private_key -u vagrant -vvvv
```

Provisiong the ec2 instance

```
ansible-playbook playbooks/main.yml -i inventory/aws_hosts --private-key ~/.ssh/YOUR_AWS.pem -u ubuntu -vvvv
```




### Gather info about the machine

```
ansible discourse -i inventory/vagrant_hosts --private-key ~/.vagrant.d/insecure_private_key -u vagrant -m setup
```


# Notes

Ansibles `gather_facts` cannot be disabled.
