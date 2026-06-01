#Requires AutoHotkey v2.0+
#SingleInstance Force

; --- Brightness Display Helper Function ---
ShowBrightness(CurrentBrightness) {
    ToolTip("Brightness: " . CurrentBrightness . "%")
    SetTimer () => ToolTip(), -1000 ; Hide tooltip after 1 second
}

; --- Core Function to Change Windows Brightness ---
ChangeBrightness(Amount) {
    current := 50 ; Fallback starting baseline if read fails
    
    ; 1. Get the current hardware brightness level
    For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightness") {
        current := property.CurrentBrightness
        break
    }
    
    ; 2. Calculate new brightness level capped strictly between 0 and 100
    newBrightness := Max(0, Min(100, current + Amount))
    
    ; 3. Push the new brightness level back to the monitor panel
    For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods") {
        property.WmiSetBrightness(0, newBrightness)
        break
    }
    
    ; 4. Update the on-screen tooltip display
    ShowBrightness(newBrightness)
}

; --- Hotkeys active ONLY when the Side Front Button (XButton2) is held down ---
#HotIf GetKeyState("XButton2", "P")

WheelUp::
{
    ChangeBrightness(10) ; Changes brightness UP by 10 levels
}

WheelDown::
{
    ChangeBrightness(-10) ; Changes brightness DOWN by 10 levels
}

#HotIf ; Reset hotkey formatting for any future scripts

