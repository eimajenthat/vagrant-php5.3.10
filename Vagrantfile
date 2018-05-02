# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "ubuntu/precise64"

    config.vm.network :private_network, ip: "10.5.5.5"
    config.vm.network :forwarded_port, guest: 22, host: 7762

    config.vm.provision :shell, :path => "install.sh"

    config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777", "fmode=666"]

    # If true, then any SSH connections made will enable agent forwarding.
    # Default value: false
    # config.ssh.forward_agent = true

    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.

    # Share project code
    config.vm.synced_folder "../", "/code", group: 'www-data', owner: 'www-data', mount_options: ["dmode=775", "fmode=764"]
end
