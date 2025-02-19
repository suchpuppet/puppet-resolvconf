
# resolvconf

[![Build Status](https://travis-ci.org/suchpuppet/puppet-resolvconf.svg?branch=master)](https://travis-ci.org/suchpuppet/puppet-resolvconf)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with resolvconf](#setup)
    * [Beginning with resolvconf](#beginning-with-resolvconf)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

Module for managing resolv.conf on RedHat and Ubuntu based systems

## Setup

### Beginning with resolvconf

`include resolvconf` is enough to get you up and running with the module if you would like a default setup using Google’s resolvers and the `$::domain` fact as the search domain.

## Usage

All parameters are available in the main resolvconf class.  See the common usages below for examples.

### Configure a default resolv.conf with Google nameservers as the `$::domain` fact as the search path
`include ::resolvconf`

### Pass in parameters for which nameservers to use

```
class { ‘::resolvconf’:
  dns => [‘8.8.8.8’, ‘1.1.1.1’],
}
```

### Pass in nameservers plus domains for the search path

```
class { ‘::resolvconf’:
  dns     => [‘8.8.8.8’, ‘8.8.4.4’],
  domains => [‘domain.tld’, ‘sub.domain.tld’],
}
```

## Reference

### Classes

#### Public classes
* resolvconf: Main class, includes all other classes

#### Private classes
* resolvconf::config: Handles the configuration of resolv.conf
* resolvconf::service: Handles the resolvconf service for debian based systems
* resolvconf::install: Handles package installation for debian based systems

### Parameters
`dns`

Optional.

Data type: Array

Allows you to specify an array of nameservers to use in resolv.conf. Default value: `[‘8.8.8.8’, ‘1.1.1.1’]`

`domains`

Optional.

Data type: Array

Allows you to specify an array of domains to include in the search path in resolv.conf. Default value: `[$::domain]`

`use_local`

Optional.

Data type: Boolean

Allows you to use a local nameserver such as named/bind.  Will set a nameserver entry of 127.0.0.1 as the first entry in resolv.conf if not using systemd-resolved. Will set 127.0.0.53 if using systemd-resolved. Default value: `true`

`fallback_dns`

Optional.

Data type: Array

Specify additional fallback nameservers to use in systemd-resolved configuration. Default value is an empty array.

`options`

Optional.

Specify options to place in /etc/resolv.conf such as ndots:5. Default value is an empty array. Only usable when use_systemd_resolved is `false` as systemd-resolved does not support configuring options.

## Limitations

This module has only been tested on the following distros:
* Ubuntu
  * 22.04
  * 24.04
* CentOS 8
* RHEL 9

This module uses a custom Hiera 5 backend and requires at least Puppet 4.9 due to this.

## Development

If you would like to contribute to the module, fork it and create a pull request when you're satisfied with your changes.
