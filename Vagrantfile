# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "proxxy.dev"

  config.vm.provision "docker"
  config.vm.provision "shell", inline: <<-SCRIPT
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    apt-get install -y unzip
    cd /tmp
    wget -q https://dl.bintray.com/mitchellh/packer/0.6.0_linux_amd64.zip
    unzip -d /usr/local/bin 0.6.0_linux_amd64.zip
  SCRIPT

  config.vm.provision "shell", inline: <<-SCRIPT
    echo "" > /etc/profile.d/aws.sh
  SCRIPT

  # copy AWS_ACCESS_KEY and AWS_SECRET_KEY from host to guest
  if ENV.key?('AWS_ACCESS_KEY') and ENV.key?('AWS_SECRET_KEY')
    config.vm.provision "shell", inline: <<-SCRIPT
      echo 'export AWS_ACCESS_KEY="#{ENV['AWS_ACCESS_KEY']}"' >> /etc/profile.d/aws.sh
      echo 'export AWS_SECRET_KEY="#{ENV['AWS_SECRET_KEY']}"' >> /etc/profile.d/aws.sh
    SCRIPT
  end

  # copy EC2_CERT and EC2_PRIVATE_KEY from host to guest
  if ENV.key?('EC2_CERT') and ENV.key?('EC2_PRIVATE_KEY')
    config.vm.provision "shell",
      inline: "mkdir -p ~/.ec2",
      privileged: false

    config.vm.provision "file",
      source: ENV['EC2_CERT'],
      destination: "~/.ec2/cert.pem"

    config.vm.provision "file",
      source: ENV['EC2_PRIVATE_KEY'],
      destination: "~/.ec2/pk.pem"

    config.vm.provision "shell", inline: <<-SCRIPT
      echo 'export EC2_CERT="/home/vagrant/.ec2/cert.pem"' >> /etc/profile.d/aws.sh
      echo 'export EC2_PRIVATE_KEY="/home/vagrant/.ec2/pk.pem"' >> /etc/profile.d/aws.sh
    SCRIPT
  end
end
