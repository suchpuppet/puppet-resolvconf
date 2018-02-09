# resolvconf::config
#
# Class to configure the resolv.conf file
#
class resolvconf::config {
  include ::resolvconf
  $nameservers   = $::resolvconf::nameservers
  $domains       = $::resolvconf::domains
  $template_file = $::resolvconf::template_file
  $use_local     = $::resolvconf::use_local

  if $facts['os']['family'] == 'Debian' {
    require ::resolvconf::install

    $resolvconf_dirs = [ '/etc/resolvconf', '/etc/resolvconf/resolv.conf.d']

    $resolvconf_dirs.each |String $name| {
      file { $name:
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
    }

    file { '/etc/resolv.conf':
      ensure => 'symlink',
      target => '/var/run/resolvconf/resolv.conf',
      owner  => 'root',
      group  => 'root',
    }
  }

  file { $template_file:
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('resolvconf/resolv.conf.erb')
  }
}
