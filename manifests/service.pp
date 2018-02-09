# resolvconf::service
#
# A description of what this class does
#
# @summary Class for managing rebuilding the resolv.conf on debian systems
#
class resolvconf::service {
  include ::resolvconf::config

  if $facts['os']['family'] == 'Debian' {
    # Rebuild resolv.conf when the template files change.
    service { 'resolvconf':
      ensure    => 'running',
      enable    => true,
      subscribe => Class['::resolvconf::config']
    }
  }
}
