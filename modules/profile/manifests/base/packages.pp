#
# Make sure all required packages are installed
#
class profile::base::packages()
{
  $required_package = [
  ]

  package{ $required_package:
    ensure => 'installed',
  }

}
