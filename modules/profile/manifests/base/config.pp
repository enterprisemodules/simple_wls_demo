#
# This is the base configuration. It is the same for ALL nodes
#
class profile::base::config()
{
  if $::kernel == 'Linux' {
    class { 'timezone':
      timezone => 'Europe/Amsterdam',
    }
  }
}
