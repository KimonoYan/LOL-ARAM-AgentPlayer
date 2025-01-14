#Requires AutoHotkey v2.0

#Include ..\lib\colorkits.ahk

class lobbydetector {
    Resolution := ""   ; "High-1400" or "Low-1280"
    GameMode := ""     ; "ARAM" or "SR"

    __New(ScreenX, ScreenY, GameMode) {
        if (ScreenX == 1400 && ScreenY == 1050) {
            this.Resolution := "High-1400"
        }
        else if (ScreenX == 1280 && ScreenY == 720) {
            this.Resolution := "Low-1280"
        }
        else {
            MsgBox "Resolution Error"
        }

        if (GameMode == "ARAM") {
            this.GameMode := "ARAM"
        }
        else if (GameMode == "SR") {
            this.GameMode := "SR"
        }
        else {
            MsgBox "GameMode Error"
        }
    }

    UIDetect() {
        if (this.Resolution == "High-1400") {
            this.UIDetect_High()
        }
        else if (this.Resolution == "Low-1280") {
            this.UIDetect_Low()
        }
    }

    ; Usage: UIDetect_High operation are required by manual system environment configurations below.
    ;        OS-resolution should be 2560x1440, dpi = 150%
    ;        lobby-resolution = 1280x720
    ;        game-resolution = 1400x1050
    UIDetect_High() {

        ; 如果有游戏进程，直接返回
        if (WinExist("League of Legends (TM) Client")) {
            return
        }

        if (GetColor(155, 163) == "0x1A4F5A")   ; 在房间(乱斗)
        {
            MouseClick("left", 800, 1020, 1)
        }
        if (GetColor(951, 483) == "0x00668C")   ; 接受
        {
            MouseClick("left", 950, 830, 1)
        }
        if (GetColor(987, 986) == "0x242423" || GetColor(979, 987) == "0x01121C" || GetColor(84, 79) == "0x3C3D3D" ||
        GetColor(53, 44) == "0x060C10" || GetColor(118, 205) == "0x0ACBE6" || GetColor(55, 46) == "0xBDAB7D")	; 大厅：再来一场  会产生全局干扰
        {
            MouseClick("left", 800, 1020, 1)
        }
        if (GetColor(796, 509) == "0x8A6F38") {
            MouseClick("left", 780, 880, 1)
        }
        if (GetColor(638, 655) == "0x01111C" || GetColor(640, 657) == "0x383939" || GetColor(971, 685) == "0x01111C")	; continue-进步之桥版本
        {
            MouseClick("left", 527, 683, 1)
        }
        if (GetColor(815, 560) == "0x2F2748") {
            MouseClick("left", 815, 560, 1)
        }
        if (GetColor(961, 668) == "0x1B2566" || GetColor(968, 539) == "0xF2E0C3" || GetColor(997, 214) == "0xEEE4D0")		;;专精等级，level up跳过
        {
            MouseClick("left", 960, 1020, 1)
        }
        if (GetColor(969, 470) == "0xF0E6D2" || GetColor(904, 472) == "0xF0E6D2")		;; 有人挂机 & ;;feedback
        {
            MouseClick("left", 962, 639, 1)
        }

        ; if (GetColor(932, 51 == "0xDDD5C3")) {  ;; 评价
        ;     MouseClick("left", 962, 1000, 1)
        ; }

    }

    UIDetect_Low() {
        return -1
    }
}

;; these macros are used to detect the LOL-lobby UI

;; For the sake of high cohesion, combine KEY-PRESS detection and CLICK actions together.

; RoomDetect(x, y, expectedColor) {
;     if (lobby.Resolution == "High-1450")
;         return GetColor(155, 163) == "0x1A4F5A"
;     else if (lobby.Resolution == "Low-1280")
;         return -1

; }
