#!/usr/bin/env bash

for source_file in _*; do
  source_path="$PWD/$source_file"
  destination_path=~/.${source_file:1}

  if [ ! -e $destination_path ]; then
    echo "Linking $source_path to $destination_path"
    ln -nfs $source_path $destination_path
  fi
done
