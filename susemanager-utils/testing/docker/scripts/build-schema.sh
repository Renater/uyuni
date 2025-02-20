#!/bin/bash
set -e

# Prepare
cp -r /manager/schema /tmp
cd /tmp/schema/spacewalk

# Build the schema
make -f Makefile.schema SCHEMA=susemanager-schema VERSION=4.3 RELEASE=testing

if [ -d /etc/sysconfig/rhn/schema-upgrade ]; then
    # remove old migration directories before we install the new
    rm -r /etc/sysconfig/rhn/schema-upgrade
fi

# Install directories
install -m 0755 -d /etc/sysconfig/rhn
install -m 0755 -d /etc/sysconfig/rhn/postgres
install -m 0755 -d /etc/sysconfig/rhn/schema-upgrade

# Install sql files
install -m 0644 postgres/main.sql /etc/sysconfig/rhn/postgres
install -m 0644 postgres/end.sql /etc/sysconfig/rhn/postgres/upgrade-end.sql

( cd upgrade && tar cf - --exclude='*.sql' . | ( cd /etc/sysconfig/rhn/schema-upgrade && tar xf - ) )

