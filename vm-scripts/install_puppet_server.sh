puppet_installer=${1}
domain_name=${2}
if [ -f /var/log/install_puppet_server.done ]
then
  echo "Puppet server already installed"
else
  #
  # Install puppet server
  #
  /vagrant/modules/software/files/${puppet_installer} -c /vagrant/pe.conf -y

  #
  # For this vagrant setup, we make sure all nodes in the domain examples.com are autosigned. In production
  # you'dd want to explicitly confirm every node.
  #
  echo "*.${domain_name}" > /etc/puppetlabs/puppet/autosign.conf
  echo "*.local" >> /etc/puppetlabs/puppet/autosign.conf
  echo "*.home" >> /etc/puppetlabs/puppet/autosign.conf

  #
  # For now we stop the firewall. In the future we will add a nice puppet setup to the ports needed
  # for Puppet Enterprise to work correctly.
  #
  systemctl stop firewalld.service
  systemctl disable firewalld.service

  #
  # This script make's sure the vagrant paths's are symlinked to the places Puppet Enterprise looks for specific
  # modules, manifests and hiera data. This makes it easy to change these files on your host operating system.
  #
  bash /vagrant/vm-scripts/setup_puppet.sh

  #
  # Make sure all plugins are synced to the puppetserver before exiting and stating
  # any agents
  #
  systemctl restart pe-puppetserver

  touch /var/log/install_puppet_server.done
fi