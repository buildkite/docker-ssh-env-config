#!/bin/bash

# This command wrapper sets up SSH config files based on the following
# environment variables:
#
#   SSH_CONFIG - contents of an SSH config file
#   SSH_KNOWN_HOSTS - contents of an SSH known_hosts file
#   SSH_PRIVATE_RSA_KEY - contents of an SSH private RSA key
#
# The environment variables are unset after the files are created to help
# prevent accidental output in logs

set -e

[[ ! -z "$SSH_PRIVATE_CONFIG" ]] && \
  mkdir -p ~/.ssh && \
  echo "$SSH_PRIVATE_CONFIG" > ~/.ssh/config && \
  chmod 600 ~/.ssh/config && \
  unset SSH_PRIVATE_CONFIG

[[ ! -z "$SSH_KNOWN_HOSTS" ]] && \
  mkdir -p ~/.ssh && \
  echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts && \
  chmod 600 ~/.ssh/known_hosts && \
  unset SSH_KNOWN_HOSTS

[[ ! -z "$SSH_PRIVATE_RSA_KEY" ]] && \
  mkdir -p ~/.ssh && \
  echo "$SSH_PRIVATE_RSA_KEY" > ~/.ssh/id_rsa && \
  chmod 600 ~/.ssh/id_rsa && \
  unset SSH_PRIVATE_RSA_KEY

[[ $1 ]] && exec "$@"
