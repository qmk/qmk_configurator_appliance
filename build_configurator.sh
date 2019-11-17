#!/bin/sh
set -e
set -x

# Install node
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 11.12

# Get yarn installed correctly
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
apt-get update
apt-get remove cmdtest yarn
apt-get install --no-install-recommends -y yarn
rm -rf /var/lib/apt/lists/*

# Build configurator
cd /qmk_configurator
nvm use
yarn install
yarn run build
