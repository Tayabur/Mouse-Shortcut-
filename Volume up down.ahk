#Requires AutoHotkey v2.0+
#SingleInstance Force

; --- Volume Display Helper Function ---
ShowVolume() {
    ToolTip("Volume: " . Round(SoundGetVolume()) . "%")
    SetTimer () => ToolTip(), -1000
}

; --- Hotkeys active ONLY when the Side Back Button (XButton1) is held down ---
#HotIf GetKeyState("XButton1", "P")

WheelUp::
{
    Send "{Volume_Up}" ; Turns volume up
    ShowVolume()
}

WheelDown::
{
    Send "{Volume_Down}" ; Turns volume down
    ShowVolume()
}

#HotIf ; Reset hotkey formatting