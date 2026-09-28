FROM ubuntu/jdk:25-26.04_stable

USER root

COPY files/dc-server /opt/dc-server

ARG arg_memxmx='1024m'
ARG arg_ip='0.0.0.0'
ARG arg_port='9000'
ARG arg_imageserverport='8082'
ARG arg_webserverport='8080'
ARG arg_apiserverport='8081'
ARG arg_hostname='0.0.0.0'

ENV XMX=$arg_memxmx
ENV IP=$arg_ip
ENV PORT=$arg_port
ENV IMAGESERVERPORT=$arg_imageserverport
ENV WEBSERVERPORT=$arg_webserverport
ENV APISERVERPORT=$arg_apiserverport
ENV HOSTNAME=$arg_hostname
ENV PUBLICURL=''
ENV USERACC=''

WORKDIR /opt/dc-server

COPY --chmod=755 <<'EOT' /entrypoint.sh
#!/usr/bin/env bash
java -Xmx$XMX \
  -jar /opt/dc-server/datacrow-server.jar \
  -hostname:$HOSTNAME \
  -bindto:$IP \
  -userdir:/opt/dc-user \
  -port:$PORT \
  -imageserverport:$IMAGESERVERPORT \
  -webserverport:$WEBSERVERPORT \
  -apiserverport:$APISERVERPORT \
  -api_address_overrule:$PUBLICURL \
  -credentials:$USERACC
EOT

ENTRYPOINT ["/entrypoint.sh"]

