# Ansible-discourse

Provisioning [Discourse](https://github.com/discourse/discourse) with Vagrant, Ansible and [Discourse Docker](https://github.com/discourse/discourse_docker)


## Requirements

* Vagrant (tested with *1.8.1*)
* Ansible (tested with *1.9.3*)


## Basic Setup

1) Clone this project:

```
git clone git@github.com:xpeppers/ansible-discourse.git
```

2) Add an entry to your `/etc/hosts` file that maps the domain `discourse.dev` to the IP of the virtual machine:

```
192.168.11.3    discourse.dev
```

3) Start the virtual machine with vagrant:

```
vagrant up
```

4) Install the ansible roles (execute from the host machine):

```
[sudo] ansible-galaxy install -r requirements.yml
```

5) Configure Discourse (from the host machine)

Clone [Discourse Docker](https://github.com/discourse/discourse_docker) to properly configure your Discourse installation:

```
git clone git@github.com:discourse/discourse_docker.git
```

Copy the configuration file `discourse_docker/samples/standalone.yml`:

```
cp discourse_docker/samples/standalone.yml discourse_docker/containers/app.yml
```

6) Edit the file `app.yml` accordingly to your setup (hostname, stmp settings, etc.)

6b) For the production machine setup, if you are using HTTPS, place the SSL key and certificate under `playbooks/roles/discourse/files/` and name the files `ssl.key` and `ssl.crt` and uncomment the line with `templates/web.ssl.template.yml` in `app.yml` to enable HTTPS. (Reference: [Allowing SSL / HTTPS for your Discourse Docker setup](https://meta.discourse.org/t/allowing-ssl-https-for-your-discourse-docker-setup/13847))

7) (Optional) Configure backup:

```
cp playbooks/roles/discourse/files/backup.cron.template.sh playbooks/roles/discourse/files/backup.cron.sh
```

Fill the API key in `backup.cron.sh` with the key you find here: https://<DISCOURSE_HOST>/admin/api/keys

8) (Optional) If you want to change the default (`/var/discourse`) installation directory of Discourse, you can change the value in `playbooks/vars/main.yml` and change the value of volumes in `app.yml` too.


## Provisioning

Provision with

```
# Vagrant host
scripts/provision_vagrant
# or
scripts/provision_vagrant_only_machine
# or
scripts/provision_vagrant_only_discourse

# AWS host
scripts/provision_aws
# or
scripts/provision_aws_only_machine
```


## Utility scripts

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


## Useful resources

* [How to create an administrator account after install](https://meta.discourse.org/t/how-to-create-an-administrator-account-after-install/14046)


## Notes

Ansibles `gather_facts` cannot be disabled.



## (Un)License

All information is public content.
