FROM alpine:latest
RUN apk add --no-cache rsyslog
# Konfiguration direkt im Image fixieren
RUN echo '$ModLoad imudp' > /etc/rsyslog.conf && \
    echo '$UDPServerRun 514' >> /etc/rsyslog.conf && \
    echo '*.* /dev/stdout' >> /etc/rsyslog.conf

EXPOSE 514/udp
CMD ["rsyslogd", "-n", "-f", "/etc/rsyslog.conf"]
