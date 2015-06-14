# -*- encoding : utf-8 -*-

$mewpipe_database = ['mewpipe_development']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'
$mewpipe      = '/vagrant/'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':
    unless => "test -e ${home}/.rvm"
  }

  include locales
}

class { 'apt_get_update':
  stage => preinstall
}

# --- SQLite -------------------------------------------------------------------

package { ['sqlite3', 'libsqlite3-dev']:
  ensure => installed;
}

# --- PostgreSQL ---------------------------------------------------------------

class install_postgres {
  class { 'postgresql': }

  class { 'postgresql::server': }

  pg_database { $mewpipe_database:
    ensure   => present,
    encoding => 'UTF8',
    owner    => 'mewpipe',
    require  => [ Class['postgresql::server'], Pg_user['mewpipe']]
  }

  pg_user { 'vagrant':
    ensure    => present,
    superuser => true,
    require   => Class['postgresql::server']
  }

  pg_user { 'mewpipe':
    ensure    => present,
    superuser => true,
    password  => 'password',
    require   => Class['postgresql::server']
  }

  package { 'libpq-dev':
    ensure => installed
  }
}
class { 'install_postgres': }

# --- Memcached ----------------------------------------------------------------

class { 'memcached': }

# --- Packages -----------------------------------------------------------------

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}
package { 'postgresql-contrib':
  ensure => installed
}

# Nokogiri dependencies.
  package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
    ensure => installed
  }


# ExecJS runtime.
package { 'nodejs':
  ensure => installed
}

# OpenJDK 6
package { 'openjdk-6-jre':
  ensure => installed
}

# ImageMagick
package { 'imagemagick':
  ensure => installed
}

#--- FFMPEG --------------------------
  package { ['software-properties-common', 'python-software-properties']:
    ensure => installed
  }

  exec { 'add_fmmpeg_repo':
    command => "sudo add-apt-repository ppa:samrog131/ppa",
    require => [ Package['software-properties-common'], Package['python-software-properties'] ]
  }

  exec {'apt_get_update_again':
    command => 'sudo apt-get update',
    require => [Exec['add_fmmpeg_repo']]

  }

  package { 'ffmpeg':
    ensure => installed,
    require => [Exec['apt_get_update_again']]
  }



# --- Ruby ---------------------------------------------------------------------

# Download GPG keys for RVM
exec { 'dl_gpg_keys':
  command => "${as_vagrant} 'curl -sSL https://rvm.io/mpapis.asc | gpg --import -'"
}

# Install RVM
exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm/bin/rvm",
  require => [ Exec['dl_gpg_keys'], Package['curl'] ]
}

# Install Ruby 2.1.6
exec { 'install_ruby':
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install ruby-2.2.2 --autolibs=enabled && rvm alias create default 2.2.2'",
  creates => "${home}/.rvm/bin/ruby",
  timeout => 1000,
  require => Exec['install_rvm']
}

# Install Bundler
exec { 'install_bundler':
  command => "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'",
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}

# --- MEWPIPE --------------------------------------------------------------------

# Install project gems
exec { 'bundle_update':
  command => "${as_vagrant} 'bundle'",
  cwd => "${mewpipe}",
  timeout => 600,
  require => [ Exec['install_bundler'], Package['git-core'] ]
}

# Migrate development database
exec { 'migrate_development_database':
  command => "${as_vagrant} 'rake db:migrate'",
  cwd => "${mewpipe}",
  require => [ Exec['bundle_update'], Class['install_postgres'] ]
}

# Create & migrate test database
exec { 'prepare_test_database':
  command => "${as_vagrant} 'rake db:test:prepare'",
  cwd => "${mewpipe}",
  require => Exec['migrate_development_database']
}

# Populate development database
exec { 'populate_development_database':
  command => "${as_vagrant} 'rake db:populate'",
  cwd => "${mewpipe}",
  timeout => 600,
  require => Exec['migrate_development_database']
}
