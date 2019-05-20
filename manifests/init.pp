# == Class: role_postgresql
#
class role_postgresql (
  $version               = '9.6',
  $postgres_password     = 'password',
  $listen_address        = '*',
  $analytics             = true,
  $cron_job_hash         = undef,
  $db = "
---
db1:
  user: 'db1_user'
  password: 'password'
db2:
  user: 'db2_user'
  password: 'password'
...
  ",
  $role = "
---
user1:
  password_hash: 'password'
analytics:
  password_hash: 'password'
...
  ",
  $database_grant = "
---
analytics:
  privilege: 'CONNECT'
  db: 'db1'
  role: 'analytics'
...
  ",
  $pg_hba_rule = "
---
all:
  description: 'Allow all'
  type: 'host'
  database: 'all'
  user: 'all'
  address: '0.0.0.0/0'
  auth_method: 'md5'
...
  ",  
  $config_entry = "
---
logging_collector:
  value: 'on'
log_destination:
  value: 'csvlog'
log_filename:
  value: 'pglog'
log_file_mode:
  value: '0644'
log_truncate_on_rotation:
  value: 'on'
log_rotation_age:
  value: '1d'
log_rotation_age:
  value: '1d'
log_rotation_size:
  value: '0'
log_directory:
  value: '/var/log/postgresql'
log_min_duration_statement:
  value: '0'
log_min_messages:
  value: 'INFO'
...
  "
) {

  $_db = parseyaml($db)
  $_role = parseyaml($role)
  $_database_grant = parseyaml($database_grant)
  $_pg_hba_rule = parseyaml($pg_hba_rule)
  $_config_entry = parseyaml($config_entry)

  # Set global parametes
  class { 'postgresql::globals':
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
    manage_package_repo => true, 
    version             => $version
  }

  # Install PostGreSQL:
  class { 'postgresql::server':
    listen_addresses  => $listen_address,
    postgres_password => $postgres_password
  }

  # Create databases
  create_resources(postgresql::server::db, $_db)

  # Create roles
  create_resources(postgresql::server::role, $_role)

  # Create grants
  create_resources(postgresql::server::database_grant, $_database_grant)

  # Remote connections
  create_resources(postgresql::server::pg_hba_rule, $_pg_hba_rule)

  # Config options
  create_resources(postgresql::server::config_entry, $_config_entry)

  # Analytics
  if $analytics {
    class { 'role_postgresql::analytics': }
  }
   
}
