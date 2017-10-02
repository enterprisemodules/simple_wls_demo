# Install java, WebLogic and create the domain.
class role::wls::my_domain_master()
{
  contain ::profile::base
  contain ::profile::wls::os
  contain ::profile::java
  contain ::profile::wls::software
  contain ::profile::wls::my_domain

  Class['::profile::base']
  -> Class['::profile::wls::os']
  -> Class['::profile::java']
  -> Class['::profile::wls::software']
  -> Class['::profile::wls::my_domain']
}
