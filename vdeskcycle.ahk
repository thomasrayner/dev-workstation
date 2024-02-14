#NoEnv
#Persistent

numDesktops := 4  ; set to match number of virtual desktops
vDesktop := 1   ; this must match the virtual desktop active when program starts if a sync isn't forced
return

~^#Left::
    vDesktop -= 1
    Sleep, 20
    if (vDesktop=0) {
        vDesktop = %numDesktops%
        Loop, % numDesktops + 1
        {
            SendInput ^#{Right}
        }
    }
return

~^#Right::
    vDesktop += 1
    Sleep, 20
    if (vDesktop >= numDesktops + 1) {
        vDesktop = 1
        Loop, % numDesktops + 1
        {
            SendInput ^#{Left}
        }
    }
return