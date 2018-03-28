[cmdletbinding()]
param (
    [switch]$All,
    [switch]$Office,
    [switch]$PowerPointViewer,
    [switch]$VisualStudio,
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

if ( $All -or $Help ) { update-help }

if ( $All -or $Remoting ) { 
    Enable-PSRemoting –force
    Set-Service WinRM -StartMode Automatic
    get-ciminstance -ClassName win32_service | where-object { $_.Name -eq 'WinRM' }
    Set-Item WSMan:localhost\client\trustedhosts -value * # this is SUPER sketchy so use at your own risk
    Get-Item WSMan:\localhost\Client\TrustedHosts
}

(Invoke-WebRequest https://raw.githubusercontent.com/ThmsRynr/dev-workstation/master/prompt.ps1 -UseBasicParsing).Content | Out-File $profile
