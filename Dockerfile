FROM alpine

RUN apk add --update bash && rm -rf /var/cache/apk/*

ADD ssh-env-config.sh /usr/bin/
RUN chmod +x /usr/bin/ssh-env-config.sh

ENTRYPOINT ["ssh-env-config.sh"]
