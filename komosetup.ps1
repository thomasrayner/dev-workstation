Get-Process *whkd* | Stop-Process
whkd --config $env:USERPROFILE\.config\whkdrc
Get-Process *komo* | Stop-Process
komorebic start --whkd
