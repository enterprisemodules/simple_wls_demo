#
# Install R10K. We need this to download the correct set of puppet modules
#
echo 'Installing required gems'
/opt/puppetlabs/puppet/bin/gem install r10k --no-rdoc --no-ri > /dev/null # 2>&1

echo 'Installing required puppet modules'
cd /vagrant
#
# Copy netrc file if it exists
#
if [ -e /vagrant/.netrc ]
then
  cp /vagrant/.netrc ~
fi
/opt/puppetlabs/puppet/bin/r10k puppetfile install > /dev/null # 2>&1

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
