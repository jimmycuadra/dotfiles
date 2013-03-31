#!/usr/bin/env bash

chef_solo=$(which chef-solo)
if [ -z "$chef_solo" ]; then
  curl -L https://www.opscode.com/chef/install.sh -o install_chef.sh
  sudo bash install_chef.sh
  rm install_chef.sh
  chef_solo=$(which chef-solo)
fi
sudo mkdir -p /var/chef/cookbooks
sudo cp -R . /var/chef/cookbooks/dotfiles
sudo $chef_solo -c solo.rb -j node.json
