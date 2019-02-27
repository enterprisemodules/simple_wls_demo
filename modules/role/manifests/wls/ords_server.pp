# Install java, WebLogic and create the domain.
class role::wls::ords_server()
{
  contain ::profile::base
  contain ::wls_profile::admin_server
  contain ::wls_install::ords::software
  Class['::profile::base'] ->
  Class['::wls_profile::admin_server']->
  Class['::wls_install::ords::software']
  notice('check ords')
}
