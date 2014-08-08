# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "proxxy.dev", primary: true

  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "proxxy.dev"
  config.vm.network "private_network", ip: "10.0.31.2"
  config.vm.synced_folder ".", "/opt/proxxy", :nfs => true

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "ansible/all.yml"
    ansible.inventory_path = "ansible/vagrant.ini"
    ansible.limit = "all"
  end
end
