# Create the domain and all contents in it
class profile::wls::my_domain
{
  contain ::profile::wls::my_domain::domain
  #
  # For every datasource create a class. This helps in easy management of parameters.
  #
  contain ::profile::wls::my_domain::datasources::ds0
  contain ::profile::wls::my_domain::jms

  Class['::profile::wls::my_domain::domain']
  -> Class['::profile::wls::my_domain::datasources::ds0']
  -> Class['::profile::wls::my_domain::jms']
}
