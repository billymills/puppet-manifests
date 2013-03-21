$mysql_root_pw = 'puppet'

# installs mysql server
class { 'mysql::server': 
  # set root password
  config_hash       => {
      root_password => 'puppet',
  }
}

# creates database and user
mysql::db { 'mydb':
    user     => 'myuser',
    password => 'mypass',
    host     => 'localhost',
    grant    => ['all'],
    require  => Class['mysql::server'],
}

# creates user
database_user {'billy@localhost':
  ensure        => present,
  password_hash => mysql_password('billy'),
  require       => Class['mysql::server'],
}

