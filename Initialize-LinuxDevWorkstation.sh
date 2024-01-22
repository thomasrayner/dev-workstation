#!/bin/bash

sudo apt-get install -y wget apt-transport-https software-properties-common
source /etc/os-release
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell

# Set PowerShell as the default shell
chsh -s $(which pwsh)

sudo apt-get install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0 git unzip npm

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y neovim

git clone https://github.com/thomasrayner/nvim ~/.config/nvim
git clone https://github.com/PowerShell/PowerShellEditorServices ~/.config/PowerShellEditorServices

pwsh -Command "Install-Module -Name InvokeBuild, platyps -Scope CurrentUser"
cd ~/.config/PowerShellEditorServices
pwsh -Command "Invoke-Build build"

nvim -c ":CocInstall coc-powershell | q"
cd ~/.local/share/nvim/lazy/coc.nvim
npm ci
nvim -c ":CocInstall coc-powershell | q"

mkdir -p ~/.config/powershell
touch ~/.config/powershell/Microsoft.PowerShell_profile.ps1
curl -o ~/.config/powershell/Microsoft.PowerShell_profile.ps1 https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/linux-psprofile.ps1
