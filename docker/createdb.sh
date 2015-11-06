#!/bin/bash

__mod_user() {
usermod -G wheel postgres
}

__create_db() {
su --login postgres --command "/usr/pgsql-9.3/bin/postgres -D /var/lib/pgsql/9.3/data -p 5432" &
sleep 10
ps aux

su --login - postgres --command "psql -c \"CREATE USER pr with CREATEROLE superuser PASSWORD 'pr123';\""
su --login - postgres --command "psql -c \"CREATE DATABASE pr OWNER pr;\""
su --login - postgres --command "psql -c \"\du;\""
}

# Call functions
__mod_user
__create_db
