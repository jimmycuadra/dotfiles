#!/usr/bin/env bash

type chef-solo >/dev/null 2>&1
if [ "$?" -ne 0 ]; then
  curl -L https://www.opscode.com/chef/install.sh -o install_chef.sh
  sudo bash install_chef.sh
  rm install_chef.sh
fi
sudo mkdir -p /var/chef/cookbooks
sudo cp -R . /var/chef/cookbooks/dotfiles
sudo chef-solo -c solo.rb -j node.json
