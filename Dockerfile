FROM fluent/fluentd:v1.12

USER root

RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install fluent-plugin-elasticsearch \
 && sudo gem install fluent-plugin-kubernetes_metadata_filter \
 && sudo gem install fluent-plugin-multi-format-parser \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

COPY entrypoint.sh /bin/
COPY fluent.conf /fluentd/etc/fluent.conf
COPY config.d /fluentd/etc/config.d

ENV FLUENTD_CLUSTER_NAME fluentd
ENV ELASTICSEARCH_HOSTS http://elasticsearch:9200
