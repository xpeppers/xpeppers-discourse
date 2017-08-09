# Ansible-discourse

Provisioning [Discourse](https://github.com/discourse/discourse) with Vagrant, Ansible and [Discourse Docker](https://github.com/discourse/discourse_docker)


## Requirements

* Vagrant (tested with *1.8.1*)
* Ansible (tested with *1.9.3*)


## Basic Setup

1) Clone this project:

```
git clone --recursive git@github.com:xpeppers/ansible-discourse.git
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

5) Edit playbooks/roles/discourse/files/app.yml file filling <> parameters:

6) (Optional) Configure backup:

```
cp playbooks/roles/discourse/files/backup.cron.template.sh playbooks/roles/discourse/files/backup.cron.sh
```

Fill the API key in `backup.cron.sh` with the key you find here: https://<DISCOURSE_HOST>/admin/api/keys

7) (Optional) If you want to change the default (`/var/discourse`) installation directory of Discourse, you can change the value in `playbooks/vars/main.yml` and change the value of volumes in `app.yml` too.


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

# Deployment on AWS

## Prerequisities

1. aws cli
2. aws access key and secret key with administrator permission
3. packer
4. ansible (tested with 2.3.0)

## Run

1. Run packer and build AMI: ```packer build -var 'aws_access_key=<ACCESS_KEY>' -var 'aws_secret_key=<SECRET_KEY>' packer-silver-image.json```
2. Copy ami id created with packer
3. Edit cloudformation/ec2-parameters.json file
4. Launch cloudformation: ```aws cloudformation create-stack --profile PROFILE_NAME --stack-name STACK_NAME --template-body file://cloudformation/ec2.yaml --parameters file://cloudformation/ec2-parameters.json --region REGION --capabilities CAPABILITY_IAM```
5. To update an existing stack: ```aws cloudformation update-stack --profile PROFILE_NAME --stack-name STACK_NAME --template-body file://cloudformation/ec2.yaml --parameters file://cloudformation/ec2-parameters.json --region REGION --capabilities CAPABILITY_IAM```

## Useful resources

* [How to create an administrator account after install](https://meta.discourse.org/t/how-to-create-an-administrator-account-after-install/14046)
* [Setting up file and image uploads to S3](https://meta.discourse.org/t/setting-up-file-and-image-uploads-to-s3/7229)
* [Setting up Discourse on AWS](http://dev.bizo.com/2014/06/discourse-on-aws.html)

## Notes

Ansibles `gather_facts` cannot be disabled.



## (Un)License

All information is public content.
