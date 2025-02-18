
unless Vagrant.has_plugin?("vagrant-em-demos")
  puts "Installing vagrant-em-demos plugin. Restart vagrant after installation."
  system "vagrant plugin install vagrant-em-demos"
  exit 1
end

require 'vagrant/em/demos/plugin'
Vagrant.configure("2") do |config|
  # Automatically load settings from servers.yaml for every VM
  config.em.config_file = "servers.yaml"
end

