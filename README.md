# docker-ssh-env-config

A Docker entrypoint wrapper which sets up SSH config files based on the following environment variables:

* `SSH_CONFIG` - contents of an SSH config file
* `SSH_KNOWN_HOSTS` - contents of an SSH known_hosts file
* `SSH_PRIVATE_RSA_KEY` - contents of an SSH private RSA key
* `SSH_DEBUG` - enables SSH debug logging

You can also provide base64 encoded versions by adding `_B64` to the end of the environment variable (e.g. `SSH_PRIVATE_RSA_KEY_B64`)—useful for environments that don't support newlines.

Things to keep in mind:

* Any existing files in `~/.ssh` will be overwritten with these new values
* After writing the values to disk the environment variables are unset to help prevent accidental printing

## Usage

After adding it to the Dockerfile:

```Dockerfile
#...

# You should use a commit hash rather than "master" in your own version of the below
RUN curl -fL "https://raw.githubusercontent.com/buildkite/docker-ssh-env-config/master/ssh-env-config.sh" -o /usr/local/bin/ssh-env-config.sh \
    && chmod +x /usr/local/bin/ssh-env-config.sh \

ENTRYPOINT ["ssh-env-config.sh","some-command"]
```

You can then configure SSH via environment variables:

```bash
docker run -e SSH_KNOWN_HOSTS="$(< ~/.ssh/known_hosts)" some-image
```

Or you can pass in the base64 encoded version:

```bash
docker run -e SSH_KNOWN_HOSTS_B64="$(base64 < ~/.ssh/github_rsa)" some-image
```
