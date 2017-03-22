Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.hostname = 'discourse.dev'
  config.ssh.shell = 'bash -c \'BASH_ENV=/etc/profile exec bash\''
  config.vm.network :private_network, ip: "192.168.11.3"

  config.ssh.insert_key = false
  # config.ssh.forward_agent = true

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.synced_folder "./", "/vm", type: "nfs", :mount_options => ['nolock,vers=3,udp,noatime,actimeo=1']

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end
end
