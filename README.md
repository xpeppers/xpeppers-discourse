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

Provision the vagrant machine:

```
ansible-playbook -i inventory/vagrant_hosts  main.yml --private-key ~/.vagrant.d/insecure_private_key -u vagrant -vvvv
```





### Gather info about the machine

```
ansible discourse -i inventory/vagrant_hosts --private-key ~/.vagrant.d/insecure_private_key -u vagrant -m setup
```


# Notes

Ansibles `gather_facts` cannot be disabled.
