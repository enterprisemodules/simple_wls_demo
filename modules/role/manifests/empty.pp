# Do nothing except the base config
class role::empty()
{
  contain ::profile::base::config
  contain ::profile::base::hosts
}
