# dotfiles

This is a [Chef](http://www.opscode.com/) cookbook to add my dotfiles to a machine. It also contains a script and some configuration files to allow you to provision the machine you're currently on with the default recipe.

To set up your own workstation:

1. Clone or simply download the repository to your computer.
1. Edit `node.json`, changing the `dotfiles` values to match your own username and the full path to your own home directory.
1. Run `install.sh`.
