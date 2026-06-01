#Requires AutoHotkey v2.0
#SingleInstance Force

; Case 1: Holding Left Click, then pressing Right Click
~LButton & RButton:: {
    HandleSimultaneousClick()
}

; Case 2: Holding Right Click, then pressing Left Click
~RButton & LButton:: {
    HandleSimultaneousClick()
}

; Core function to verify both keys are actively held down together
HandleSimultaneousClick() {
    ; Short delay to ensure physical buttons are fully depressed
    Sleep(30) 
    
    ; Check if BOTH Left (LButton) and Right (RButton) are being physically held ('P')
    if GetKeyState("LButton", "P") and GetKeyState("RButton", "P") {
        Send("#+s") ; Triggers Windows Snipping Tool
        
        ; Optional safety: Wait for you to release the buttons so it doesn't spam screenshots
        KeyWait("LButton")
        KeyWait("RButton")
    }
}