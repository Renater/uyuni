#!/bin/bash
set -xe
src_dir=$(cd $(dirname "$0")/../.. && pwd -P)

echo opensuseminionproductuuid > /tmp/opensuse_product_uuid

sudo -i podman run --privileged --rm -d --network uyuni-network-1 -v /tmp/opensuse_product_uuid:/sys/class/dmi/id/product_uuid -v /tmp/test-all-in-one:/tmp -v ${src_dir}/testsuite/podman_runner/salt-minion-entry-point.sh:/salt-minion-entry-point.sh --volume /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro --name sle_minion -h sle_minion ghcr.io/$UYUNI_PROJECT/uyuni/ci-test-opensuse-minion:$UYUNI_VERSION bash -c "/salt-minion-entry-point.sh uyuni-server-all-in-one-test 1-SUSE-KEY-x86_64"
sudo -i podman exec sle_minion bash -c "ssh-keygen -A && /usr/sbin/sshd -e"
sudo -i podman exec sle_minion bash -c "if [ ! -d /root/.ssh ];then mkdir /root/.ssh/;chmod 700 /root/.ssh;fi;cp /tmp/authorized_keys /root/.ssh/"
