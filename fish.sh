#!/bin/bash

set -e

read -p "Enter your username: " username

chsh -s /usr/bin/fish

echo
echo
echo "##################################################"
echo "###            CONFIGURE FISH                  ###"
echo "##################################################"
echo
echo

cat <<EOF > ./fish/config.fish
if status is-interactive
    fastfetch
end

set -g fish_greeting
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx PATH \$PATH /home/$username/.dotnet/tools
EOF

mkdir -p ~/.config/fish
cp -frv ./fish/* ~/.config/fish/

echo
echo "### DONE ###"
