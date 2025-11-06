# TODO: Docs
class profile::base () {
  contain "profile::base::${facts['deployment_zone']}"
  contain profile::base::config
  contain profile::base::hosts
  contain profile::base::packages
}
