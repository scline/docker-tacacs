FROM ubuntu:14.04

MAINTAINER Sean Cline scline@riotgames.com

# Update centos system
RUN apt-get -y update

# Install dependencies
RUN apt-get -y install supervisor tacacs+

# Copy configuration files
COPY src/supervisor/supervisord.conf /etc/supervisord.conf
COPY src/rsyslog/rsyslog_tac_plus.conf /etc/rsyslog.d/tac_plus.conf
COPY src/scripts/configure.sh /scripts/configure.sh
COPY src/logrotate/tacacs.logrotate /etc/logrotate.d/tacacs
COPY tac_plus.conf /etc/tacacs+/tac_plus.conf

# Variables
ENV SYSLOG_TARGET 1.1.1.1

# Apply variables
RUN /bin/bash /scripts/configure.sh && \
	touch /var/log/tacacs.log

# Cleanup
RUN apt-get -y clean && \
	rm -rf /var/lib/apt/lists/* && rm /scripts/*.sh

# Tacacs
EXPOSE 49

# Run all the things!
CMD ["/usr/bin/supervisord"]
