FROM bitnami/minideb:latest
RUN install_packages bash postgresql postgresql-client s3cmd
RUN rm -rf /var/cache/apt/*
COPY backup.sh /
WORKDIR /
ENTRYPOINT ["/backup.sh"]
