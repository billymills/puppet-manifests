#unistall apache and remove files for testing

package { "httpd":
  ensure => 'purged',
}

#testing the removal of files
file { "/var/www":
  ensure  => absent,
  recurse => true,
  force   => true,
}

file { "/etc/httpd":
  ensure  => absent,
  recurse => true,
  force   => true,
}

file { "/var/www.billy.org":
  ensure  => absent,
  recurse => true,
  force   => true,
}

file { "/var/www.billy.com":
  ensure  => absent,
  recurse => true,
  force   => true,
}




