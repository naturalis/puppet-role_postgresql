# role_postgresql

#### Table of Contents

## Overview

Install and manage PostGreSQL using puppetlabs/postgresql module.

## Module Description

This is a wrapper module around puppetlabs/postgresql. It will install the database, create users, and dynamically configure settings like shared_buffers based on the amount of memory in your instance.

## Setup

    puppet apply -e 'include role_postgresql'

### Beginning with role_postgresql

Test with Vagrant. See directory vagrant.

    vagrant up

## Usage

Default are set in yaml format in init.pp. Override using Foreman or hiera. 

## Test replication

Run on secondary:

    systemctl stop postgresql

    pg_basebackup \
      --write-recovery-conf \
      --pgdata=/var/lib/postgresql/11/main \
      --host=192.168.56.5 \
      --username=replicator \
      --port=5432 \
      --progress \
      --verbose

    systemctl start postgresql
    
Check replication status on master:

    select * from pg_stat_replication;

Check replication status on slave:

    select * from pg_stat_wal_receiver;
    watch -n 2 "ps -aux | grep streaming"

## Limitations

Tested with Ubuntu 18.04, Puppet 5, PostgreSQL 11.
