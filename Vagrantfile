Vagrant.configure(2) do |config|
	config.vm.box = "centos/7"
	config.vm.box_check_update = false
	config.vm.post_up_message = "Hi. This is sucsessfull install of virtual machine to lesson2 by OTUS-linux"
	
	config.vm.define "lesson2" do |lesson2|
		lesson2.vm.hostname = "lesson2"
		lesson2.vm.network "private_network", ip: "10.0.0.5"

		config.vm.provider "virtualbox" do |vb|
			vb.name = "lesson2"
			vb.memory = "768"
			vb.cpus = 1

			sata1 = '../sata1.vdi'
			sata2 = '../sata2.vdi'
			sata3 = '../sata3.vdi'
			sata4 = '../sata4.vdi'
			 
			needsController = false 

			unless File.exist?(sata1)
				vb.customize ['createhd', '--filename', sata1, '--size', 500]
				needsController = true
			end

			unless File.exist?(sata2)
				vb.customize ['createhd', '--filename', sata2, '--size', 500]
			end

			unless File.exist?(sata3)
				vb.customize ['createhd', '--filename', sata3, '--size', 500]
			end

			unless File.exist?(sata4)
				vb.customize ['createhd', '--filename', sata4, '--size', 500]
			end

			if needsController == true
				vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata"]
			end
				
			vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', sata1]
			vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', sata2]
			vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', sata3]
			vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 4, '--device', 0, '--type', 'hdd', '--medium', sata4]

		end	

		lesson2.vm.provision "shell", inline: <<-SHELL
			yum install -y mdadm smartmontool hdparm gdisk nano mc
			chmod +x /vagrant/create_raid.sh
			/vagrant/create_raid.sh
		SHELL

	end	
end