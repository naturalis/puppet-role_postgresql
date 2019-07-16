# == Class: role_postgresql
#
class role_postgresql (
  $version               = '11',
  $postgres_password     = 'password',
  $listen_address        = '*',
  $analytics             = false,
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
replicator:
  password_hash: 'password'
  replication: true
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
  description: 'allow all'
  type: 'host'
  database: 'all'
  user: 'all'
  address: '0.0.0.0/0'
  auth_method: 'md5'
replicator:
  description: 'replication'
  type: 'host'
  database: 'replication'
  user: 'replicator'
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
log_rotation_size:
  value: '0'
log_directory:
  value: '/var/log/postgresql'
log_min_duration_statement:
  value: '0'
log_min_messages:
  value: 'INFO'
wal_level:
  value: 'replica'
hot_standby:
  value: 'on'
archive_mode:
  value: 'on'
archive_command:
  value: 'test ! -f /tmp/%f && cp %p /tmp/%f'
...
  "
) {

  stage { 'first':
    before => Stage["main"],
  }

  # Set global parametes
  class { 'postgresql::globals':
    stage               => first,
    encoding            => 'UTF-8',
    locale              => 'en_US.UTF-8',
    manage_package_repo => true, 
    version             => $version
  }

  # Install PostgreSQL:
  class { 'postgresql::server':
    listen_addresses     => $listen_address,
    postgres_password    => $postgres_password
  }

  # Create databases
  if $db {
    create_resources(postgresql::server::db, parseyaml($db,$db))
  }

  # Create roles
  if $role {
    create_resources(postgresql::server::role, parseyaml($role,$role))
  }
  
  # Create grants
  if $database_grant {
    create_resources(postgresql::server::database_grant, parseyaml($database_grant,$database_grant))
  }

  # Remote connections
  if $pg_hba_rule {
    create_resources(postgresql::server::pg_hba_rule, parseyaml($pg_hba_rule,$pg_hba_rule))
  }

  # Config options
  if $config_entry {
    create_resources(postgresql::server::config_entry, parseyaml($config_entry,$config_entry))
  }

  # Analytics
  if $analytics {
    class { 'role_postgresql::analytics': }
  }
   
}
