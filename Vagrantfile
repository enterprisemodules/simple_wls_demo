require 'yaml'

VAGRANTFILE_API_VERSION = '2'.freeze

VALID_KEYS = [
  'public_ip',
  'private_ip',
  'domain_name',
  'additional_hosts',
  'box',
  'puppet_master',
  'disks',
  'cluster',
  'puppet_installer',
  'required_plugins',
  'software_files',
  'protocol',
  'type',
  'cpucount',
  'ram',
  'virtualboxorafix',
  'needs_storage',
]

class FilesNotFoundError < Vagrant::Errors::VagrantError
  def error_message
    "Missing software files"
  end
end

class InvalidDefinition < Vagrant::Errors::VagrantError
  def error_message
    "Invalid definition in server.yaml"
  end
end

def validate_definitions(content)
  errors = []
  content.each do | key, values|
    errors << "Node #{key} needs and 'ml-' prefix for masterless or an 'pe-' prefix for Puppset agent" if key[0,3] != 'ml-' && key[0,3] != 'pe-'
    unknown_keys = values.keys - VALID_KEYS
    next if unknown_keys.empty?
    errors << "Node #{key} contains unkown entries #{unknown_keys.join(', ')}"
  end
  errors
end

def servers
  content = YAML.load_file("#{File.dirname(__FILE__)}/servers.yaml")
  defaults    = content.delete('defaults') || {}
  pe_defaults = content.delete('pe-defaults') || {}
  ml_defaults = content.delete('ml-defaults') || {}
  content.each do | key, values|
    case key[0,3]
    when 'ml-'
      content[key] = defaults.merge(ml_defaults).merge(values)
    when 'pe-'
      content[key] = defaults.merge(pe_defaults).merge(values)
    end
  end
  errors = validate_definitions(content)
  if errors.any?
    puts "servers.yaml contains following errors:"
    errors.each {|e| puts "- #{e}\n"}
    raise InvalidDefinition
  end
  content
end

# Read YAML file with box details
pe_puppet_user_id  = 495
pe_puppet_group_id = 496
vagrant_root       = File.dirname(__FILE__)
home               = ENV['HOME']
add_timestamp      = false

def masterless_setup(config, server, srv, hostname)
  config.trigger.after :up do |trigger|
    #
    # Fix hostnames because Vagrant mixes it up.
    #
    if srv.vm.communicator == 'ssh'
      trigger.run_remote = {inline: <<~EOD}
        cat > /etc/hosts<< "EOF"
        127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
        #{server['public_ip']} #{hostname}.#{server['domain_name']} #{hostname}
        #{server['additional_hosts'] ? server['additional_hosts'] : ''}
        EOF
        bash /vagrant/vm-scripts/install_puppet.sh
        bash /vagrant/vm-scripts/setup_puppet.sh
        /opt/puppetlabs/puppet/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp || true
      EOD
    else # Windows
      trigger.run_remote = {inline: <<~EOD}
        cd c:\\vagrant\\vm-scripts
        .\\install_puppet.ps1
        cd c:\\vagrant\\vm-scripts
        .\\setup_puppet.ps1
        iex "& 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet' resource service puppet ensure=stopped"
        iex "& 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet' resource service puppet ensure=stopped"
        iex "& 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet' apply c:\\vagrant\\manifests\\site.pp -t"
      EOD
    end
  end

  config.trigger.after :provision do |trigger|
    if srv.vm.communicator == 'ssh'
      trigger.run_remote = {
        inline: "puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp || true"
      }
    end
  end
end

def masterless_windows_setup(config, server, srv, hostname)
  srv.vm.hostname = "#{hostname}"
  srv.vm.provision :shell, inline: <<~EOD
  cd c:\\vagrant\\vm-scripts
  .\\install_puppet.ps1
  cd c:\\vagrant\\vm-scripts
  .\\setup_puppet.ps1
  iex "& 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet' resource service puppet ensure=stopped"
  iex "& 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet' apply c:\\vagrant\\manifests\\site.pp -t"
  EOD
end

