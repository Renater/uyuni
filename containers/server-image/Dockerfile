# SPDX-License-Identifier: MIT
#!BuildTag: uyuni/server:latest

ARG INIT_IMAGE=uyuni/init:latest
FROM $INIT_IMAGE

ARG PRODUCT_PATTERN_PREFIX="patterns-uyuni"

COPY timezone_alignment.sh /usr/bin

# Copy timezone link update service
COPY timezone_alignment.service /usr/lib/systemd/system/

COPY remove_unused.sh .
RUN echo "rpm.install.excludedocs = yes" >>/etc/zypp/zypp.conf

# Main packages
RUN zypper ref && zypper --non-interactive up
RUN zypper --gpg-auto-import-keys --non-interactive install --auto-agree-with-licenses --force-resolution \
    ${PRODUCT_PATTERN_PREFIX}_server \
    ${PRODUCT_PATTERN_PREFIX}_retail \
    spacewalk-utils-extras \
    shim \
    grub2-x86_64-efi \
    ed \
    susemanager-tftpsync \
    golang-github-prometheus-node_exporter \
    prometheus-postgres_exporter \
    golang-github-QubitProducts-exporter_exporter \
    prometheus-jmx_exporter \
    prometheus-jmx_exporter-tomcat \
    spacecmd \
    grafana-formula \
    locale-formula \
    prometheus-exporters-formula \
    prometheus-formula \
    registry-formula \
    virtualization-formulas \
    uyuni-config-formula \
    inter-server-sync \
    golang-github-lusitaniae-apache_exporter \
    golang-github-prometheus-node_exporter \
    prometheus-postgres_exporter \
    golang-github-QubitProducts-exporter_exporter \
    prometheus-jmx_exporter \
    spacecmd \
    javamail \
    libyui-ncurses-pkg16 \
    virtual-host-gatherer-Kubernetes \
    virtual-host-gatherer-libcloud \
    virtual-host-gatherer-Libvirt \
    virtual-host-gatherer-Nutanix \
    virtual-host-gatherer-VMware \
    vim \
    ipmitool

RUN sed -i 's/sysctl kernel.shmmax/#sysctl kernel.shmmax/g' /usr/bin/uyuni-setup-reportdb

RUN mkdir -p /etc/postgres_exporter \
             /etc/prometheus-jmx_exporter/tomcat \
             /usr/lib/systemd/system/tomcat.service.d \
             /etc/prometheus-jmx_exporter/taskomatic \
             /usr/lib/systemd/system/taskomatic.service.d

COPY postgres_exporter_queries.yaml /etc/postgres_exporter/postgres_exporter_queries.yaml
COPY postgres-exporter /etc/sysconfig/prometheus-postgres_exporter
COPY java_agent.yaml /etc/prometheus-jmx_exporter/tomcat/java_agent.yml
COPY java_agent.yaml /etc/prometheus-jmx_exporter/taskomatic/java_agent.yml
COPY tomcat_jmx.conf /usr/lib/systemd/system/tomcat.service.d/jmx.conf
COPY taskomatic_jmx.conf /usr/lib/systemd/system/taskomatic.service.d/jmx.conf

RUN chmod -R 755 /usr/bin/timezone_alignment.sh

RUN systemctl enable prometheus-node_exporter; \
    systemctl enable uyuni-setup; \
    systemctl enable timezone_alignment;

# LABELs
ARG PRODUCT=Uyuni
ARG VENDOR="Uyuni project"
ARG URL="https://www.uyuni-project.org/"
ARG REFERENCE_PREFIX="registry.opensuse.org/uyuni"

# Build Service required labels
# labelprefix=org.opensuse.uyuni.server
LABEL org.opencontainers.image.name=server-image
LABEL org.opencontainers.image.title="${PRODUCT} server container"
LABEL org.opencontainers.image.description="All-in-one ${PRODUCT} server image"
LABEL org.opencontainers.image.created="%BUILDTIME%"
LABEL org.opencontainers.image.vendor="${VENDOR}"
LABEL org.opencontainers.image.url="${URL}"
LABEL org.opencontainers.image.version=4.4.1
LABEL org.openbuildservice.disturl="%DISTURL%"
LABEL org.opensuse.reference="${REFERENCE_PREFIX}/server:4.4.1.%RELEASE%"
# endlabelprefix

CMD ["/usr/lib/systemd/systemd"]
HEALTHCHECK --interval=5s --timeout=5s --retries=5 CMD ["/usr/bin/systemctl", "is-active", "multi-user.target"]
