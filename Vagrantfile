Vagrant.configure("2") do |config|
  config.vm.box = "roboxes/ubuntu1804"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
  config.vm.define "controller-0" do |controller0|
    config.vm.network "private_network", ip: "192.168.33.104"
    config.vm.network "public_network"
    config.vm.provision :shell, path: "bootstrap.sh"
    config.vm.provision "setup", type: "ansible" do |ansible|
      ansible.playbook = "playbook_controller.yml"
    end
  end
  config.vm.define "worker-0" do |worker0|
    config.vm.network "private_network", ip: "192.168.33.101"
    config.vm.network "public_network"
    config.vm.provision :shell, path: "bootstrap.sh"
    config.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "playbook_worker.yml"
    end
  end
  config.vm.define "worker-1" do |worker1|
    config.vm.network "private_network", ip: "192.168.33.102"
    config.vm.network "public_network"
    config.vm.provision :shell, path: "bootstrap.sh"
    config.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "playbook_worker.yml"
    end
  end
  config.vm.define "worker-2" do |worker2|
    config.vm.network "private_network", ip: "192.168.33.103"
    config.vm.network "public_network"
    config.vm.provision :shell, path: "bootstrap.sh"
    config.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "playbook_worker.yml"
    end
  end
end
