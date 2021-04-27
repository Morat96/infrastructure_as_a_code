require_relative './vagrant/key_authorization'

Vagrant.configure('2') do |config|
  config.vm.box = 'centos/8'
  config.disksize.size = '52GB'
  config.ssh.insert_key = false
  authorize_key_for_root config, '~/.ssh/id_dsa.pub', '~/.ssh/id_rsa.pub'

  # run two VMs
  N = 2
  (1..N).each do |machine_id|
    config.vm.define "machine#{machine_id}" do |machine|
      machine.vm.hostname = "machine#{machine_id}.challenge"
      machine.vm.network "private_network", ip: "192.168.77.#{20+machine_id}"

      # Only execute once the Ansible provisioner,
      # when all the machines are up and ready.
      if machine_id == N
        machine.vm.provision :ansible do |ansible|
          # Disable default limit to connect to all the machines
          ansible.limit = "all"
          ansible.inventory_path = 'hosts'
          ansible.playbook = "playbook.yml"
        end
        machine.vm.provision :serverspec do |spec|
          spec.pattern = 'scripts/*_spec.rb' # pattern for test files
        end
      end
    end
  end
end
