puppet_server=${1}
if [ -f /var/log/install_puppet_agent.done ]
then
  echo "Puppet agent already installed"
else
  #
  # Install puppet agent
  #
  curl -k https://${puppet_server}:8140/packages/current/install.bash | sudo bash

  #
  # Increase runtimeout from default of 1h
  #
  echo "runtimeout = 57600" >> /etc/puppetlabs/puppet/puppet.conf

  touch /var/log/install_puppet_agent.done
fi