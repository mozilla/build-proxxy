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

    vagrant up
    vagrant ssh
    cd /opt/proxxy
    inv docker_build  # build a Docker image
    inv docker_run    # run a Docker container from an image


Production workflow
--------------------

The main config is at `ansible/group_vars/vagrant`, encrypted using
[Ansible Vault](http://docs.ansible.com/playbooks_vault.html).

View / edit secrets in $EDITOR:

    ansible-vault edit --vault-password-file=.vaultpass ansible/group_vars/vagrant

Then:

    vagrant provision
    vagrant ssh
    cd /opt/proxxy

Build a fresh AMIs using Packer in all supported regions:

    inv packer_build

Optionally you can build a fresh AMI in a specific region:

    in packer_build --region=<region>

**The following steps should be performed for all supported regions (`us-east-1` and `us-west-2`).**

You can see the list of Proxxy AMIs:

    inv list_images --region=<region>

You should test a freshly built AMI:

    inv launch_instance <ami-id> --region=<region>

When done, destroy testing instance:

    inv destroy_instance <instance-id> --region=<region>

Update production autoscaling group's launch configuration with the new AMI:

    inv update_asg <ami-id> --region=<region>

Next, perform a rolling restart of all instances in autoscaling group to make use of new AMI launch configuration:

    inv rotate_asg --region=<region>

You can manually destroy old AMIs:

    inv destroy_image <ami-id> --region=<region>

Or just perform an automatic AMI cleanup - by default this will keep 3 most recent AMIs:

    inv cleanup_images --region=<region>
