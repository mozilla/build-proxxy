proxxy
======

Directories
-----------

* `ansible` - [Ansible](http://docs.ansible.com/) files
* `packer` - [Packer](http://www.packer.io/) files


Requirements
------------

* [Ansible 1.6+](http://docs.ansible.com/)
* [Vagrant 1.6+](http://www.vagrantup.com/)
* [Packer 0.6+](http://www.packer.io/) (only for generating production AMIs)
* Ansible Vault password in `.vaultpass` file


Development / testing
---------------------

First, add the following lines to your `/etc/hosts`:

    # proxxy
    10.0.31.2       proxxy.dev
    10.0.31.2       es.proxxy.dev
    10.0.31.2       ftp.mozilla.org.proxxy.dev

Next, run `vagrant up`.
That will boot up a fresh VM and install / launch Proxxy.

Proxxy is automatically provisioned by applying the following Ansible role: `ansible/roles/proxxy`
When you modify it, you should reprovision the VM using `vagrant provision` to see your changes.

You can visit [ftp.mozilla.org.proxxy.dev](http://ftp.mozilla.org.proxxy.dev) to
check that Proxxy works.

You can then visit [es.proxxy.dev](http://es.proxxy.dev) to see
nginx log entries in [Kibana](http://www.elasticsearch.org/overview/kibana/).

Production workflow
-------------------

Both Proxxy and Kibana+Elasticsearch are installed in the same VM in development,
but in production you'll want to have two separate VMs.

First, destroy existing development VM, if present:

    vagrant destroy -f

Next, create a fresh VM without provisioning:

    vagrant up --no-provision

The production config is at `ansible/group_vars/production`, encrypted using
[Ansible Vault](http://docs.ansible.com/playbooks_vault.html).

View / edit secrets in $EDITOR:

    ansible-vault edit --vault-password-file=.vaultpass ansible/group_vars/vagrant

Provision the VM using Packer.
**Please keep in mind that this VM will be provisioned with production secrets,
so please keep it private!**

    cd packer
    packer build -only vagrant elasticsearch.json
    # OR
    packer build -only vagrant proxxy.json

You should apply either elasticsearch or proxxy template and test those services separately.

Once you've checked that VM works fine, you can build fresh production AMIs like this:

    packer build -except vagrant elasticsearch.json
    packer build -except vagrant proxxy.json

Both elasticsearch and proxxy produce multiple AMIs, one per region.
You can generate AMI for a specific region like this:

    packer build -only ec2-usw2 proxxy.json

Once the AMIs are built, launch them, test them and rebind Elastic IPs
to put them into service.
