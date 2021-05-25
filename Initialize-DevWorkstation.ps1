#Requires -RunAsAdministrator

[cmdletbinding()]
param ()

# Install Choco and all the different Choco packages I want on a box
Set-ExecutionPolicy Unrestricted -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
$chocoPackages = @(
    'nugetpackageexplorer',
    'nuget.commandline',
    'dotnetcore-sdk',
    'powershell',
    'pwsh',
    'microsoft-edge-insider-dev',
    '7zip',
    'git.install',
    'docker-desktop',
    'vscode',
    'vscode-insiders',
    'visualstudio2019professional',
    'visualstudio2019buildtools',
    'microsoft-windows-terminal',
    'cascadiafonts',
    'greenshot',
    'telegram',
    'discord.install',
    'nodejs',
    'office365proplus'
)
choco install $chocoPackages -y

# Install Node packages for developing VS Code extensions
npm install -g yo generator-code vsce typescript

# Alias "pog" stands for "pretty log"
git config --global alias.pog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Make a place for Git repos and other config items to live
New-Item -Path 'c:\git' -ItemType Directory -Force -ErrorAction 0
New-Item -Path 'c:\temp' -ItemType Directory -Force -ErrorAction 0
New-Item -Path "$home\ps" -ItemType Directory -Force -ErrorAction 0

# Show extensions for known file types; current user
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# Show extensions for known file types; all users
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "DefaultValue" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "CheckedValue" -Value 0

# Setup PSGallery
Install-PackageProvider -Name Nuget -Scope CurrentUser -Force -Confirm:$false

# Make for a neat looking PS prompt for each profile
Install-Module -Name oh-my-posh, posh-git -Repository PSGallery -Scope CurrentUser
$ompContent = (Invoke-WebRequest 'https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/thomasrayner.json' -UseBasicParsing).Content
Set-Content -Path "$home\ps\thomasrayner.json" -Value $ompContent -Force

$psProfileContent = (Invoke-WebRequest 'https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/prompt.ps1' -UseBasicParsing).Content
foreach ($proPath in @(($profile.PSObject.Properties | Where-Object {$_.MemberType -eq 'NoteProperty'}).Value)) {
    Set-Content -Value $psProfileContent -Path $proPath
}

# Install WSL & make v2 default
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2

# Setup Windows Terminal settings
$wtProfileContent = (Invoke-WebRequest 'https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/settings.json' -UseBasicParsing).Content
Set-Content -Value $wtProfileContent -Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json"
