#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force
#Persistent
#include <AutoHotInterception>
#include <TapHoldManager>
#include <InterceptionTapHold>

; Needed for WinActive working
SetTitleMatchMode, 2

AHI := new AutoHotInterception()

; Get keyboardId from Monitor.ahk
keyboardId := AHI.GetKeyboardId(0x13BA, 0x0001)

; Subscribe to keys
ITH1 := new InterceptionTapHold(AHI, keyboardId)
ITH1.Add("NumpadAdd", Func("volumeUp"))
ITH1.Add("NumpadSub", Func("volumeDown"))
ITH1.Add("NumpadEnter", Func("PanicButton"))
ITH1.Add("NumpadDel", Func("NumpadDel"))
ITH1.Add("NumpadIns", Func("button0"))

NumpadDel(isHold, taps, state){
    if (!isHold) & (state) & (taps=1){
        Run firefox.exe -no-remote -p "vpn"
        return
    }
}

; Debug attributes for key
Debug(isHold, taps, state){
	ToolTip % "up`n" (isHold ? "HOLD" : "TAP") "`nTaps: " taps "`nState: " state
}

; NumpadIns 82
button0(isHold, taps, state){
	if (!isHold) & (state) & (taps=1){
        Send {LAlt Down}{Space}{LAlt Up}
    }
}

; NumpadEnter 284
PanicButton(isHold, taps, state){
    if (!isHold) & (state) & (taps=1){
        Send {LWin Down}{d}{LWin Up}
        ToolTip % "Panic"
        SoundSet, 1, , Mute 
        SetTimer, RemovePanic, -2000
        return
        RemovePanic:
        ToolTip
        return
    }
    if (!isHold) & (taps=2) & (state){	
        ; Locks Windows
        DllCall("LockWorkStation")
        return
    } 
    if (!state){ 
        ;do nothing
    }
}

; NumpadAdd 78
volumeUp(isHold, taps, state){
    ; Single Tap, no hold
    if (isHold=0) & (taps=1) & (state){	
        SoundSet, +10
        SoundGet, system_volume
        ToolTip % "+10 V, "  system_volume
        SetTimer, RemoveVolumePlusToolTip, -2000
        return
        RemoveVolumePlusToolTip:
        ToolTip
        return
    } 
    ; Single Tap and Hold
    if (isHold=1) & (taps=1) & (state){	
        SoundSet, 0, , Mute
        SoundGet, system_volume
        ToolTip % "UnMuted" 
        SetTimer, RemoveUnMutedTooltip, -2000
        return
        RemoveUnMutedTooltip:
        ToolTip
        return
    } 
    ; Double tap, no hold
    if (isHold=0) & (taps=2) & (state){	
        SoundSet 50
        ToolTip % "Volume 50"
        SoundGet, system_volume
        SetTimer, RemoveVolume50ToolTip, -2000
        return
        RemoveVolume50ToolTip:
        ToolTip
        return
    } 
    if (!state){ 
        ;do nothing
    }
}


; NumpadSub 74
volumeDown(isHold, taps, state){
    ; Single Tap, no hold
    if (isHold=0) & (taps=1) & (state){	
        SoundSet, -10
        SoundGet, system_volume
        ToolTip % "-10 V, "  system_volume
        SetTimer, RemoveVolumeDownToolTip, -2000
        return
        RemoveVolumeDownToolTip:
        ToolTip
        return
    } 

     ; Single Tap and Hold
    if (isHold=1) & (taps=1) & (state){	
        SoundSet, 1, , Mute
        SoundGet, system_volume
        ToolTip % "Muted" 
        SetTimer, RemoveMutedTooltip, -2000
        return
        RemoveMutedTooltip:
        ToolTip
        return
    } 

    ; Double tap, no hold
    if (isHold=0) & (taps=2) & (state){	
        SoundSet 0
        ToolTip % "Volume 0"
        SoundGet, system_volume
        SetTimer, RemoveVolume0ToolTip, -2000
        return
        RemoveVolume0ToolTip:
        ToolTip
        return
    } 

    if (!state){
        ;do nothing
    }
}


^Esc::
	ExitApp


; For win specific actions
; if WinActive("ahk_exe firefox.exe"){
; ToolTip % "Inside firefox"
; }
    
; Key combinations
; KeyWait, NumpadAdd, D T2.5
; if ErrorLevel{
; Send {LAlt Down}{Space}{LAlt Up}
; }