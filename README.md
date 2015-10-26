# docker-ssh-env-config

A Docker entrypoint wrapper which sets up SSH config files based on the following environment variables:

* `SSH_CONFIG` - contents of an SSH config file
* `SSH_KNOWN_HOSTS` - contents of an SSH known_hosts file
* `SSH_PRIVATE_RSA_KEY` - contents of an SSH private RSA key

The environment variables are unset after the files are created to help prevent accidental output in logs

Example usage in a Dockerfile:

```Dockerfile
#...

RUN curl -fL "https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh" -o /usr/local/bin/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh \

ENTRYPOINT ["ssh-env-config.sh","some-command"]
```

Example usage when starting a container:

```bash
docker run -e SSH_KNOWN_HOSTS="$(< ~/.ssh/known_hosts)" some-image
```
