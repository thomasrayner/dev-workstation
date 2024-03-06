Get-Process *whkd* | Stop-Process
Start-Process -FilePath "whkd --config $($env:USERPROFILE)\.config\whkdrc" -WindowStyle Hidden
Get-Process *komo* | Stop-Process
komorebic start -c $env:userprofile\komorebi.json --whkd
komorebic active-window-border-width 10
komorebic resize-delta 250

