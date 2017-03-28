# == Class: role_postgresql::analytics
#
class role_postgresql::analytics {

  # Postgres analytics scripts
  file { '/opt/postgresql':
    source  => 'puppet:///modules/role_postgresql/analytics',
    recurse => true,
  }

}
