#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance force
#Persistent
#include <AutoHotInterception>
#include <TapHoldManager>
#include <InterceptionTapHold>


SetTitleMatchMode, 2

AHI := new AutoHotInterception()

keyboardId := AHI.GetKeyboardId(0x13BA, 0x0001)

ITH1 := new InterceptionTapHold(AHI, keyboardId)
ITH1.Add("NumpadAdd", Func("volumeUp"))
ITH1.Add("NumpadSub", Func("volumeDown"))
ITH1.Add("NumpadEnter", Func("PanicButton"))
ITH1.Add("NumpadIns", Func("button0"))


button0(isHold, taps, state){
	if (!isHold) & (state) & (taps=1){
        Send {LAlt Down}{Space}{LAlt Up}
    }
}
Debug(isHold, taps, state){
	ToolTip % "up`n" (isHold ? "HOLD" : "TAP") "`nTaps: " taps "`nState: " state
}

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
		  DllCall("LockWorkStation")
        return
    } 
    if (!state){ 
       
    }
}

volumeUp(isHold, taps, state){
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
       
    }
    
}

volumeDown(isHold, taps, state){

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