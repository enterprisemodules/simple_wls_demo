# Install java, WebLogic and create the domain.
class role::wls::ords_server()
{
  contain ::wls_install::ords::software
  #
  # Next add the stuff needed to configute
  #

  notice("run wls_install ords")
  Class['::wls_install::ords::software']

}
