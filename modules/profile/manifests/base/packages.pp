#
# Make sure all required packages are installed
#
class profile::base::packages () {
  $required_package = [
    'unzip',
  ]

  case $facts['kernel'] {
    'Linux': {
      package { $required_package:
        ensure => 'installed',
      }
    }
    default: {}
  }
}
