# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"

  config.vm.provision :shell, :path => "scripts/setup.sh"

  config.vm.network :forwarded_port, host: 4000, guest: 4000
  config.vm.network :forwarded_port, host: 80, guest: 8080
  config.vm.network :forwarded_port, host: 8888, guest: 8888

  config.ssh.insert_key = true

  config.vm.synced_folder '.', '/c2c-elixir'
  
  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--name", "c2c-elixir"]
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
  end
end
