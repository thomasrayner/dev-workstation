#!/bin/bash

# Install PowerShell
sudo apt-get install -y wget apt-transport-https software-properties-common
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
touch ~/.config/powershell/Microsoft.PowerShell_profile.ps1
curl -o ~/.config/powershell/Microsoft.PowerShell_profile.ps1 https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/linux-psprofile.ps1
