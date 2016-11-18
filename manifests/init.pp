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
  $listen_address = undef,
  $db_hash        = undef,
  $role_hash      = undef,
  $grant_hash     = undef,
  ) {

  class { 'postgresql::server':
    listen_addresses => $listen_address,
  }

  # Create databases
  $db_hash.each |$name, $db| {
    postgresql::server::db { $name:
      user     => $db["user"],
      password => postgresql_password($db["user"], $db["password"]),
    }
  }

  # Create roles
  $role_hash.each |$name, $role| {
    postgresql::server::role { $name:
      password_hash => postgresql_password($role["user"], $role["password"]),
    }
  }

  # Create grants
  $grant_hash.each |$name, $grant| {
    postgresql::server::database_grant { $name:
      privilege => $grant["privilege"],
      db        => $grant["db"],
      role      => $grant["role"],
    }
  }
  
  # Remote access
  $pg_hba_rule_hash.each |$name, $pg_hba_rule| {
    postgresql::server::pg_hba_rule { $name:
      description  => $pg_hba_rule["description"],
      type         => $pg_hba_rule["type"],
      database     => $pg_hba_rule["database"],
      user         => $pg_hba_rule["user"],
      auth_method  => $pg_hba_rule["auth_method"],
    }
  }
}