def raw_setup(config, server, srv, hostname)
  config.trigger.after :up do |trigger|
    #
    # Fix hostnames because Vagrant mixes it up.
    #
    if srv.vm.communicator == 'ssh'
      trigger.run_remote = {inline: <<~EOD}
        cat > /etc/hosts<< "EOF"
        127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
        #{server['public_ip']} #{hostname}.#{server['domain_name']} #{hostname}
        #{server['additional_hosts'] ? server['additional_hosts'] : ''}
        EOF
        bash /vagrant/vm-scripts/setup_puppet_raw.sh
        /opt/puppetlabs/puppet/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp || true
      EOD
    else # Windows
      trigger.run_remote = {inline: <<~EOD}
        cd c:\\vagrant\\vm-scripts
        .\\setup_puppet_raw.ps1
        iex "& 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet' resource service puppet ensure=stopped"
        iex "& 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet' resource service puppet ensure=stopped"
        iex "& 'C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet' apply c:\\vagrant\\manifests\\site.pp -t"
      EOD
    end
  end

  config.trigger.after :provision do |trigger|
    if srv.vm.communicator == 'ssh'
      trigger.run_remote = {
        inline: "puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp || true"
      }
    end
  end
end

def puppet_master_setup(config, srv, server, puppet_installer, pe_puppet_user_id, pe_puppet_group_id, hostname)
  srv.vm.synced_folder '.', '/vagrant', owner: pe_puppet_user_id, group: pe_puppet_group_id
  srv.vm.provision :shell, inline: "/vagrant/modules/software/files/#{puppet_installer} -c /vagrant/pe.conf -y"
  #
  # For this vagrant setup, we make sure all nodes in the domain examples.com are autosigned. In production
  # you'dd want to explicitly confirm every node.
  #
  srv.vm.provision :shell, inline: "echo '*.#{server['domain_name']}' > /etc/puppetlabs/puppet/autosign.conf"
  srv.vm.provision :shell, inline: "echo '*.local' >> /etc/puppetlabs/puppet/autosign.conf"
  srv.vm.provision :shell, inline: "echo '*.home' >> /etc/puppetlabs/puppet/autosign.conf"
  #
  # For now we stop the firewall. In the future we will add a nice puppet setup to the ports needed
  # for Puppet Enterprise to work correctly.
  #
  srv.vm.provision :shell, inline: 'systemctl stop firewalld.service'
  srv.vm.provision :shell, inline: 'systemctl disable firewalld.service'
  #
  # This script make's sure the vagrant paths's are symlinked to the places Puppet Enterprise looks for specific
  # modules, manifests and hiera data. This makes it easy to change these files on your host operating system.
  #
  srv.vm.provision :shell, path: 'vm-scripts/setup_puppet.sh'
  #
  # Make sure all plugins are synced to the puppetserver before exiting and stating
  # any agents
  #
  srv.vm.provision :shell, inline: 'service pe-puppetserver restart'
  srv.vm.provision :shell, inline: 'puppet agent -t || true'
end

def puppet_agent_setup(config, server, srv, hostname)
  #
  # First we need to instal the agent.
  #
  config.trigger.after :up do |trigger|
    #
    # Fix hostnames because Vagrant mixes it up.
    #
    if srv.vm.communicator == 'ssh'
      trigger.run_remote = {inline: <<~EOD}
        cat > /etc/hosts<< "EOF"
        127.0.0.1 localhost.localdomain localhost4 localhost4.localdomain4
        #{server['public_ip']} #{hostname}.#{server['domain_name']} #{hostname}
        #{server['additional_hosts'] ? server['additional_hosts'] : ''}
        EOF
        curl -k https://#{server['puppet_master']}.#{server['domain_name']}:8140/packages/current/install.bash | sudo bash
        #
        # The agent installation also automatically start's it. In production, this is what you want. For now we
        # want the first run to be interactive, so we see the output. Therefore, we stop the agent and wait
        # for it to be stopped before we start the interactive run
        #
        pkill -9 -f "puppet.*agent.*"
        /opt/puppetlabs/puppet/bin/puppet agent -t; exit 0
        #
        # After the interactive run is done, we restart the agent in a normal way.
        #
        systemctl start puppet
        EOD
      else
        trigger.run_remote = {inline: <<~EOD}
        Copy-Item -Path c:\\vagrant\\vm-scripts\\windows-hosts -Destination c:\\Windows\\System32\\Drivers\\etc\\hosts
        [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}; $webClient = New-Object System.Net.WebClient; $webClient.DownloadFile('https://#{server['puppet_master']}.#{server['domain_name']}:8140/packages/current/install.ps1', 'install.ps1');.\\install.ps1
        iex 'puppet resource service puppet ensure=stopped'
        iex 'puppet agent -t'
        EOD
    end
  end
