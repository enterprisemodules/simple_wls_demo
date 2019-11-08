#
# Install correct puppet version
#
echo 'Installing puppet agent'
if [[ "$OSTYPE" == "linux"* ]]; then
    rpm -q puppet5-release || yum install -y --nogpgcheck https://yum.puppetlabs.com/puppet6/puppet6-release-el-7.noarch.rpm > /dev/null
    rpm -q puppet-agent || yum install -y --nogpgcheck puppet-agent
    rpm -q git || yum install -y git
elif [[ "$OSTYPE" == "solaris"* ]]; then
    pkg install puppet git
else
    echo "ERROR: Unsupported OS"
    exit 1
fi
