#!/bin/bash

set -euo pipefail

BUILDKITE_JOB_ID=${BUILDKITE_JOB_ID:-dev}

test_docker_image_name="docker-ssh-env-test-$BUILDKITE_JOB_ID"
test_string="expected"
test_string_base64="ZXhwZWN0ZWQK"
test_file="test-file"

# Setup

function cleanup() {
  echo '~~~ Cleaning up test file'
  [[ -f $test_file ]] && rm $test_file

  echo '~~~ Cleaning Docker'
  docker rmi -f "$test_docker_image_name"
}

trap cleanup EXIT

echo "~~~ Creating test file"

echo "$test_string" > $test_file

echo '~~~ Building Docker test image'

docker build --tag "$test_docker_image_name" .

# Tests

echo "--- SSH config dir permissions tests"

docker run -it -e SSH_CONFIG="$test_string" --rm "$test_docker_image_name" bash -c "test -x ~/.ssh && echo '~/.ssh is executable'"

echo "--- SSH_CONFIG tests"

docker run --rm -e SSH_CONFIG="$test_string" "$test_docker_image_name" bash -c "cat ~/.ssh/config | grep $test_string"
docker run --rm -e SSH_CONFIG_B64="$test_string_base64" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/config | grep $test_string"
docker run --rm -e SSH_CONFIG_PATH="/tests/$test_file" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/config | grep $test_string"

echo "--- SSH_KNOWN_HOSTS tests"

docker run --rm -e SSH_KNOWN_HOSTS="$test_string" "$test_docker_image_name" bash -c "cat ~/.ssh/known_hosts | grep $test_string"
docker run --rm -e SSH_KNOWN_HOSTS_B64="$test_string_base64" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/known_hosts | grep $test_string"
docker run --rm -e SSH_KNOWN_HOSTS_PATH="/tests/$test_file" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/known_hosts | grep $test_string"

echo "--- SSH_PRIVATE_DSA_KEY tests"

docker run --rm -e SSH_PRIVATE_DSA_KEY="$test_string" "$test_docker_image_name" bash -c "cat ~/.ssh/id_dsa | grep $test_string"
docker run --rm -e SSH_PRIVATE_DSA_KEY_B64="$test_string_base64" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/id_dsa | grep $test_string"
docker run --rm -e SSH_PRIVATE_DSA_KEY_PATH="/tests/$test_file" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/id_dsa | grep $test_string"

echo "--- SSH_PRIVATE_ECDSA_KEY tests"

docker run --rm -e SSH_PRIVATE_ECDSA_KEY="$test_string" "$test_docker_image_name" bash -c "cat ~/.ssh/id_ecdsa | grep $test_string"
docker run --rm -e SSH_PRIVATE_ECDSA_KEY_B64="$test_string_base64" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/id_ecdsa | grep $test_string"
docker run --rm -e SSH_PRIVATE_ECDSA_KEY_PATH="/tests/$test_file" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/id_ecdsa | grep $test_string"

echo "--- SSH_PRIVATE_ED25519_KEY tests"

docker run --rm -e SSH_PRIVATE_ED25519_KEY="$test_string" "$test_docker_image_name" bash -c "cat ~/.ssh/id_ed25519 | grep $test_string"
docker run --rm -e SSH_PRIVATE_ED25519_KEY_B64="$test_string_base64" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/id_ed25519 | grep $test_string"
docker run --rm -e SSH_PRIVATE_ED25519_KEY_PATH="/tests/$test_file" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/id_ed25519 | grep $test_string"

echo "--- SSH_PRIVATE_RSA_KEY tests"

docker run --rm -e SSH_PRIVATE_RSA_KEY="$test_string" "$test_docker_image_name" bash -c "cat ~/.ssh/id_rsa | grep $test_string"
docker run --rm -e SSH_PRIVATE_RSA_KEY_B64="$test_string_base64" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/id_rsa | grep $test_string"
docker run --rm -e SSH_PRIVATE_RSA_KEY_PATH="/tests/$test_file" -v "$(pwd):/tests" "$test_docker_image_name" bash -c "cat ~/.ssh/id_rsa | grep $test_string"

echo "--- SSH_DEBUG tests"

docker run --rm -e SSH_DEBUG="1" "$test_docker_image_name" bash -c "cat ~/.ssh/config | grep 'LogLevel DEBUG3'"

# All done

echo "--- :tada: Woot!"

echo "Tests passed"
