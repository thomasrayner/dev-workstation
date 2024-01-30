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
    'vscode-insiders',
    'cascadiafonts',
    'telegram',
    'discord.install',
    'autohotkey.install'
    'nodejs',
    'obs-studio',
    'azure-cli',
    'dotnetfx',
    'dotnet-sdk',
    'eartrumpet',
    'neovim',
    'firacode',
    'starship'
)
choco install $chocoPackages -y
choco install 'microsoft-windows-terminal' -y --pre

npm install -g yo generator-code vsce typescript ts-node

# Alias "pog" stands for "pretty log"
git config --global alias.pog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

New-Item -Path "$home\ps" -ItemType Directory -Force -ErrorAction 0

# Show extensions for known file types; current user
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# Show extensions for known file types; all users
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "DefaultValue" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "CheckedValue" -Value 0

# Make for a neat looking PS prompt for each profile
$policy = (Get-PSRepository -Name 'PSGallery').InstallationPolicy
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
Install-Module -Name posh-git -Repository PSGallery -Scope CurrentUser
Set-PSRepository -Name 'PSGallery' -InstallationPolicy $policy
$starshipPrompt = (Invoke-WebRequest 'https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/starship.toml' -UseBasicParsing).Content
Set-Content -Path "$home\.config\starship.toml" -Value $starshipPrompt -Force

$psProfileContent = (Invoke-WebRequest 'https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/profile.ps1' -UseBasicParsing).Content
foreach ($proPath in @(($profile.PSObject.Properties | Where-Object {$_.MemberType -eq 'NoteProperty'}).Value)) {
    Set-Content -Value $psProfileContent -Path $proPath -Force
}

$vscodeExtensions = (Invoke-WebRequest 'https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/vscode-extensions.txt' -UseBasicParsing).Content
foreach ($ext in $vscodeExtensions.Split("`n")) {
    code-insiders --install-extension $ext
}

# Install WSL & distributions
wsl --install -d Ubuntu