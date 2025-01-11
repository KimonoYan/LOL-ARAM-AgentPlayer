#Requires AutoHotkey v2.0

/************************************************************************
 * @description [LOL-ARAM-AgentPlayer] 
 * 		https://github.com/KimonoYan/LOL-ARAM-AgentPlayer.git
 *   	An auto script for the LOL ARAM mode. 
 * @author KimonoYan
 * @date 2025/01/09
 * @version 1.2.4
 * @license Apache-2.0
 ***********************************************************************/

; Load some library
#Include .\lib\os-env.ahk
#Include .\lib\colorkits.ahk
#Include .\gamelogic\baseGame.ahk
#Include .\gamelogic\Init-lol-cfg.ahk
; Load user config
#Include .\gamelogic\client-ui-detect.ahk

; Global Configurations
global GameMode := "ARAM"        ; 0: ARAM, 1: SR
global ScreenX := 1400
global ScreenY := 1050

; Enable/Disable the script
global OpenFlag := 0

F1::
{
    global OpenFlag
    if (OpenFlag) {
        SetTimer(Activate, 0)
        SetTimer(Move, 0)
        SetTimer(UIDetect, 0)
        SetTimer(SearchEnemy, 0)
        SetTimer(ChangeFlag, 0)
        OpenFlag := 0
    }
    else {
        SetTimer(Activate, 5500)
        SetTimer(Move, 1000)
        SetTimer(UIDetect, 2500)
        SetTimer(SearchEnemy, 600)
        SetTimer(ChangeFlag, 30000)
        OpenFlag := 1
    }
    return
}

; create a new baseGame object
if (GameMode == "ARAM") {
    global game := ARAMGame(ScreenX, ScreenY)
    global lobby := lobbydetector(ScreenX, ScreenY, "ARAM")
}
else if (GameMode == "SR") {
    global game := SRGame(ScreenX, ScreenY)
    global lobby := lobbydetector(ScreenX, ScreenY, "SR")
}
else {
    MsgBox "GameMode Error"
}

Activate() {
    if (game != "") {
        game.Activate()
    }
    return
}

Move() {
    game.Move()
    return
}

UIDetect() {
    lobby.UIDetect()
    return
}

SearchEnemy() {
    game.SearchEnemy()
    return
}

ChangeFlag() {
    game.ChangeFlag()
    return
}
