# resolvconf::config
# @summary Class to configure the resolv.conf file. This class should not be called directly.
#
# @param use_systemd_resolved [Boolean]
#  Use systemd-resolved for managing resolv.conf
#
# @param use_local [Boolean]
#  Use local DNS resolver
#
# @param dns [Array[Variant[String, Float], 1]]
#  List of DNS servers
#
# @param fallback_dns [Array[Variant[String, Float]]
#  List of fallback DNS servers
#
# @param dns_stub_listener_extra [Array[Variant[String, Float]]
#  Extra DNS stub listener options
#
# @param domains [Array[String, 1]]
#  List of search domains
#
# @param options [Array[String]]
#  List of resolver options to add to resolv.conf
class resolvconf::config (
  Array[Variant[String, Float], 1] $dns = $resolvconf::dns,
  Array[String, 1] $domains = $resolvconf::domains,
  Boolean $use_systemd_resolved = $resolvconf::use_systemd_resolved,
  Boolean $use_local            = $resolvconf::use_local,
  Array[Variant[String, Float]] $fallback_dns = $resolvconf::fallback_dns,
  Array[Variant[String, Float]] $dns_stub_listener_extra = $resolvconf::dns_stub_listener_extra,
  Array[String] $options = $resolvconf::options,
) inherits resolvconf {
  if $use_systemd_resolved {
    require resolvconf::install
    include resolvconf::service

    file { '/etc/resolv.conf':
      ensure => 'symlink',
      target => '/run/systemd/resolve/stub-resolv.conf',
      force  => true,
      owner  => 'root',
      group  => 'root',
      notify => Class['resolvconf::service'],
    }

    file { '/etc/systemd/resolved.conf.d':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      before => File['/etc/systemd/resolved.conf.d/puppet.conf'],
    }

    file { '/etc/systemd/resolved.conf.d/puppet.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('resolvconf/resolv.conf.puppet.erb'),
    }
  } else {
    file { '/etc/resolv.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('resolvconf/resolv.conf.erb'),
    }
  }
}
