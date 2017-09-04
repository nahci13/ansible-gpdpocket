#!/bin/bash

# set exit on error
set -e

# wait for internet connection
echo "waiting for internet connection..."
while ! ping -c1 8.8.8.8 &>/dev/null; do
  sleep 1
done

# wait for apt availability
echo "waiting for apt to be available..."
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  sleep 1
done

# update ansible code
echo "downloading latest ansible code..."
if [ -d /usr/src/ansible-gpdpocket/.git ]; then
  cd /usr/src/ansible-gpdpocket
  git fetch --all
  git reset --hard origin/master
else
  rm -rf /usr/src/ansible-gpdpocket
  git clone https://github.com/nahci13/ansible-gpdpocket.git /usr/src/ansible-gpdpocket
  cd /usr/src/ansible-gpdpocket
  git reset --hard origin/master
fi

# run ansible scripts
echo "starting ansible playbook..."
ANSIBLE_NOCOWS=1 ansible-playbook system.yml
