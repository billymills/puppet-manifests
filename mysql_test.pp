class mysql-server {
  $password = "root"
  package { "mysql-server":
    ensure => installed,
  }

  package { "mysql":
    ensure => installed,
  }

  package { "mysql-shared":
    ensure => installed,
  }

  exec { "Set MySQL server root password":
    subscribe   => [ Package["mysql-server"], Package["mysql"], Package["mysql-shared"]  ],
    refreshonly => true,
    unless      => "mysqladmin -uroot -p$password status",
    path        => "/bin:/usr/bin",
    command     => "mysqladmin -uroot password $password",
  }

}

class { "mysql-server": }
