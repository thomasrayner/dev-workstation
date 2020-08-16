#Requires -RunAsAdministrator

[cmdletbinding()]
param (
    [switch]$UACNoConsent
)

#apps
$Apps = @(
    # Business Apps
    'microsoft-edge',
    'office365proplus',
    'microsoft-teams',
    # Developer Tools
    'git.install',
    'vscode',
    'vscode-powershell',
    'microsoft-windows-terminal',
    'nugetpackageexplorer',
    'nuget.commandline',
    'dotnetcore-sdk',
    'docker-desktop',
    'visualstudio2019professional',
    'visualstudio2019buildtools',
    'cascadiafonts',
    'greenshot',
    'nodejs',
    # Entertainment Apps
    'spotify',
    'discord.install',
    # Helpful Tools
    '7zip',
    'sysinternals',
    'wireshark',
    'lastpass',
    'vlc',
    'googlechrome',
    'powershell',
    'pwsh',
    'microsoft-windows-terminal'
)

# Make for a neat looking PS prompt for each profile
$psProfileContent = (Invoke-WebRequest 'https://raw.githubusercontent.com/udubnate/dev-workstation/master/prompt.ps1' -UseBasicParsing).Content
foreach ($proPath in @(
    "$($env:userprofile)\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "$($env:userprofile)\Documents\PowerShell\Microsoft.VSCode_profile.ps1"
    "$($env:userprofile)\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
    "$($env:userprofile)\Documents\WindowsPowerShell\Microsoft.VSCode_profile.ps1"
)) {
    Set-Content -Value $psProfileContent -Path $proPath
}

# Install Choco and all the different Choco packages I want on a box
Set-ExecutionPolicy Unrestricted -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install $($Apps -join ' ') -y

# Install Node packages for developing VS Code extensions
npm install -g yo generator-code vsce typescript

# Alias "pog" stands for "pretty log"
git config --global alias.pog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Make a place for Git repos to live
New-Item -Path c:\git -ItemType Directory -Force -ErrorAction 0
New-Item -Path c:\temp -ItemType Directory -Force -ErrorAction 0

# Show extensions for known file types; current user
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
# Show extensions for known file types; all users
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "DefaultValue" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "CheckedValue" -Value 0

if ($UACNoConsent) {
    # Regkey to turn off UAC consent prompt behavior for Admins; NOT disabling UAC
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'ConsentPromptBehaviorAdmin' -Value 0
}

# Install WSL & make v2 default
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2

# Setup PSGallery
Install-PackageProvider -Name Nuget -Scope CurrentUser -Force -Confirm:$false

$wtProfileContent = (Invoke-WebRequest 'https://raw.githubusercontent.com/udubnate/dev-workstation/master/settings.json' -UseBasicParsing).Content
Set-Content -Value $wtProfileContent -Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json"
