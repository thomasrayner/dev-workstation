
#Persistent
SetTitleMatchMode, 2

; Hotkey to switch focus to Teams meeting and send CTRL+Shift+M
^+x::
    IfWinExist, Microsoft Teams
    {
        WinActivate
        Sleep, 100 ; Adjust this delay if needed
        Send, ^+o
    }
    else
    {
        MsgBox, Microsoft Teams is not active.
    }
return
