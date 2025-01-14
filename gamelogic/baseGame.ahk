#Requires AutoHotkey v2.0

#Include ..\lib\colorkits.ahk
#Include ..\models\searchenemy.ahk


; 创建一个 baseGame 基类，用于继承
class baseGame {
    ; 构造函数
    __New(screen_x, screen_y) {
        ; 定义屏幕分辨率
        this.ScreenX := screen_x       ; 初始化为0，后续会被赋值
        this.ScreenY := screen_y

        ; 定义默认的跟随位置左边（通常在正中间偏右一点的位置）
        this.DefaultposX := this.ScreenX / 2
        this.DefaultposY := this.ScreenY / 2

        ; 定义搜索范围的左上角和右下角坐标
        this.StartX := 0
        this.StartY := 0
        this.EndX := 0
        this.EndY := 0

        ; 定义定时移动所使用的的标志
        this.MoveFlag := 0
        this.FollowTargetFlag := 0
    }

    ChangeFlag() {
        this.FollowTargetFlag := this.FollowTargetFlag + 1
        if (this.FollowTargetFlag > 1) {
            this.FollowTargetFlag := 0
        }
        tooltip "FollowTargetFlag: " this.FollowTargetFlag, 0, 0
        return
    }
    ; 成员函数
}


class ARAMGame extends baseGame {
    ; 构造函数
    __New(screenX, screenY) {
        MsgBox "ARAMGame 对象已创建"
        ; 配置项
        this.RedCrazyLevel := 4

        If(ScreenX == 1400 && ScreenY == 1050) {
            this.StartX := 0.1 * ScreenX
            this.StartY := 0.1 * ScreenY
            this.EndX := 0.9 * ScreenX
            this.EndY := 0.9 * ScreenY
            this.x_offset := 55
            this.y_offset := 80
        }
        else if(ScreenX == 1280 && ScreenY == 720) {
            this.StartX := 0
            this.StartY := 0
            this.EndX := 0
            this.EndY := 0
        }
        else {
            MsgBox "Resolution Error"
        }

        ; 中间变量组-无需配置
        this.FollowTargetFlag := 0      ; ARAM 模式下的跟随目标标志位
        this.targetX := 0
        this.targetY := 0
        this.IsFoundEnemy := 0

    }


    Activate() {
        ; 激活游戏窗口，建议用Riot官方的启动器作为background程序，避免发生F1-F4冲突
        if(WinExist("League of Legends (TM) Client")) {
            WinActivate
            ; WinSetAlwaysOnTop("League of Legends (TM) Client", true)
        } else {
            WinActivate("League of Legends")
        }
        return
    }

    Move() {
        ; Focus Player view when encountering an unhealthy issue
        if (GetColor(719, 1010) == "0x010D07") {
            SendInput("{y}")
            Sleep(100)
            SendInput("{y}")
        } else {
            if (this.FollowTargetFlag == 0) {
                SendInput("{F2}")
            } else {
                SendInput("{F3}")
            }
            SendInput("{v}")
        }
        return
    }

    SearchEnemy() {

        ; 判断是否死亡，如果死亡状态，按P购物
        if (this.IsPlayerDead()) {
            this.Shopping()
        }
        local posX := 0
        local posY := 0
    
        this.IsFoundEnemy := LocateEnemy_FindByImg(&posX, &posY, this.StartX, this.StartY, this.EndX, this.EndY)
        if(this.IsFoundEnemy){      ;1.找到敌人；2.找到敌人的坐标
            ; MsgBox "Found Enemy at " posX "x" posY
            this.targetX := posX + 55
            this.targetY := posY + 80
            this.MoveMouseInGame(this.targetX, this.targetY)
            sleep(10)
            this.GrazySkill()
        }
        else{
            this.MoveMouseInGame(0.5 * ScreenX, 0.5 * ScreenY)
        }
    
        return

    }

    GrazySkill() {
        SendInput("rderqw")
        Sleep(100)
        SendInput("^r")
        Sleep(10)
        SendInput("^q")
        Sleep(15)
        SendInput("^e")
        Sleep(10)
        SendInput("^w")
        Sleep(20)
        SendInput("qwrd")
        return
    }

    MoveMouseInGame(x, y) {
        MouseClick("X2", x, y, 1)
        return
    }
    
    IsPlayerDead() {
        return IsColorSeems(443, 1012, "0x010D06") && (IsColorSeems(441, 1029, "0x010304") || GetColor(434, 1029) ==
        "0x000000")
    }

    Shopping() {
        ;MsgBox, G!
        SendInput("{p}")
        Sleep(100)

        ; 台服无法使用MouseMove，使用MouseClick进行规避
        MouseClick("X2", 360, 540, 1)
        Sleep(100)

        SendInput("{Click}")	;input mode
        Sleep(30)
        SendInput("{Click}")
        Sleep(20)

        MouseClick("X2", 760, 540, 1)
        Sleep(100)

        SendInput("{Click}")
        Sleep(20)
        SendInput("{Click}")
        Sleep(30)

        SendInput("{p}")
        Sleep(100)

        return
    }

    ChangeFlag() {
        this.FollowTargetFlag := this.FollowTargetFlag + 1
        if (this.FollowTargetFlag > 1) {
            this.FollowTargetFlag := 0
        }
        tooltip "FollowTargetFlag: " this.FollowTargetFlag, 0, 0
        return
    }

    Is_Ingame() {
        ; 判断是否在游戏中
        return
    }

    Is_BlueTeam() {
        ; 判断是否是蓝色方
        return
    }

}

class SRGame extends baseGame {
    ; 构造函数
    __New(screenX, screenY) {
        MsgBox "SRGame 对象已创建"
    }

}
