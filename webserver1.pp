# webserver1.pp

class apache {

  # run first
  # pulls index.html from github for billy.org
  vcsrepo { "clone_html":
    path     => "/var/www.billy.org/html",
    ensure   => present,
    provider => git,
    source   => "git://github.com/billymills/html-repo.git",
    before   => Vcsrepo['clone_html_2'],
  }

  # run second
  # pulls html docs for second site
  vcsrepo { "clone_html_2":
    path     => "/var/www.billy.com/html",
    ensure   => present,
    provider => git,
    source   => "git://github.com/billymills/html-repo-2.git",
    before   => Package['httpd'],
  }

  # run third
  # install httpd
  package { 'httpd':
    ensure => 'present',
    before => File['httpd.conf'],
  }


  # run fourth
  # verifying .conf file
  file { 'httpd.conf':
    path     => "/etc/httpd/conf/httpd.conf",
    ensure   => file,
    source   => "/etc/httpd/conf/httpd.conf",
    before   => Vcsrepo['clone_vhost'],
  }

  # run fifth
  # clones vhost information
  vcsrepo {"clone_vhost":
    path     => "/var/www/vhost",
    ensure   => "present",
    provider => git,
    source   => "git://github.com/billymills/conf-repo.git",
    before   => File["/etc/httpd/conf.d/www.billy.org.conf"],
  } 

  # run sixth
  # copying vhost information to correct directoy
  file {"/etc/httpd/conf.d/www.billy.org.conf":
    ensure => "present",
    source => "/var/www/vhost/www.billy.org.conf",
    before => Service['httpd'],
  }

  # run seventh
  # start the service last to capture virtual host in conf
  service { 'httpd':
    ensure     => 'running',
    subscribe  => File['httpd.conf'],
  }

}




# call the class
class { "apache": 
}


