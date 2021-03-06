FROM prom/prometheus

ENV CONSUL_TEMPLATE_BIN /etc/prometheus/consul-template
ENV CONSUL_TEMPLATE_VERSION 0.19.3

# Install consul template
RUN set -e && \
    mkdir -p /tmp/consul && \
    cd /tmp/consul &&  \
    wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
    sha256sum -c consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS 2>&1 | grep OK && \
    unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
    mv consul-template ${CONSUL_TEMPLATE_BIN}
    #&& \
    #rm -rf /tmp

ENV TEMPLATE_FILE=/etc/prometheus/prometheus-template.yml \
    CONFIG_FILE=/etc/prometheus/prometheus.yml \
    CONSUL_SERVER=consul:8500

COPY prometheus-template.yml ${TEMPLATE_FILE}

COPY ./entry-point.sh /entry-point.sh
ENTRYPOINT ["/entry-point.sh"]
CMD ["--config.file=/etc/prometheus/prometheus.yml"]
