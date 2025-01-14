#Requires AutoHotkey v2.0

FoundX := FoundY := 0

; CoordMode "Pixel"
; if (ImageSearch &FoundX, &FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, "./test.png")
;     MsgBox "The icon was found at " FoundX "x" FoundY
; else
;     MsgBox "Icon could not be found on the screen."

; CoordMode "Pixel"

; F2::
; {
;     SetTimer(LocateEnemy_FindByImg, 1000)
; }

LocateEnemy_FindByImg(&posX, &posY, StartX, StartY, EndX, EndY)
{
    if(!WinExist("League of Legends (TM) Client"))
        return false

    ; *5: Allow a 0 to 5 pixel difference for compatible similarity.
    if(ImageSearch(&posX, &posY, StartX, StartY, EndX, EndY, "*5 " A_ScriptDir "\models\level2.png"))
        return true
        ; ToolTip "The enemy was found at " pos_X "x" pos_Y
    else
        return false
        ; ToolTip "Icon could not be found on the screen. "
}


LocateEnemy_FindByPixel(&FoundX,&FoundY) 
{
    ; PixelSearch(&FoundX,&FoundY, this.StartX, this.StartY, this.EndX, this.EndY ,0xB13E34, this.RedCrazyLevel)
}