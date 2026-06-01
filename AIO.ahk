#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; 1. SIDE BACK BUTTON (XButton1) COMBINATIONS
; ==============================================================================

; Side Back + Left Click -> Task View
XButton1 & LButton::Send("#`t")

; Side Back + Right Click -> Show/Hide Desktop
XButton1 & RButton::Send("#d")

; Side Back + Wheel Up -> Increase Volume
XButton1 & WheelUp:: {
    SoundSetVolume("+2")
    ShowVolumeToolTip()
}

; Side Back + Wheel Down -> Decrease Volume
XButton1 & WheelDown:: {
    SoundSetVolume("-2")
    ShowVolumeToolTip()
}


; ==============================================================================
; 2. SIDE FRONT BUTTON (XButton2) COMBINATIONS
; ==============================================================================

; Side Front + Left Click -> Copy
XButton2 & LButton::Send("^c")

; Side Front + Right Click -> Paste
XButton2 & RButton::Send("^v")

; Side Front + Wheel Up -> Increase Brightness
XButton2 & WheelUp::AdjustBrightness(10)

; Side Front + Wheel Down -> Decrease Brightness
XButton2 & WheelDown::AdjustBrightness(-10)


; ==============================================================================
; 3. SIMULTANEOUS LEFT + RIGHT CLICK (Screenshot)
; ==============================================================================
; Pressing and holding both Left and Right mouse buttons opens the Windows Snipping Tool.
; The tilde (~) prefix ensures your primary mouse clicks still work normally.

~LButton & RButton:: {
    if GetKeyState("LButton", "P") {
        Send("#+s") ; Sends Win + Shift + S
    }
}

~RButton & LButton:: {
    if GetKeyState("RButton", "P") {
        Send("#+s") ; Sends Win + Shift + S
    }
}


; ==============================================================================
; 4. MAINTAIN ORIGINAL MOUSE BUTTON FUNCTIONALITY
; ==============================================================================
; Defining custom combinations (like XButton1 & LButton) automatically turns the 
; prefix key into a modifier, suppressing its native click. 
; These mappings restore the normal "Back" and "Forward" actions upon release.

XButton1::Send("{XButton1}")
XButton2::Send("{XButton2}")


; ==============================================================================
; 5. HELPER FUNCTIONS (Volume & Brightness Display)
; ==============================================================================

; Displays a 1-second tooltip showing the current volume level
ShowVolumeToolTip() {
    currentVol := Round(SoundGetVolume())
    ToolTip("Volume: " currentVol "%")
    SetTimer(() => ToolTip(), -1000) ; Negative period fires the timer only once
}

; Adjusts display brightness using Windows Management Instrumentation (WMI)
AdjustBrightness(step) {
    try {
        ; Connect to the local WMI namespaces
        wmi := ComObjGet("winmgmts:\\.\root\WMI")
        
        ; Query current brightness level
        monitorObjects := wmi.ExecQuery("SELECT * FROM WmiMonitorBrightness")
        currentBrightness := 50 ; Fallback default if query yields nothing
        for obj in monitorObjects {
            currentBrightness := obj.CurrentBrightness
            break ; Standardize on the primary/first detected monitor
        }
        
        ; Calculate and bound the new target brightness value
        newBrightness := Max(0, Min(100, currentBrightness + step))
            
        ; Interface with brightness methods to commit the change
        methods := wmi.ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods")
        for obj in methods {
            obj.WmiSetBrightness(0, newBrightness) ; 0 indicates immediate application
        }
        
        ; Display confirmation tooltip
        ToolTip("Brightness: " newBrightness "%")
        SetTimer(() => ToolTip(), -1000)
    } catch {
        ; Graceful degradation if WMI queries fail (e.g., desktop monitors lacking DDC/CI)
        ToolTip("Brightness control unsupported")
        SetTimer(() => ToolTip(), -1000)
    }
}