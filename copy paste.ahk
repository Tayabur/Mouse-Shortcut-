#Requires AutoHotkey v2.0

; Use the Side Front Button (XButton2) as a modifier for copy/paste
~XButton2 & LButton::Send "^c"  ; Side Front + Left Click = Copy
~XButton2 & RButton::Send "^v"  ; Side Front + Right Click = Paste

; Optional: Prevents the default "Forward" action from triggering 
; when you use the combinations.
XButton2::
{
    KeyWait "XButton2"
    if (A_ThisHotkey = "XButton2" and A_PriorKey = "XButton2")
    {
        Send "{XButton2}"
    }
}