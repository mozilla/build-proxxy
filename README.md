proxxy
======

Directories
-----------

* `app` - the app code itself
* `eb` - [Elastic Beanstalk](http://aws.amazon.com/elasticbeanstalk/) files
* `packer` - [Packer](http://www.packer.io/) files


Requirements
------------

If you want to build an AMI using Packer, you'll need the following environment variables set on the **host** machine:

* `AWS_ACCESS_KEY`
* `AWS_SECRET_KEY`
* `EC2_CERT` - path to EC2 certificate file (`ec2-cert.pem`)
* `EC2_PRIVATE_KEY` - path to EC2 private key (`ec2-pk.pem`)

[About AWS Security Credentials](http://docs.aws.amazon.com/AWSSecurityCredentials/1.0/AboutAWSCredentials.html).

These variables and files will be transferred into VM during provisioning.


Usage
-----

    vagrant up
    vagrant ssh
    cd /vagrant

Then:

* `make docker-build` - build a Docker container
* `make docker-run` - run Docker image from container
* `make docker-push` - publish Duilt docker container to public registry
* `make packer-build` - build an AWS AMI using Packer
