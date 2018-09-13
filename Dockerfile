FROM prom/prometheus

ENV CONSUL_TEMPLATE_BIN /bin/consul-template
ENV CONSUL_TEMPLATE_VERSION 0.19.3

EXPOSE 9090

# Install consul template
RUN set -e && \
    mkdir -p /tmp/consul && \
    cd /tmp/consul &&  \
    wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
    sha256sum -c consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS 2>&1 | grep OK && \
    unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
    sudo mv consul-template /bin/consul-template && \
    rm -rf /tmp

ENV TEMPLATE_FILE=/etc/prometheus/prometheus-template.yml \
    CONFIG_FILE=/etc/prometheus/prometheus.yml \
    CONSUL_SERVER=localhost:8500

COPY prometheus-template.yml ${TEMPLATE_FILE}

COPY ./entry-point.sh /entry-point.sh
ENTRYPOINT ["/entry-point.sh"]
CMD ["-config.file=/etc/prometheus/prometheus.yml"]
