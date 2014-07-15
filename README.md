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


Development / testing
---------------------

The main config is at `ansible/group_vars/vagrant`.

First, add the following line to `/etc/hosts`:

    10.0.31.2   proxxy.dev

Then:

    $ vagrant up
    $ vagrant ssh
    $ cd /opt/proxxy
    $ make docker-build     # build a Docker image
    $ make docker-run       # run a Docker container from an image


Building an AMI
---------------

The main config is at `ansible/group_vars/vagrant-secrets`, encrypted using
[Ansible Vault](http://docs.ansible.com/playbooks_vault.html).

View / edit secrets in $EDITOR:

    $ ansible-vault edit ansible/group_vars/vagrant-secrets

Provision a fresh VM with secrets (will ask for vault password):

    $ SECRETS=1 vagrant up

Then:

    $ vagrant ssh
    $ cd /opt/proxxy
    $ make packer-build

You should see an AMI ID when the build is complete.

Packer build can sometimes freeze; you can hit `^C` and wait for Packer to
clean up temporary EC2 keypair and security group, then try again.