end

# Fix setup for Oracle applications
def virtualboxorafix(vb)
  vb.customize ['setextradata', :id, 'VBoxInternal/CPUM/HostCPUID/Cache/Leaf', '0x4']
  vb.customize ['setextradata', :id, 'VBoxInternal/CPUM/HostCPUID/Cache/SubLeaf', '0x4']
  vb.customize ['setextradata', :id, 'VBoxInternal/CPUM/HostCPUID/Cache/eax', '0']
  vb.customize ['setextradata', :id, 'VBoxInternal/CPUM/HostCPUID/Cache/ebx', '0']
  vb.customize ['setextradata', :id, 'VBoxInternal/CPUM/HostCPUID/Cache/ecx', '0']
  vb.customize ['setextradata', :id, 'VBoxInternal/CPUM/HostCPUID/Cache/edx', '0']
  vb.customize ['setextradata', :id, 'VBoxInternal/CPUM/HostCPUID/Cache/SubLeafMask', '0xffffffff']
end

# Configure VirtualBox disks attached to the virtual machine
def configure_disks(vb, server, hostname)
  disks = server['disks'] || {}
  unless File.file?(".#{hostname}.txt")
    vb.customize [
      'storagectl', :id,
      '--name', 'SATA Controller',
      '--add', 'sata',
      '--portcount', disks.size
    ]
  end

  disks.each_with_index do |disk, i|
    disk_name = disk.first
    disk_size = disk.last['size']
    disk_uuid = disk.last['uuid']

    if File.file?("#{disk_name}.vdi") && File.file?(".#{disk_name}.txt")
      file = File.open(".#{disk_name}.txt", 'r')
      current_uuid = file.read
      file.close
    elsif File.file?("#{disk_name}.vdi")
      current_uuid = '0'
    elsif server['cluster'] &&
          File.file?("#{disk_name}_#{server['cluster']}.vdi") &&
          File.file?(".#{disk_name}_#{server['cluster']}.txt")
      file = File.open(".#{disk_name}_#{server['cluster']}.txt", 'r')
      current_uuid = file.read
      file.close
    elsif server['cluster'] && File.file?("#{disk_name}_#{server['cluster']}.vdi")
      current_uuid = '0'
    elsif server['cluster']
      vb.customize [
        'createhd',
        '--filename', "#{disk_name}_#{server['cluster']}.vdi",
        '--size', disk_size.to_s,
        '--variant', 'Fixed'
      ]
      vb.customize [
        'modifyhd', "#{disk_name}_#{server['cluster']}.vdi",
        '--type', 'shareable'
      ]
      current_uuid = '0'
    else
      vb.customize [
        'createhd',
        '--filename', "#{disk_name}.vdi",
        '--size', disk_size.to_s,
        '--variant', 'Standard'
      ]
      current_uuid = '0'
    end

    # Conditional for adding disk_uuid
    if server['cluster'] && current_uuid.include?(disk_uuid)
      vb.customize [
        'storageattach', :id,
        '--storagectl', 'SATA Controller',
        '--port', (i + 1).to_s,
        '--device', 0,
        '--type', 'hdd',
        '--medium', "#{disk_name}_#{server['cluster']}.vdi",
        '--mtype', 'shareable'
      ]
    elsif server['cluster']
      vb.customize [
        'storageattach', :id,
        '--storagectl', 'SATA Controller',
        '--port', (i + 1).to_s,
        '--device', 0,
        '--type', 'hdd',
        '--medium', "#{disk_name}_#{server['cluster']}.vdi",
        '--mtype', 'shareable',
        '--setuuid', "00000000-0000-0000-0000-0000000000#{disk_uuid}"
      ]
    elsif current_uuid.include? disk_uuid
      vb.customize [
        'storageattach', :id,
        '--storagectl', 'SATA Controller',
        '--port', (i + 1).to_s,
        '--device', 0,
        '--type', 'hdd',
        '--medium', "#{disk_name}.vdi"
      ]
    else
      vb.customize [
        'storageattach', :id,
        '--storagectl', 'SATA Controller',
        '--port', (i + 1).to_s,
        '--device', 0,
        '--type', 'hdd',
        '--medium', "#{disk_name}.vdi",
        '--setuuid', "00000000-0000-0000-0000-00000000000#{disk_uuid}"
      ]
    end
  end
