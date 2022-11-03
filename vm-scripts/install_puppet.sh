if [ -f /opt/puppetlabs/bin/puppet ]
then
  echo "Puppet already installed"
else
  #
  # Install correct puppet version
  #
  if [ -f "/vagrant/puppet_version" ]; then
    PACKAGE="puppet-agent-$(cat /vagrant/puppet_version)"
  else
    PACKAGE="puppet-agent"
  fi
  echo "Installing $PACKAGE"
  unamestr=`uname`
  if [[ "$unamestr" == 'Linux' ]]; then
    rhel=$(grep '^VERSION_ID' /etc/os-release | awk -F'[=."]' '{ print $3}')
    yum install -y --nogpgcheck https://yum.puppetlabs.com/puppet-release-el-${rhel}.noarch.rpm > /dev/null
    yum install -y --nogpgcheck $PACKAGE
    rpm -q git || yum install -y --nogpgcheck git
  elif [[ "$unamestr" == 'SunOS' ]]; then
    pkg install -g file:///vagrant/modules/software/files/puppet-agent\@7.8.0\,5.11-1.i386.p5p puppet-agent
  fi
  touch /var/log/install_puppet.done
fi