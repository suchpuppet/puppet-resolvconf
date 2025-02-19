# resolvconf
#
# Main class for managing resolv.conf
#
# @summary Manage resolv.conf configuration
# This module configures DNS resolution via `systemd-resolved`or directly manages /etc/resolv.conf
#
# @example using systemd-resolved and defaults
#   include resolvconf
#
# @example Directly managing /etc/resolv.conf
#   class { 'resolvconf':
#     use_systemd_resolved => false,
#     use_local            => false,
#     dns                  => ['8.8.8.8', '1.1.1.1'],
#     domains              => ['example.com'],
#     options              => ['ndots:5'],
#   }
#
# @example Using hiera configuration
#   include resolvconf
#
#   hiera config:
#     resolvconf::use_systemd_resolved: true
#     resolvconf::use_local: true
#     resolvconf::dns: ['8.8.8.8', '1.1.1.1']
#
# @param dns [Array[Variant[String, Float], 1]]
#   Array containing the nameservers to put in resolv.conf (default: ['8.8.8.8','1.1.1.1'])
#
# @param domains [Array[String, 1]]
#   The domains to include in the search line in resolv.conf
#
# @param use_local [Boolean]
#   Whether to use a local DNS listener for systemd-resolved or local dns service (default: true)
#
# @param options [Array[String]]
#   Array containing the options to put in resolv.conf. Not applicable when use_systemd_resolved is true
#
# @param use_systemd_resolved [Boolean]
#   Use systemd-resolved for managing resolv.conf
#
# @param fallback_dns [Array[Variant[String, Float]]
#   Array containing fallback nameservers to put in resolv.conf
#   Default value is an empty array.
#
# @param dns_stub_listener_extra [Array[Variant[String, Float]]
#   An array of strings or floats, with at least one element, representing
#   additional DNS stub listener configurations.
#   Default value is an empty array.
class resolvconf (
  Boolean $use_systemd_resolved,
  Boolean $use_local,
  Array[Variant[String, Float], 1] $dns,
  Array[Variant[String, Float]] $fallback_dns,
  Array[Variant[String, Float]] $dns_stub_listener_extra,
  Array[String, 1] $domains,
  Array[String] $options,
) {
  if $facts['os']['distro']['id'] == 'Ubuntu' {
    include resolvconf::install
  }

  if $use_systemd_resolved {
    include resolvconf::service
  }

  include resolvconf::config
}
