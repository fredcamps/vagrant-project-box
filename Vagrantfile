# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"


Vagrant::configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box_url = "file://" + File.dirname(__FILE__) + "/box/trusty-server-amd64.box"
    config.vm.box = "manager"
    config.vm.hostname = "manager"
    #config.vm.network "private_network", ip: "192.168.33.102"
    #config.vm.network "public_network", ip: "192.168.33.102"
    #config.vm.network "private_network", type: "dhcp"
    config.vm.network "public_network", type: "dhcp"
    config.vm.synced_folder "./data", "/vagrant"

    config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end

    if Vagrant.has_plugin?("vagrant-hostmanager")
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
        config.hostmanager.ignore_private_ip = false
        config.hostmanager.include_offline = true
        config.hostmanager.aliases = ["manager.docs", "gitlab.manager.docs", "redmine.manager.docs"]
    end

    if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :machine # :machine or :box
    end

    config.vm.provision :shell, path: "scripts/base.sh"
    config.vm.provision :shell, path: "scripts/postfix.sh"
    config.vm.provision :shell, path: "scripts/mysql.sh"
    config.vm.provision :shell, path: "scripts/redmine.sh"
    config.vm.provision :shell, path: "scripts/gitlab.sh"
end
