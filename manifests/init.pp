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
class role_postgresql {

  class { 'postgresql::server': }

  postgresql::server::role { 'marmot':
    password_hash => postgresql_password('marmot', 'mypasswd'),
  }

  postgresql::server::database_grant { 'test1':
    privilege => 'ALL',
    db        => 'test1',
    role      => 'marmot',
  }

  postgresql::server::table_grant { 'my_table of test2':
    privilege => 'ALL',
    table     => 'my_table',
    db        => 'test2',
    role      => 'marmot',
  }

}
