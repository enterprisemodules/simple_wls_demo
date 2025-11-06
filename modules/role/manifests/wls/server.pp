# Docs
class role::wls::server () {
  contain profile::base
  contain wls_profile::node

  Class['profile::base'] -> Class['wls_profile::node']
}
