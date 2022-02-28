# Puppet module to install and configure pihole

The development repository is located at: <https://gitlab.jaroker.org>.  A mirror repository is pushed to: <https://github.com/jjarokergc/puppet-pihole> for public access.

## Installation

Installation is from github clone

## Configuration

Configuration uses pihole's installation script in `unattended` mode.

## Managing pihole custom.list

See example in `collection.pp`.  Nodes use exported resources to report their
ip address and domain name.  The `pihole::collection` class aggregates this (using concat module) and creates the `custom.list` file used by pihole.

## Hiera Data

```yaml
# This is example hiera data used by the module
pihole::install:
  repo: 'https://github.com/pi-hole/pi-hole.git'
  path: 
    download: '/tmp/pihole'
    config: '/etc/pihole'
pihole::setup: # parameters in setupVar.conf to be enforced
  WEBPASSWORD: '<hash of password>'
  PIHOLE_INTERFACE: 'eth0' # primary listening interface
  PIHOLE_DNS_1: '208.67.222.222'
  PIHOLE_DNS_2: '208.67.220.220'
  DNSMASQ_LISTENING: 'all' # Allow queries from non-local networks (such as VPNs)
  REV_SERVER: 'true'       # Convert IPs to hostnames by checking with router
  REV_SERVER_CIDR: '192.168.0.0/16'
  REV_SERVER_TARGET: '192.168.1.1'
  REV_SERVER_DOMAIN: ''
pihole::ftldns: # parameters in pihole-FTL.conf
  BLOCKINGMODE: 'NULL' #NULL|IP-NODATA-AAAA|IP|NXDOMAIN
  PRIVACYLEVEL: '0' # Show everything
  PIHOLE_PTR: 'HOSTNAMEFQDN' # Host's global hostname
pihole::list:
  white-wild: # Wildcard whitelist for domain and subdomains
    - 'collegeboard.org'  # Oscar collegeboard
    - 'split.io'          # Oscar collegeboard
  whitelist: # Whitelist domains (no regex)
    - 'api-2-0.spot.im'   # WSJ comments enable
```

## Dependencies

* puppet stdlibs
* vcsrepo
* puppet accounts