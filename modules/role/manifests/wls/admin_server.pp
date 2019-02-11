# Install java, WebLogic and create the domain.
class role::wls::admin_server()
{
  contain ::profile::base
  contain ::wls_profile::admin_server

  Class['::profile::base']  -> Class['::wls_profile::admin_server']
  notice('check admin')
}
