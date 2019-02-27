class role::wls::server()
{
  contain ::profile::base
  contain ::wls_profile::node
  # ORDS disabled for development purposes
  # contain ::wls_install::ords::software
  Class['::profile::base'] ->
  Class['::wls_profile::node']
  # -> Class['::wls_install::ords::software']
  # notice("run wls_install ords")
}

