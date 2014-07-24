proxxy
======

Directories
-----------

* `app` - the app code itself
* `ansible` - [Ansible](http://docs.ansible.com/) files
* `packer` - [Packer](http://www.packer.io/) files


Requirements
------------

* [Ansible 1.6+](http://docs.ansible.com/)
* [Vagrant 1.6+](http://www.vagrantup.com/)
* Ansible Vault password in `.vaultpass` file


Development / testing
---------------------

    $ vagrant up
    $ vagrant ssh
    $ cd /opt/proxxy
    $ make docker-build     # build a Docker image
    $ make docker-run       # run a Docker container from an image


Building a fresh AMI
--------------------

The main config is at `ansible/group_vars/vagrant`, encrypted using
[Ansible Vault](http://docs.ansible.com/playbooks_vault.html).

View / edit secrets in $EDITOR:

    $ ansible-vault edit --vault-password-file=.vaultpass ansible/group_vars/vagrant

Then:

    $ vagrant provision
    $ vagrant ssh
    $ cd /opt/proxxy
    $ make packer-build

You should see AMI IDs when the build is complete.

Packer build can sometimes freeze; you can hit `^C` and wait for Packer to
clean up temporary EC2 keypair and security group, then try again.


Upgrading Production to use a fresh AMI
---------------------------------------

    $ vagrant ssh
    $ cd /opt/proxxy

First, do some smoke tests on a fresh AMI:

    $ invoke launch_instance ami-5cb47c34 --region=us-east-1
    Reservation: Reservation:r-96a599e7
    Instance: Instance:i-09d19d25
    Instance state: pending
    Instance state: pending
    [...]
    Instance state: pending
    Instance state: running
    You can now SSH into this server with ubuntu@54.237.177.70

Don't forget to kill the instance when you're done:

    $ invoke destroy_instance i-09d19d25 --region=us-east-1
    Result: [Instance:i-09d19d25]

Then, update AutoScalingGroup with the new AMI:

    $ invoke update_asg ami-5cb47c34 --region=us-east-1
    Old Launch Configuration: LaunchConfiguration:proxxy-ami-a623eace
    New Launch Configuration: LaunchConfiguration:proxxy-ami-5cb47c34
    Done

And perform a rolling upgrade of all instances (will take some time):

    $ invoke rotate_asg --region=us-east-1
    Temporarily increasing desired capacity to 3
    Instances: [Instance<id:i-5c767376, state:InService, health:Healthy>]
    Healthy Instances: [Instance<id:i-5c767376, state:InService, health:Healthy>]
    Need at least 3 instances in service to continue, got 1, waiting...
    Instances: [Instance<id:i-5c767376, state:InService, health:Healthy>, Instance<id:i-9fe5a9b3, state:Pending, health:Healthy>, Instance<id:i-57dad07c, state:Pending, health:Healthy>]

    [...last 4 lines repeat for couple of mins...]

    Terminating instance i-5c767376

    [...again, those 4 lines repeat for couple of mins...]

    Decreasing desired capacity back to 1
    Done
