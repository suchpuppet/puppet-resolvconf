# resolvconf::service
#
# A description of what this class does
#
# @summary Class for managing the systemd-resolved service
#
# @param use_systemd_resolved [Boolean] Determine if systemd-resolved should be used
class resolvconf::service (
  Boolean $use_systemd_resolved = $resolvconf::use_systemd_resolved,
) inherits resolvconf {
  include resolvconf::config

  if $use_systemd_resolved {
    service { 'systemd-resolved':
      ensure    => 'running',
      enable    => true,
      subscribe => Class['resolvconf::config'],
    }
  }
}
