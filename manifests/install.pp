# resolvconf::install
#
# Class to install resolvconf package on Debian based systems
class resolvconf::install {
  if $facts['os']['family'] == 'Debian' {
    package { 'resolvconf':
      ensure => 'present',
    }
  }
}
