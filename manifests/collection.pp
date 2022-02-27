# Manage custom.list on pihole
# Uses puppet concat standard library
class pihole::collection{

  # File to be assembled from exported fragments created by each node
  concat {'/etc/pihole/custom.list':
    ensure  => present,
    owner   => 'pihole',
    group   => 'pihole',
    mode    => '0644',
    notify  => Exec['Restart PiHole DNS'],
    require => Exec['Install Pihole'],
  }
  # Restart Pihole DNS after changing file
  exec {'Restart PiHole DNS':
    command     => '/bin/bash /usr/local/bin/pihole restartdns',
    refreshonly => true,
    returns     => 0,
  }

  # Heading for file
  concat::fragment {'Heading':
      target  => '/etc/pihole/custom.list',
      content => "### Managed by Puppet\n",
      order   => 1,
  }

  # Collect the fragments that were generated on each of the nodes
  Concat::Fragment <<| |>>



## TODO add other hosts that are not managed by puppet, such as ds3
}
