# == Class: role_postgresql
#
# Full description of class role_postgresql here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'role_postgresql':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class role_postgresql (
  $listen_address = '*',
  $db_hash        = undef,
  ) {

  class { 'postgresql::server':
    listen_addresses => $listen_address,
  }

  # Create databases (Puppet 4 only)
  $db_hash.each |$name, $db| {
    postgresql::server::db { $name:
      user     => $db["user"],
      password => postgresql_password($db["user"], $db["password"]),
    }
  }

  postgresql::server::role { 'marmot':
    password_hash => postgresql_password('marmot', 'mypasswd'),
  }

  postgresql::server::database_grant { 'mydatabasename':
    privilege => 'ALL',
    db        => 'mydatabasename',
    role      => 'marmot',
  }

}
