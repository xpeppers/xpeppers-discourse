Simple ec2 in autoscaling 1:1
=============================

This template creates an EC2 instance in autoscaling group 1:1 with security group and role associated with them.
By default the script create ubuntu 16.04, but changing the AMI it's possible to change it

# How to run
```
aws cloudformation create-stack --profile xpeppers-produzione --stack-name application-tier-discourse-v4 --template-body file://application-tier.yml --parameters file://application-tier-parameters.json --region=eu-west-1 --capabilities CAPABILITY_IAM

aws cloudformation create-stack --profile xpeppers-produzione --stack-name rds-discourse-v4 --template-body file://rds.yml --parameters file://rds-parameters.json --region=eu-west-1 --capabilities CAPABILITY_IAM

aws cloudformation create-stack --profile xpeppers-produzione --stack-name vpc-v4 --template-body file://vpc.yml --parameters file://vpc-parameters.json --region=eu-west-1 --capabilities CAPABILITY_IAM
```