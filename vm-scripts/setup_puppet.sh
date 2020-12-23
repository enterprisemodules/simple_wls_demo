if [ -f /var/log/setup_puppet.done ]
then
  echo "Puppet already setup"
else
  #
  # Install R10K. We need this to download the correct set of puppet modules
  #
  echo 'Installing required gems'
  /opt/puppetlabs/puppet/bin/gem install r10k --no-document > /dev/null # 2>&1

  echo 'Installing required puppet modules'
  cd /vagrant
  #
  # Copy netrc file if it exists
  #
  if [ -e /vagrant/.netrc ]
  then
    cp /vagrant/.netrc ~
  fi
  #
  # Check which Puppetfile to use. If a file use_latest exists, use the
  # Puppetfile_latest which by default fetches files from latest master branch
  #
  if [ -e /vagrant/use_latest_modules ]
  then
    echo "Using latest versions of modules..."
    PUPPETFILE="Puppetfile_latest"
  else
    echo "Using released versions of modules..."
    PUPPETFILE="Puppetfile"
  fi
  /opt/puppetlabs/puppet/bin/r10k puppetfile install --puppetfile ${PUPPETFILE} --force > /dev/null # 2>&1

  #
  # Setup hiera search and backend. We need this to config our systems
  #
  echo 'Setting up hiera directories'
  dirname=/etc/puppetlabs/code/environments/production/hieradata
  if [ -d $dirname ]; then
    rm -rf $dirname
  else
    rm -f $dirname
  fi
  ln -sf /vagrant/hieradata /etc/puppetlabs/code/environments/production
  rm -f /etc/puppetlabs/code/environments/production/hiera.yaml
  ln -sf /vagrant/hiera.yaml /etc/puppetlabs/code/environments/production

  #
  # Configure the puppet path's
  #
  echo 'Setting up Puppet module directories'
  dirname=/etc/puppetlabs/code/environments/production/modules
  if [ -d $dirname ]; then
    rm -rf $dirname
  else
    rm -f $dirname
  fi
  ln -sf /vagrant/modules /etc/puppetlabs/code/environments/production

  echo 'Setting up Puppet manifest directories'
  dirname=/etc/puppetlabs/code/environments/production/manifests
  if [ -d $dirname ]; then
    rm -rf $dirname
  else
    rm -f $dirname
  fi
  ln -sf /vagrant/manifests /etc/puppetlabs/code/environments/production

  touch /var/log/setup_puppet.done
fi
