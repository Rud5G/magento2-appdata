FROM alpine:latest

RUN apk add --no-cache \
		bash \
		sed \
		tar

ENV MAGENTO_VERSION CE-2.2.6

COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh && \
    ln -s /usr/local/bin/startup.sh /startup.sh

COPY magento-${MAGENTO_VERSION} /usr/src/magento

WORKDIR /var/www/html

CMD ["startup.sh"]

