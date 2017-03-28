# == Class: role_postgresql::analytics
#
class role_postgresql::analytics {

  # Contrib package for pg_stat_statements, pg_buffercache
  class { 'postgresql::server::contrib':
    package_name => 'postgresql-contrib'
  }

  # Postgres analytics scripts
  file { '/opt/postgresql':
    source  => 'puppet:///modules/role_postgresql',
    recurse => true,
  }

}
