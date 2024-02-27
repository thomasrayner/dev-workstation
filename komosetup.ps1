Get-Process *whkd* | Stop-Process
Start-Process -FilePath "whkd --config $env:USERPROFILE\.config\whkdrc" -WindowStyle Hidden
Get-Process *komo* | Stop-Process
komorebic start --whkd
