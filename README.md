# dotfiles

This is a [Chef](http://www.opscode.com/) cookbook to add my dotfiles to a machine. It also contains a script and some configuration files to allow you to provision the machine you're currently on with the default recipe.

To set up your own workstation:

1. Clone or simply download the repository to your computer.
1. (Optional) Edit `node.json` to override any of the default attributes. The default attributes assume your user is "jimmy" on Mac OS X and "vagrant" on other platforms.
1. Run `install.sh`.
