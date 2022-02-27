#
# Install Pihole from github
#
class pihole::install {

  # VARIABLES
  $phi = lookup('pihole::install')    # Installation parameters
  $phs = lookup('pihole::setup')      # Setup variables

  # Network Interface
  $netmask_cidr = extlib::netmask_to_cidr($::netmask)
  $ipv4_address = "${::ipaddress}/${netmask_cidr}"

  # Download pihole
  vcsrepo { $phi['path']['download'] :
    ensure   => present,
    provider => git,
    source   => $phi['repo'],
    depth    => 1,
  }

  # User and group
  accounts::user { 'pihole':
  uid      => 1998,
  gid      => 1998,
  groups   => ['www-data'],
  password => '!!',
  system   => true,
  shell    => '/usr/sbin/nologin',
  }

  # Pre-seed variables for unattended install
  file {$phi['path']['config']:
    ensure => directory,
    group  => 'pihole',
    owner  => 'pihole',
    mode   => '0755',
  }
  file { "${phi['path']['config']}/setupVars.conf" :
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('pihole/setupVars.conf.epp',
        {
        'phs'          => $phs,
        'ipv4_address' => $ipv4_address,
        }
      ),
    require => File[ $phi['path']['config'] ],
  }

  # Install pihole
  exec{'Install Pihole':
    path        => '/usr/bin:/usr/sbin:/bin',
    user        => 'root',
    command     => [
        '/bin/bash',
        "${phi['path']['download']}/automated install/basic-install.sh",
        '--unattended',
        ],
    environment => [
        'USER=pihole',
        ],
    creates     => '/usr/local/bin/pihole',
    require     => [
        Vcsrepo[ $phi['path']['download'] ],
        File[ "${phi['path']['config']}/setupVars.conf" ],
        ],
  }

  # Update pihole upon config changes
  exec { 'Update Pihole':
    path        => ['/bin/', '/usr/bin', '/usr/local/bin/'],
    command     => 'pihole -g',
    user        => 'root',
    subscribe   => File[ "${phi['path']['config']}/setupVars.conf" ],
    refreshonly => true,
  }
}
