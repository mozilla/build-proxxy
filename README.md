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


Building an AMI
---------------

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
