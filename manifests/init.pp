# == Class: role_postgresql
#
class role_postgresql (
  $version               = undef,
  $listen_address        = undef,
  $db_hash               = undef,
  $role_hash             = undef,
  $grant_hash            = undef,
  $pg_hba_rule_hash      = undef,
  $analytics             = true,
  $cron_job_hash         = undef,
  $config_values_static  = undef,
  $config_values_dynamic = { 'shared_buffers'       => $facts['memory']['system']['total_bytes'] * 1/8192,
                             'effective_cache_size' => $facts['memory']['system']['total_bytes'] * 2/4
                           },
  $config_values         = deep_merge($config_values_dynamic, $config_values_static)
  ) {

  # Set global parameters
  class { 'postgresql::globals':
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
    manage_package_repo => true, 
    version             => $version
  }

  # Install PostGreSQL:
  class { 'postgresql::server':
    listen_addresses => $listen_address,
    #require          => Class['postgresql::globals']
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

  # Remote connections
  $pg_hba_rule_hash.each |$name, $pg_hba_rule| {
    postgresql::server::pg_hba_rule { $name:
      description => $pg_hba_rule["description"],
      type        => $pg_hba_rule["type"],
      database    => $pg_hba_rule["database"],
      user        => $pg_hba_rule["user"],
      address     => $pg_hba_rule["address"],
      auth_method => $pg_hba_rule["auth_method"],
    }
  }

  # Configure options in postgresql.conf
  $config_values.each |$key, $value| {
    postgresql::server::config_entry { $key:
      value => $value
    }
  }

  # Analytics
  if $analytics {
    class { 'role_postgresql::analytics': }
  }
   
}
