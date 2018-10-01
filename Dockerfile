FROM scratch
ADD files.tar.xz /
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV SSL_CERT_FILE "/etc/ssl/certs/ca-certificates.crt"
EXPOSE 161/tcp
EXPOSE 161/udp
ENTRYPOINT ["/opt/sbin/snmpd","-f","-Loe","-c","/opt/etc/snmp/snmpd.conf"]
