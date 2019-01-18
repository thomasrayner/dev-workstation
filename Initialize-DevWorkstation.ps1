[cmdletbinding()]
param (
    [switch]$All,
    [switch]$Office,
    [switch]$PowerPointViewer,
    [switch]$VisualStudio,
    [switch]$UACNoConsent,
    [switch]$ShowFileExt,
    [switch]$Help,
    [switch]$Remoting
)

Set-ExecutionPolicy Unrestricted -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install powershell -y

choco install googlechrome 7zip git.install visualstudiocode vscode-powershell conemu greenshot -y

if ( $All -or $VisualStudio ) { choco install visualstudio2017enterprise -y }

if ( $PowerPointViewer ) { choco install powerpoint.viewer -y }

if ( $All -or $Office ) { choco install office365proplus -y }

if ( $All -or $UACNoConsent ) {
    # Regkey to turn off UAC consent prompt behavior for Admins; NOT disabling UAC gloablly
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0
}

if ( $All -or $ShowFileExt ) {
    # Show extensions for known file types; current user
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0
    # Show extensions for known file types; all users
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "DefaultValue" -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\HideFileExt" -Name "CheckedValue" -Value 0
}

if ( $All -or $Help ) { update-help }

if ( $All -or $Remoting ) { 
    Enable-PSRemoting –force
    Set-Service WinRM -StartMode Automatic
    get-ciminstance -ClassName win32_service | where-object { $_.Name -eq 'WinRM' }
    Set-Item WSMan:localhost\client\trustedhosts -value * # this is SUPER sketchy so use at your own risk
    Get-Item WSMan:\localhost\Client\TrustedHosts
}

(Invoke-WebRequest https://raw.githubusercontent.com/thomasrayner/dev-workstation/master/prompt.ps1 -UseBasicParsing).Content | Out-File $profil

# Alias "pog" stands for "pretty log"
git config --global alias.pog=log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
