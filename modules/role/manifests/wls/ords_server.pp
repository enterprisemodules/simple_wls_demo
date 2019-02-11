# Install java, WebLogic and create the domain.
class role::wls::ords_server()
{
  contain ::profile::base
  contain ::wls_install::ords::software

  Class['::profile::base'] -> 
  Class['::wls_profile::admin_server']
  notice('check ords')
}
