#
# This is the base configuration. It is the same for ALL nodes
#
class profile::base::config()
{
  class { 'timezone':
    timezone => 'Europe/Amsterdam',
  }
}
