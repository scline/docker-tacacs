FROM ubuntu:14.04

MAINTAINER Sean Cline smcline06@gmail.com

# Update centos system
RUN apt-get -y update

# Install dependencies
RUN apt-get -y install supervisor tacacs+

# Copy configuration files
COPY src/supervisor/supervisord.conf /etc/supervisord.conf
COPY src/rsyslog/rsyslog_tac_plus.conf /etc/rsyslog.d/tac_plus.conf
COPY src/logrotate/tacacs.logrotate /etc/logrotate.d/tacacs
COPY tac_plus.conf /etc/tacacs+/tac_plus.conf

# Apply variables
RUN touch /var/log/tacacs_accounting.log

# Cleanup
RUN apt-get -y clean && \
	rm -rf /var/lib/apt/lists/*

# Tacacs
EXPOSE 49

# Run all the things!
CMD ["/usr/bin/supervisord"]
