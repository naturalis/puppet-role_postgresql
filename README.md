# role_postgresql

#### Table of Contents

## Overview

Install and manage PostGreSQL using puppetlabs/postgresql module.

## Module Description

This is a wrapper module around puppetlabs/postgresql. It will install the database, create users, and dynamically configure settings like shared_buffers based on the amount of memory in your instance.

## Setup

    puppet apply -e 'include role_postgresql'

### Beginning with role_postgresql

Test with Vagrant. Move to directory vagrant:

    vagrant up
    vagrant ssh primary
    vagrant ssh secondary

## Usage

Default are set in yaml format in init.pp. Override using Foreman or hiera. 

## Test replication

Run on secondary:

    # Stop PostgreSQL:
    sudo systemctl stop postgresql
    
    # Move existing main directory:
    sudo mv /var/lib/postgresql/11/main /var/lib/postgresql/11/main.1

    # Must run as postgres user:
    sudo -u postgres pg_basebackup \
      --write-recovery-conf \
      --pgdata=/var/lib/postgresql/11/main \
      --host=192.168.56.5 \
      --username=replicator \
      --port=5432 \
      --progress \
      --verbose

    # Start PostgreSQL:
    sudo systemctl start postgresql
    
Check replication status on primary (master):

    vagrant ssh primary
    sudo -s
    su postgres
    psql
    select * from pg_stat_replication;

Check replication status on secondary (slave):

    vagrant ssh secondary
    sudo -s
        
    watch -n 2 "ps -aux | grep streaming"
    
    su postgres
    psql
    select * from pg_stat_wal_receiver;
    
To promote slave to master:

    pg_ctlcluster 11 main promote

## Limitations

Tested with Ubuntu 18.04, Puppet 5, PostgreSQL 11.
