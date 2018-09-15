Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
  config.vm.define "web" do |web|
    config.vm.network "private_network", ip: "192.168.33.101"
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook_web.yml"
    end
  end
  config.vm.define "other" do |other|
    config.vm.network "private_network", ip: "192.168.33.102"
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook_other.yml"
    end
  end
end
