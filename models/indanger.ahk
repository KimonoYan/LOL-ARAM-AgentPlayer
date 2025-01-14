#Requires AutoHotkey v2.0

IsInDanger(){
    global GameMode
    global ScreenX 
    global ScreenY 
    if(ScreenX == 1400 && ScreenY == 1050 && GameMode == "ARAM") {
        return IsColorSeems(719,1010,"0x010D07")    ; 大约60%血量时触发
    }
    
}

OnEmergency(){
    ;sendinput 空格
    ToolTip("OnEmgc", 0, 0)

    ; 方式二
    SendInput("{y}")
    Sleep(100)
    SendInput("{y}")
    Sleep(300)
    SendInput("{v}")    ; 这个v很精妙，可以让视角回到自己身上且往对面缓慢移动
    if(IsColorSeems(1106,1053,"0x93865D")){ ; 锁定视角图标
        SendInput("{y}")            ; 锁定自己中心视角消抖
    }

    return 
}


OnEmergency_Old(){
    ; 方式一
    DllCall("keybd_event", "UChar", 0x20, "UChar", 0, "UInt", 0, "Ptr", 0)  ; 按下空格键
    Sleep(500)  ; 保持3秒
    DllCall("keybd_event", "UChar", 0x20, "UChar", 0, "UInt", 2, "Ptr", 0)  ; 释放空格键


}