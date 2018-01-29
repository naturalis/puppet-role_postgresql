# == Class: role_postgresql::pg_hba
#
class role_postgresql::pg_hba {

  include postgresql::server

  # Remote connections
  $pg_hba_rule_hash.each |$name, $pg_hba_rule| {
    postgresql::server::pg_hba_rule { $name:
      description  => $pg_hba_rule["description"],
      type         => $pg_hba_rule["type"],
      database     => $pg_hba_rule["database"],
      user         => $pg_hba_rule["user"],
      address      => $pg_hba_rule["address"],
      auth_method  => $pg_hba_rule["auth_method"],
    }
  }

}
