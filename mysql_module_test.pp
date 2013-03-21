$mysql_root_pw = 'puppet'

class { 'mysql::server': 
  config_hash       => {
      root_password => 'puppet',
  }
  # before    => Class['mysql'],
}

mysql::db { 'mydb':
    user     => 'myuser',
    password => 'mypass',
    host     => 'localhost',
    grant    => ['all'],
    require  => Class['mysql::server'],
}

database_user {'billy@localhost':
  ensure        => present,
  password_hash => mysql_password('billy'),
  require       => Class['mysql::server'],
}



/*
class { 'mysql': 
  # before => Class['new_user'],
}

class new_user {
  mysql::db { 'mydb':
    user     => 'myuser',
    password => 'mypass',
    host     => 'localhost',
    grant    => ['all'],
  }
}

class { 'new_user': 
  require => Class['mysql::server'],

}
*/
