#
# Install correct puppet version
#
echo 'Installing puppet agent'
rpm -q puppet5-release || yum install -y --nogpgcheck https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm > /dev/null
rpm -q puppet-agent || yum install -y --nogpgcheck puppet-agent
rpm -q git || yum install -y git
