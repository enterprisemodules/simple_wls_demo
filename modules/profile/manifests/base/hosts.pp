#
# Make sure all required nodes are in the hosts file.
#
class profile::base::hosts(
  Hash $list,
)
{
  $list.each |$host, $values| {
    host { $host:
      * => $values,
    }
  }
}
