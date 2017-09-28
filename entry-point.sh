#!/bin/sh

set -ex

if [ "${1:0:1}" = '-' ]; then

	exec ${CONSUL_TEMPLATE_BIN} -consul-addr=${CONSUL_SERVER:-consul:8500} -template=${TEMPLATE_FILE}:${CONFIG_FILE} -exec="/bin/prometheus $@"
else
	exec "$@"
fi