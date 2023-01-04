#SingleInstance force
#Persistent
#include Lib\AutoHotInterception.ahk

AHI := new AutoHotInterception()

keyboardId := AHI.GetKeyboardId(0x13BA, 0x0001)
AHI.SubscribeKeyboard(keyboardId, true, Func("KeyEvent"))



KeyEvent(code, state){
	ToolTip % "Keyboard Key - Code: " code ", State: " state
}


^Esc::
	ExitApp