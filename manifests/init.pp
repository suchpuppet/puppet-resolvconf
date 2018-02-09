# resolvconf
#
# Main class for managing resolv.conf
#
# @summary Main class that includes other classes for managing resolv.conf
#
# @example
#   include resolvconf
class resolvconf (
  String  $template_file,
  Array[Variant[String, Float], 1] $nameservers,
  Array[String, 1] $domains,
  Boolean $use_local,
) {
  if $facts['os']['family'] == 'Debian' {
    include ::resolvconf::install
    include ::resolvconf::service
  }

  include ::resolvconf::config
}
