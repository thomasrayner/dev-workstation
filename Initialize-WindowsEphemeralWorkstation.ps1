#Requires -RunAsAdministrator

[cmdletbinding()]
param ()

# Install Choco and packages
Set-ExecutionPolicy Unrestricted -Force

if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey already installed."
}

$chocoPackages = @(
    'ripgrep',
    'powershell',
    'pwsh',
    '7zip',
    'git.install',
    'docker-desktop',
    'vscode-insiders',
    'cascadiafonts',
    'autohotkey.install'
    'eartrumpet',
    'neovim',
    'firacode',
    'nerd-fonts-FiraCode'
    'starship'
    'git-credential-manager-for-windows'
    'microsoft-windows-terminal'
)
choco install $chocoPackages -y

# Window manager isn't on choco... or it didn't used to be
winget install glazewm
winget install zebar
winget install flow-launcher
winget install flameshot

# Window manager configs
$repoRoot = 'https://raw.githubusercontent.com/thomasrayner/dev-workstation/master'

$glazeConfig = "$repoRoot/glazewm-config.yaml"
$glazeConfigPath = "$env:USERPROFILE\.glzr\glazewm\config.yaml"
Invoke-WebRequest -Uri $glazeConfig -OutFile $glazeConfigPath -UseBasicParsing

$zebarConfigHTML = "$repoRoot/with-glazewm.html"
$zebarConfigJSON = "$repoRoot/with-glazewm.html"
$zebarConfigHTMLPath =  "$env:USERPROFILE\.glzr\zebar\starter\with-glazewm.html"
$zebarConfigJSONPath =  "$env:USERPROFILE\.glzr\zebar\starter\with-glazewm.zebar.json"
Invoke-WebRequest -Uri $zebarConfigHTML -OutFile $zebarConfigHTMLPath -UseBasicParsing
Invoke-WebRequest -Uri $zebarConfigJSON -OutFile $zebarConfigJSONPath -UseBasicParsing

# Alias "pog" stands for "pretty log"
git config --global alias.pog "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global core.editor "nvim"

# Show extensions for known file types; current user
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

# Make for a neat looking PS prompt for each profile
$policy = (Get-PSRepository -Name 'PSGallery').InstallationPolicy
Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
Install-Module -Name posh-git -Repository PSGallery -Scope CurrentUser
Set-PSRepository -Name 'PSGallery' -InstallationPolicy $policy
$starshipPrompt = (Invoke-WebRequest 'https://raw.githubusercontent.com/mygithub/dev-workstation/master/starship.toml' -UseBasicParsing).Content
Set-Content -Path "$home\.config\starship.toml" -Value $starshipPrompt -Force -Encoding utf8

$psProfileContent = (Invoke-WebRequest 'https://raw.githubusercontent.com/mygithub/dev-workstation/master/profile.ps1' -UseBasicParsing).Content
foreach ($proPath in @(($profile.PSObject.Properties | Where-Object {$_.MemberType -eq 'NoteProperty'}).Value)) {
    Set-Content -Value $psProfileContent -Path $proPath -Force
}

# Autostart scripts
$startupPath = "$($env:APPDATA)\Microsoft\Windows\Start Menu\Programs\Startup"  
New-Item -Path $startupPath -ItemType Directory -Force -ErrorAction 0

# GlazeWM autostart
$glazeExe = (Get-Command glazewm.exe -ErrorAction SilentlyContinue).Source
if ($glazeExe) {
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut("$startupPath\GlazeWM.lnk")
    $shortcut.TargetPath = $glazeExe
    $shortcut.Save()
}

# Zebar autostart
$zebarExe = (Get-Command zebar.exe -ErrorAction SilentlyContinue).Source
if ($zebarExe) {
    $shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut("$startupPath\Zebar.lnk")
    $shortcut.TargetPath = $zebarExe
    $shortcut.Save()
}

# Teams mute/cam scripts
$teamsMute = "$repoRoot/teamsmute.ahk"
$teamsCam = "$repoRoot/teamscam.ahk"
$teamsMutePath = "$startupPath\teamsmute.ahk"
$teamsCamPath = "$startupPath\teamscam.ahk"
Invoke-WebRequest -Uri $teamsMute -OutFile $teamsMutePath -UseBasicParsing
Invoke-WebRequest -Uri $teamsCam -OutFile $teamsCamPath -UseBasicParsing

# Install WSL & distributions
wsl --install -d Ubuntu


