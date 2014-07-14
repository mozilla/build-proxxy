proxxy
======

Directories
-----------

* `app` - the app code itself
* `packer` - [Packer](http://www.packer.io/) files


Requirements
------------

* [Ansible 1.6+](http://docs.ansible.com/)
* [Vagrant 1.6+](http://www.vagrantup.com/)


Development
-----------

The main config is at `ansible/group_vars/vagrant`.

    $ vagrant up
    $ vagrant ssh
    $ cd /opt/proxxy

Then:

* `make docker-build` - build a Docker image
* `make docker-run` - run a Docker container from an image

Building an AMI
---------------

The main config is at `ansible/group_vars/vagrant-secrets`, encrypted using
[Ansible Vault](http://docs.ansible.com/playbooks_vault.html).

First, provision a fresh VM with secrets (will ask for vault password):

    $ SECRETS=1 vagrant up

Then:

    $ vagrant ssh
    $ cd /opt/proxxy
    $ make packer-build

You should see an AMI ID when the build is complete.
