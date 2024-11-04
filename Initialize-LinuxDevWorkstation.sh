#!/bin/bash

# Install PowerShell
sudo apt update -y
sudo apt-get install -y wget apt-transport-https software-properties-common git
source /etc/os-release
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell

# Set PowerShell as the default shell
chsh -s $(which pwsh)

# Dotnet sdk and runtime, latest versions of git, npm - unzip is needed to install LSPs
sudo apt-get install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0 git unzip npm ripgrep

# Want the pre-release version of neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim

# PSES needs to be built locally
git clone https://github.com/thomasrayner/nvim ~/.config/nvim
git clone https://github.com/PowerShell/PowerShellEditorServices ~/.config/PowerShellEditorServices

pwsh -Command "Install-Module -Name InvokeBuild, platyps -Scope CurrentUser"
cd ~/.config/PowerShellEditorServices
pwsh -Command "Invoke-Build build"

# coc-powershell is most easily setup this way, some interaction might be required
# use Lazy to install coc.nvim and then use :CocInstall to install the PowerShell bits
nvim -c "sleep 30 | q"
cd ~/.local/share/nvim/lazy/coc.nvim
npm ci
nvim -c ":CocInstall coc-powershell | q"

# Setup PowerShell profile
mkdir -p ~/.config/powershell

# install starship for prompt
curl -sS https://starship.rs/install.sh | sh
curl -o ~/.config/starship.toml https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/starship.toml
touch ~/.config/powershell/Microsoft.PowerShell_profile.ps1
curl -o ~/.config/powershell/Microsoft.PowerShell_profile.ps1 https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/profile.ps1

git config --global core.editor "nvim"

# git-credential-manager
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.0/gcm-linux_amd64.2.6.0.deb -O gcm-linux.deb
sudo dpkg -i gcm-linux.deb
rm gcm-linux.deb
git-credential-manager configure
