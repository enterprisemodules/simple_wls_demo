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
    rhel=$(awk -F'[ .]' '{if ($1=="AlmaLinux") print $3; else if (NF==8) print $6; else if (NF==9) print $7}' /etc/redhat-release)
    yum install -y --nogpgcheck https://yum.puppetlabs.com/puppet8-release-el-${rhel}.noarch.rpm > /dev/null
    yum install -y --nogpgcheck $PACKAGE
    rpm -q git || yum install -y --nogpgcheck git
  elif [[ "$unamestr" == 'SunOS' ]]; then
    pkg install -g file:///vagrant/modules/software/files/puppet-agent\@7.8.0\,5.11-1.i386.p5p puppet-agent
  fi
  touch /var/log/install_puppet.done
fi