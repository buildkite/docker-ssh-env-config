FROM alpine

ADD ssh-env-config.sh /usr/bin/
RUN chmod +x /usr/bin/ssh-env-config.sh

ENTRYPOINT ["ssh-env-config.sh"]
