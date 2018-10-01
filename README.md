# snmpd-docker-slim

snmpd config path /opt/etc/snmp/snmpd.conf

```
docker run -d -v /proc:/host_proc \
--name snmpd \
--read-only \
--privileged \
--net=host \
-p 161:161/udp \
--tmpfs /var/net-snmp \
kyos0109/snmpd-docker-slim
```         

---
Thanks.

https://hub.docker.com/r/really/snmpd/
