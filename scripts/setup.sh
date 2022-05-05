#!/bin/sh

# add Erlang Solutions repository
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
dpkg -i erlang-solutions_2.0_all.deb

# update the system
apt-get update
apt-get upgrade

################################################################################
# Install the mandatory tools
################################################################################
# install utilities
apt-get -yqq install vim git curl unzip build-essential make

################################################################################
# Install the development tools
################################################################################
# install the Erlang/OTP platform and all of its applications
apt-get -yqq install esl-erlang

# Install Elixir
apt-get -yqq install elixir

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# if we have just installed Elixir for the first time, we will need to install the Hex package manager as well.
# Hex is necessary to get a Phoenix app running, and to install any extra dependencies we might need along the way
# Type this command to install Hex:
mix local.hex

# now we can proceed to install Phoenix:
curl -o phx_new.ez https://raw.githubusercontent.com/phoenixframework/archives/master/phx_new.ez
mix archive.install hex phx_new 1.6.7


# Phoenix uses brunch.io to compile static assets, (javascript, css and more), so you will need to install Node.js.
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile
nvm install node

# latest node version is broke @ 25/04/2022, fix version 16.x
nvm install 16

# you can install PostgreSQL easily using the apt packaging system
apt-get -yqq install postgresql postgresql-contrib

# linux-only filesystem watcher that Phoenix uses for live code reloading
apt-get -yqq install inotify-tools

# install latest Docker
curl -sL https://get.docker.io/ | sh

# install latest docker-compose
curl -L "$(curl -s https://api.github.com/repos/docker/compose/releases | grep browser_download_url | head -n 4 | grep Linux | cut -d '"' -f 4)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# configure docker group (docker commands can be launched without sudo)
usermod -aG docker vagrant

# fix ownership of home
chown -R vagrant:vagrant /home/vagrant/

# fix vbox group shared folders
adduser $(whoami) vboxsf


# Install ACT - https://github.com/nektos/act
# Run your GitHub Actions locally!
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
# NOTE: After all, run: ./bin/act and configure your env


# clean the box
apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY