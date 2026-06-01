#Requires AutoHotkey v2.0

; Use the Side Back Button (XButton1) as a modifier
~XButton1 & LButton::Send "#{Tab}"  ; Side Back + Left Click = Task View (Win + Tab)
~XButton1 & RButton::Send "#d"      ; Side Back + Right Click = Show Desktop (Win + D)

; Optional: Prevents the default "Back" action from triggering 
; when you are using the copy/paste combinations.
XButton1::
{
    KeyWait "XButton1"
    if (A_ThisHotkey = "XButton1" and A_PriorKey = "XButton1")
    {
        Send "{XButton1}"
    }
}