end

# Raises missing plugin error
def plugin_check(plugin_name)
  unless Vagrant.has_plugin?(plugin_name)
    raise "#{plugin_name} is not installed, please run: vagrant plugin " \
          "install #{plugin_name}"
  end
end

# Check if all required software files from servers.yaml are present in repo.
def local_software_file_check(config, vagrant_root, file_names)
  config.trigger.before [:up, :reload, :provision] do |trigger|
    trigger.ruby do |env, machine|
      files_found = true
      file_names.each do |file_name|
        file_path = "#{vagrant_root}/modules/software/files/#{file_name}"
        unless File.exist?(file_path) # returns true for directories
          files_found = false
          env.ui.error "Missing software file: #{file_name}"
        end
      end
      if not files_found
          env.ui.error "Please add missing file(s) to the: ./modules/software/files/ directory."
          raise FilesNotFoundError
      end
    end
  end
end

#
# Vagrant setup
#
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false
  servers.each do |name, server|
    # Fetch puppet installer version if it is present
    puppet_installer = server['puppet_installer']

    # Start VM configuration
    config.vm.define name do |srv|
      # Perform checks
      config.trigger.after :up do |trigger|
        #
        # Perform plugin checks before main setup
        #
        server['required_plugins'].each { |name| plugin_check(name) } if server['required_plugins']
        #
        # Perform software checks before main setup
        #
        local_software_file_check(config, vagrant_root, server['software_files']) if server['software_files']
        local_software_file_check(config, vagrant_root, [puppet_installer]) if puppet_installer # Check if installer folder is present
      end

      srv.vm.communicator = server['protocol'] || 'ssh'
      srv.vm.box          = server['box']
      hostname            = name.split('-').last # First part contains type of node

      if srv.vm.communicator == 'ssh'
        srv.vm.hostname = "#{hostname}.#{server['domain_name']}"
      else
        srv.vm.hostname = "#{hostname}"
        config.winrm.ssl_peer_verification = false
        config.winrm.retry_delay = 60
        config.winrm.retry_limit = 10
      end

      srv.vm.network 'private_network', ip: server['public_ip'] if server['public_ip']
      srv.vm.network 'private_network', ip: server['private_ip'], virtualbox__intnet: true if server['private_ip']

      #
      # Copy all everything to the box including software
      #
      srv.vm.synced_folder '.', '/vagrant', type: :virtualbox

      #
      # Depending on the machine type, perform setup
      #
      case server['type']
      when 'raw'
        raw_setup(config, server, srv, hostname)
      when 'masterless'
        masterless_setup(config, server, srv, hostname)
      when 'masterless_windows'
        masterless_windows_setup(config, server, srv, hostname)
      when 'pe-master'
        puppet_master_setup(config, srv, server, puppet_installer, pe_puppet_user_id, pe_puppet_group_id, hostname)
      when 'pe-agent'
        puppet_agent_setup(config, server, srv, hostname)
      begin
        "#{server['type']} is invalid."
      rescue => exception
        
      else
        
      ensure
        
      end
      end

      config.vm.provider :virtualbox do |vb|
        # vb.gui = true
        vb.cpus = server['cpucount'] || 1
        vb.memory = server['ram'] || 4096

        # Setup config fixes for Oracle product
        virtualboxorafix(vb) if server['virtualboxorafix']

        # Attach disks if the setup needs virtual drives
        configure_disks(vb, server, hostname) if server['needs_storage']
      end
    end
  end
end
