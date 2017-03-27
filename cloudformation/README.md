Simple ec2 in autoscaling 1:1
=============================

This template creates an EC2 instance in autoscaling group 1:1 with security group and role associated with them.
By default the script create ubuntu 16.04, but changing the AMI it's possible to change it

# How to run
```
aws cloudformation create-stack --profile xpeppers-test --stack-name discourse-test --template-body file://ec2.yml --parameters file://ec2-parameters.json --capabilities CAPABILITY_IAM
```