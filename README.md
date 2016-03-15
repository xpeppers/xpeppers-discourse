# ansible-discourse

example repo to provision of a machine to host the discourse platform

## Requirements

- vagrant (tested with *1.8.1*)




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
