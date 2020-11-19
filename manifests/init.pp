# resolvconf
#
# Main class for managing resolv.conf
#
# @summary Main class that includes other classes for managing resolv.conf
#
# @example
#   include resolvconf
#
# @param template_file
#   The absolute path to the resolvconf template file to manage
#
# @param nameservers
#   Array containing the nameservers to put in resolv.conf
#
# @param domains
#   The domains to include in the search line in resolv.conf
#
# @param use_local
#   Use 127.0.0.1 as the resolver if using dnsmasq or similar
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
