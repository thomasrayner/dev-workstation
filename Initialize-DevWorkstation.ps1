#Requires -RunAsAdministrator


[cmdletbinding()]
param (
    [switch]$UACNoConsent
)

# Install Choco
Set-ExecutionPolicy Unrestricted -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install all the different Choco packages I want on a box
choco install powershell pwsh googlechrome 7zip git.install vscode vscode-insiders visualstudio2017enterprise conemu greenshot discord.install nodejs office365proplus -y

# Install Node packages for developing VS Code extensions
npm install -g yo generator-code vsce

# Alias "pog" stands for "pretty log"
git config --global alias.pog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Make a place for Git repos to live
New-Item -Path c:\git -ItemType Directory -Force -ErrorAction 0
Push-Location c:\git

# Show extensions for known file types; current user
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
# Show extensions for known file types; all users
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "DefaultValue" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "CheckedValue" -Value 0

# Install the PowerLine fonts that make my prompt look nifty
git clone https://github.com/powerline/fonts.git
Push-Location fonts
& .\install.ps1
Pop-Location

if ( $All -or $UACNoConsent ) {
    # Regkey to turn off UAC consent prompt behavior for Admins; NOT disabling UAC gloablly
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0
}

# Make for a neat looking PS prompt
(Invoke-WebRequest https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/prompt.ps1 -UseBasicParsing).Content | Out-File $profile

