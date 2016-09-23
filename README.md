# ansible-discourse

example repo to provision of a machine to host the discourse platform



### Requirements

- vagrant (tested with *1.8.1*)
- Ansible (tested with *1.9.3*)



# Basic Setup

1) Add an entry to your `/etc/hosts` file that maps the domain `discourse.dev` to the IP of the virtual machine:

```
192.168.11.3    discourse.dev
```

2) Start the virtual machine with vagrant:

```
vagrant up
```

3) Install the ansible roles (execute from the host machine):

```
[sudo] ansible-galaxy install -r requirements.yml
```

4) Configure Discourse (from the host machine)

```
cp playbooks/roles/discourse/files/discourse/samples/standalone.yml playbooks/roles/discourse/files/app.yml
cp playbooks/roles/machine/files/backup.cron.template.sh playbooks/roles/machine/files/backup.cron.sh
```

5) Edit the files accordingly to your setup (hostname, stmp settings, etc.)

5a) For the development machine setup with vagrant, comment the line with `templates/web.ssl.template.yml` in `app.yml` to disable HTTPS

5b) For the production machine setup, if you are using HTTPS, place the SSL key and certificate under `playbooks/roles/discourse/files/` and name the files `ssl.key` and `ssl.crt`

6) Fill the API key in `backup.cron.sh` with the key you find here: https://<DISCOURSE_HOST>/admin/api/keys


# Provisioning

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


# Utility scripts

### Manual/Automatic Backups

Run this command to trigger a backup:

```
scripts/cmd_aws "sudo sh /home/discourse/backup.cron.sh"
```

Additionally there is a cron configured that runs automatic backups at 9:00, 14:00 and 20:00. For additional configuration see `playbooks/roles/discourse/tasks/main.yml`.



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



# (Un)License

All information is public content.
