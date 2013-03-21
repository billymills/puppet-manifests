# webserver2.pp

class apache_setup {

  # first clone directory from github
  # testing this with cloning the conf file
  # as part of the directory structure
  vcsrepo { "clone_html":
    path     => "/var/www.billy.org",
    ensure   => present,
    provider => git,
    source   => "git://github.com/billymills/html-repo-3.git",
    before => Package['httpd'],
  }

  # next install http package
  package { 'httpd':
    ensure => 'present',
    before => File['httpd.conf'],
  }

  # verify .conf file
  file { 'httpd.conf':
    path   => "/etc/httpd/conf/httpd.conf",
    ensure => file,
    source => "/etc/httpd/conf/httpd.conf",
    before => File['/etc/httpd/conf.d/www.billy.org.conf'],
  }

  # copy vhost information to correct location
  file { "/etc/httpd/conf.d/www.billy.org.conf":
    ensure => 'present',
    source => "/var/www.billy.org/conf/www.billy.org.conf",
    before => Service['httpd'],
  }

  # start httpd to capture virtual host info
  service { 'httpd':
    ensure    => 'running',
    subscribe => File['httpd.conf'],
  }

}

/*
class mysql_server {

  # installs mlysql-server packages, configures my.cnf and starts msqld
  package { "mysql-server":
    ensure => installed,
  }

  #installs the mysql-client package
  # package { "mysql":
  #  ensure => installed,
  # }

  service { "mysqld":
    enable  => true,
    ensure  => running,
    require => Package["mysql-server"],
  }

  # exec { "set-mysql-password":
  #  path    => ["/bin", "/usr/bin"],
  #  command => "mysqladmin -u user password 'hello'",
  #  require => Service["mysqld"],
  # }

  }
*/

class mysql_setup {
  
  $mysql_root_pw = 'puppet'

  # install and setup mysql server
  class { 'mysql::server':
    config_hash => {
      root_password => 'puppet',
    }
  }

  class { 'mysql': }

  # create a database
  mysql::db { 'mydb':
    user     => 'myuser',
    password => 'mypass',
    host     => 'localhost',
    grant    => ['all'],
    require  => Class['mysql::server'],
  }
  
  # create another user
  database_user { 'billy@localhost':
    ensure        => present,
    password_hash => mysql_password('billy'),
    require       => Class['mysql::server'],
  }

}

class php {

  package { 'php':
    ensure => installed,
  }

}

# call the classes
class { "apache_setup": 
  before => Class['mysql'],
}

class { "mysql_setup": 
  before => Class['php'],
}

class { "php": }
