package { "mysql-server":
  ensure => 'purged',
}

package { "mysql":
  ensure => 'purged',
}

# remove my.cnf file
file { "/etc/my.cnf":
  ensure => absent,
}

package { "php":
  ensure => 'purged',
}


