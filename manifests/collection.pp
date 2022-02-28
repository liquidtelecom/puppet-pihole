# Manage custom.list on pihole
# Uses puppet concat standard library
#
# Example export
#
# # Local DNS Exported Resource
# @@concat::fragment {$::fqdn:
#     target  => '/etc/pihole/custom.list',
#     content => "${::ipaddress} ${::fqdn}\n",
#     order   => 10,
# }
#
class pihole::collection{

  # File to be assembled from exported fragments created by each node
  concat {'/etc/pihole/custom.list':
    ensure  => present,
    owner   => 'pihole',
    group   => 'pihole',
    mode    => '0644',
    notify  => Exec['Update Pihole'],
    require => Exec['Install Pihole'],
  }

  # Heading for file
  concat::fragment {'Heading':
      target  => '/etc/pihole/custom.list',
      content => "### Managed by Puppet\n",
      order   => 1,
  }

  # Collect the fragments that were generated on each of the nodes
  Concat::Fragment <<| |>>

}
