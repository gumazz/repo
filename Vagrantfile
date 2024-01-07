# -*- mode: ruby -*- 
# vi: set ft=ruby : vsa
Vagrant.configure(2) do |config| 
 config.vm.box = "centos/7" 
 config.vm.provider "virtualbox" do |v| 
 v.memory = 1024 
 v.cpus = 2
 end 
 config.vm.define "rpms" do |rpms| 
 rpms.vm.network "private_network", ip: "192.168.50.10",  virtualbox__intnet: "net1" 
 rpms.vm.hostname = "rpms" 
 rpms.vm.provision "shell", path: "rpms_prepare.sh"
 end 
end 
