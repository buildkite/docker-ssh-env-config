# docker-ssh-env-config

A Docker entrypoint wrapper which sets up SSH config files based on the following environment variables:

* `SSH_CONFIG` - contents of an SSH config file
* `SSH_KNOWN_HOSTS` - contents of an SSH known_hosts file
* `SSH_PRIVATE_RSA_KEY` - contents of an SSH private RSA key

You can also provide base64 encoded versions by prefixing `B64_` to the start of the environment variable name, useful for environments that don't support newlines.

Things to keep in mind:

* Any existing files in `~/.ssh` will be overwritten with these new values
* After writing the values to disk the environment variables are unset to help prevent accidental printing

## Usage

After adding it to the Dockerfile:

```Dockerfile
#...

ENV SSH_ENV_CONFIG_COMMIT=master

RUN curl -fL "https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/${SSH_ENV_CONFIG_COMMIT}/ssh-env-config.sh" -o /usr/local/bin/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh \

ENTRYPOINT ["ssh-env-config.sh","some-command"]
```

You can then configure SSH via environment variables:

```bash
docker run -e SSH_KNOWN_HOSTS="$(< ~/.ssh/known_hosts)" some-image
```

Or you can pass in the base64 encoded version:

```bash
docker run -e B64_SSH_KNOWN_HOSTS="$(base64 < ~/.ssh/github_rsa)" some-image
```