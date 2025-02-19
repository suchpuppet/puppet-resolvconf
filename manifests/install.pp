# resolvconf::install
#
# Class to install resolvconf package on Debian based systems
# resolvconf::install
#
# Class to install resolvconf package on Debian based systems
#
# @param use_systemd_resolved
#  Boolean to determine if systemd-resolved should be used
class resolvconf::install (
  Boolean $use_systemd_resolved = $resolvconf::use_systemd_resolved,
) inherits resolvconf {
  $ensure = $use_systemd_resolved ? {
    true  => 'latest',
    false => 'absent',
  }

  # Ubuntu >= 24.04 requires a separate package for systemd-resolved
  if $use_systemd_resolved {
    if $facts['os']['distro']['id'] == 'Ubuntu' and Float($facts['os']['distro']['release']['major']) >= 24 {
      package { 'systemd-resolved':
        ensure => $ensure,
      }
    }
  }
}
