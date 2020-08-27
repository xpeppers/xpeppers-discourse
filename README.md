XPeppers Discourse
==================

Provisioning [Discourse](https://github.com/discourse/discourse) with packer and AWS

# Deployment on AWS
Deployment on AWS is managed by cloudformation and all paramters are store on SSM.

## Prerequisities

1. [AWS CLI](https://aws.amazon.com/cli/)
2. Have AWS access key and secret key with proper administrator permissions
3. [Packer](https://www.packer.io/)

## Cloudformation Template
Here the cloudformation templates present in _cloudformation_ folder:

* _application-tier.yml_: application load balancer, autoscaling with golden AMI and route53 record set
* _blue-green-update-codepipeline.yml_: codepipeline and codebuild
* _rds.yml_: postgres database
* _vpc.yml_: vpc and all related resources
* _ssm-parameters.yml_: all ssm parameters used by the other template

## First installation
The first 3 steps are necessary only the first time you init the project.
1. Create an empty RDS with version v0 using the template
2. Populate file _ssm-parameters-default-value.json_ that creates all parameters used by pipeline.
3. Create pipeline using _blue-green-update-codepipeline.yml_
4. Run pipeline

All the next deployment will be managed by codepipeline and the previous step are no more necessary.

## Blue-Green deployment

Steps to follow to update a new version of discourse

### Creation of green environment
1. Read-only mode on discourse: `admin->backup->Enable readonly`
2. Create RDS snapshot of the discourse database
3. Edit parameters in _rds-parameters.json_ updating the snapshot name and db version
4. Create new RDS: :warning: use the same version set before in the stack name: `aws cloudformation create-stack --profile xpeppers --stack-name discourse-rds-v10 --template-body file://rds.yml --region eu-west-1 --enable-termination-protection --capabilities CAPABILITY_NAMED_IAM --parameters file://rds-parameters.json`
5. Wait the database is created and ready :coffee:
6. Are you sure the database is ready?
7. Run packer changing AWS_MFA and DB_URL value: `AWS_PROFILE=xpeppers AWS_MFA=752390 DB_URL='discoursedb-v11.xpeppers.com.' packer build packer-silver-image.json`
8. Wait again packer finishing
9. Get the AMI id resulting in the previous packer build
10. Change parameters in _application-tier-parameters.json_: EnvironmentVersion and AMIid, using a progressive number for version and the previous command AMI id
11. Create application layer with cloudformation: :warning: use the same version set before in the stack name: `aws cloudformation create-stack --profile xpeppers --stack-name discourse-application-tier-v5 --template-body file://application-tier.yml --region eu-west-1 --capabilities CAPABILITY_NAMED_IAM --parameters file://application-tier-parameters.json`

### Testing the green environment
1. Resolve the DNS of the new create load balancer: `dig +short ALB-discourse-v5-596837878.eu-west-1.elb.amazonaws.com` and copy one of the IPs
2. Open your local _/etc/hosts_ file and append this line: `<ip_previous_command> discourse.xpeppers.com`
3. Open a new browser and try to connect to discourse.xpeppers.com checking if the answer are coming from the previous address and checking if the new version is ok
4. If ok go to the next steps

### Switching the environment
1. Go to route53 and open xpeppers.com hosted zone name
2. Change the value of record discourse.xpeppers.com setting the alias of the new load balancer version
3. Disable read-only mode and try again to pusblish something and navigate
4. Evaluate if perform a rollback or the keep the new version. This evaluation could be done in some hours of works

### Rollback
If new version doesn't work correctly revert the previous version:

1. Go to route53 and open xpeppers.com hosted zone name
2. Change the value of record discourse.xpeppers.com setting the alias of the OLD load balancer version
3. Some contents should be lost

### New version is ok
If the new version is ok and you are sure to delete the old version:

1. Delete the old application cloudformation stack
2. Delete the old RDS cloudformation stack

# Discourse operations

## Enable-Disable read mode da cli:
1. Enter into instance console
2. `cd /var/discourse`
3. `sudo ./launcher enter app`
4. `RAILS_ENV=production bundle exec rails c`
5. `Discourse.disable_readonly_mode(Discourse::USER_READONLY_MODE_KEY)`
6. [Link](https://meta.discourse.org/t/stuck-in-read-only-mode/42820)

## Change secret azure app
1. Enter into instance console
2. `cd /var/discourse`
3. `sudo ./launcher enter app`
4. `RAILS_ENV=production bundle exec rails c`
5. In the rails console:
```
s = SiteSetting.find_by(name: 'office365_secret')
s.value='<new-token>'
s.save!
```

## Change database password
The next steps are to change the password of postgres and update it directly inside container but it's temporary solution becuase the container gets password externally.
To a have a final solution you must rebuild container app.

1. Enter the instance
2. `cd /var/discourse`
3. `psql -U discourse -h <db-url>`
4. into postgres db: `\password discourse`
5. Set new password and exit `\q`
6. `sudo ./launcher enter app`
7. Update password in file `config/discourse.conf`
8. Restart rails: `rails restart`
9. Rebuild container or instance with new password
