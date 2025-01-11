;;; 注意：这个版本是仅台服版本，分辨率支持 1400x1050 无边框模式

#NoEnv
SetBatchLines, -1
Process, Priority,, High
SetControlDelay -1
SetKeyDelay -1
; 使用较慢但更兼容的发送模式
SendMode Play
SetWorkingDir %A_ScriptDir%

;如果不是管理员，就自动切换管理员运行
if !A_IsAdmin
	Run *RunAs "%A_AhkPath%" /r "%A_ScriptFullPath%"

; 全局变量定义
MoveFlag := 0
FollowTargetFlag := 0

; 定义默认的跟随位置左边（通常在正中间偏右一点的位置）
DefaultposX = 760
DefaultposY = 540

; 定义搜索范围的左上角和右下角坐标
StartX := 20
StartY := 200
EndX := 1100
EndY := 800

; 红色目标的匹配程度允许的容差，越高越癫
RedCrazyLevel := 4

;这个是启动按键组
F1::
	If (OpenFlag)
	{
		SetTimer, Action, off
		SetTimer, Move, off
		SetTimer, UIDetect, off
		SetTimer, SearchEnemy, off
		SetTimer, ChangeFlag, off
		OpenFlag := ""
	}
	Else
	{
		SetTimer, Action, 5500
		SetTimer, Move, 1000
		SetTimer, UIDetect, 2500
		SetTimer, SearchEnemy, 600
		SetTimer, ChangeFlag, 30000
		OpenFlag := 1
	}
;MouseGetPos, mouseX, mouseY
;DllCall("SetCursorPos", "int", 100, "int", 100)
Return

ChangeFlag:
	FollowTargetFlag := FollowTargetFlag + 1
	if(FollowTargetFlag > 1)
	{
		FollowTargetFlag := 0
	}
Return

UIDetect:
	;这里2.5s进行一次移动位置的改变
	MoveFlag := MoveFlag + 1
	if(MoveFlag > 2)
	{
		MoveFlag := 0
	}

	if((GetColor(1002,990)=="0x0E151A" || GetColor(1007,990)=="0x0E1519") && GetColor(157,163)=="0x1A525F")   ; 在房间且对局是亮的(乱斗or进步之桥)
	{
		MouseClick, left, 800,1020, 1
	}
	if(GetColor(951,483)=="0x00668C")   ; 接受
	{
		MouseClick, left, 948,832, 1
	}
	if(GetColor(987,986)=="0x242423" || GetColor(979,987)=="0x01121C" || GetColor(84,79)=="0x3C3D3D")	;大厅：再来一场
	{
		MouseClick, left, 800,1020, 1
	}
	if(GetColor(796,509)=="0x8A6F38")
	{
		MouseClick, left, 780,880, 1
	}
	if(GetColor(638,655)=="0x01111C" || GetColor(640,657)=="0x383939" || GetColor(971,685)=="0x01111C")	; continue-进步之桥版本
	{
		MouseClick, left,527,683, 1

	}
	if(GetColor(815,560)=="0x2F2748")
	{
		MouseClick, left,815,560, 1
	}
	if(GetColor(961,668)=="0x1B2566" || GetColor(968,539)=="0xF2E0C3" || GetColor(997,214)=="0xEEE4D0")		;;专精等级，level up跳过
	{
		MouseClick, left, 960,1020, 1

	}
	if(GetColor(969,470)=="0xF0E6D2")		;; 有人挂机
	{
		MouseClick, left,962,639, 1
	}
	if(GetColor(904,472)=="0xF0E6D2")		;;feedback
	{
		MouseClick, left,962,639, 1
	}

Return

SearchEnemy:

	; 定义红色的颜色值，这里使用RGB(255,0,0)作为示例
	;
	SearchColor := 0x9A251B

	; 判断是否死亡，如果死亡状态，按P购物
	if( IsColorSeems(443,1012, "0x010D06") && ( IsColorSeems(441,1029, "0x010304") || GetColor(434,1029)=="0x000000" ) )
	{
		;MsgBox, G!
		sendinput {p}
		sleep 100

		; 台服无法使用MouseMove，使用MouseClick进行规避
		MouseClick, X2, 360,540,1
		sleep 100

		SendInput {Click}	;input mode
		sleep 30
		SendInput {Click}
		sleep 20

		MouseClick, X2, 760,540,1
		sleep 100

		SendInput {Click}
		sleep 20
		SendInput {Click}
		sleep 30

		sendinput {p}
		sleep 100

		Return
	}

	; 搜索敌人并移动鼠标: if未找到目标-移动，else找到目标-攻击  0x380502
	PixelSearch, 横坐标, 纵坐标, StartX, StartY, EndX, EndY ,0xB13E34, RedCrazyLevel, Fast RGB
	if (ErrorLevel != 0)
	{
		MouseGetPos, mouseX, mouseY
		if(MoveFlag == 0)
		{
			MouseClick, X2, (DefaultposX-20),(DefaultposY-40),0
		}
		else if(MoveFlag == 1)
		{
			MouseClick, X2, (DefaultposX-80),(DefaultposY+20),0
		}
		else if(MoveFlag == 2)
		{
			MouseClick, X2, (DefaultposX+55),(DefaultposY+20),0
		}
		; 归还鼠标指针--这里有个逻辑bug，因为没有设置延迟，导致移动指令无效了
		MouseClick, X2, %mouseX%, %mouseY%,0
		;MsgBox, 指定区域没找到！此时会走到土著附近的一个点去
	}
	else
	{
		;PixelSearch, 玩家位置X, 玩家位置Y, StartX, StartY, EndX, EndY ,0x479834,1, Fast RGB
		;if (ErrorLevel != 0)
		;{
		;MsgBox, 找bu到玩家 %玩家位置X% %玩家位置Y%！

		;}
		;else{
		;MsgBox, 找到玩家 %玩家位置X% %玩家位置Y%！

		;MsgBox,%横坐标%,%纵坐标%，瞄准敌人，开炮！
		targetX := 横坐标 + 55
		targetY := 纵坐标 + 80

		;MouseClick, X2, targetX,targetY, 1,D		; 规避方式2：使用 fifth Btn，目的是要绑定一个按键用来锁敌
		MouseClick, X2, targetX,targetY, 1			; 修改0104：使用默认 D&U 参数

		sleep 10

		sendinput rderqw
		sleep 100

		sendinput,^r
		sleep 10
		sendinput,^w
		sleep 15
		sendinput,^e
		sleep 10
		sendinput,^q
		sleep 20

		sleep 100
		sendinput qwrd
		;}

	}

return

Move:

	;Foucus Player view when encount unhealthy issue
	if(GetColor(719,1010)=="0x010D07")
	{
		sendinput {y}
		sleep 100
		sendinput {y}
	}
	else
	{
		if(FollowTargetFlag == 0){
			sendinput {F2}
		}
		else{
			sendinput {F3}
		}
		sendinput {v}
	}

Return

Action:
	tooltip, 开启, 0, 0

	;激活游戏窗口，建议用Riot官方的启动器作为background程序，避免发生F1-F4冲突
	IfWinExist, League of Legends (TM) Client
	{
		WinActivate
		WinSet, AlwaysOnTop, , League of Legends (TM) Client
	}
	else{
		WinActivate, League of Legends
		
	}

Return

;RGB通道相似函数
IsColorSeems(x, y, color)
{
	; 定义两个颜色的RGB值

	color1 := GetColor(x,y)  ; 第一个颜色的十六进制表示
	color2 := color  ; 第二个颜色的十六进制表示

	; 将十六进制颜色值转换为十进制RGB值
	Red1 := ((color1 >> 16) & 0xFF)
	Green1 := ((color1 >> 8) & 0xFF)
	Blue1 := (color1 & 0xFF)

	Red2 := ((color2 >> 16) & 0xFF)
	Green2 := ((color2 >> 8) & 0xFF)
	Blue2 := (color2 & 0xFF)

	; 计算两个颜色在RGB通道上的差异，并使用Abs函数取绝对值
	deltaRed := Abs(Red1 - Red2)
	deltaGreen := Abs(Green1 - Green2)
	deltaBlue := Abs(Blue1 - Blue2)

	; 定义颜色差异的阈值
	threshold := 5  ; 这个值可以根据需要调整

	; 判断两个颜色是否接近
	if (deltaRed <= threshold && deltaGreen <= threshold && deltaBlue <= threshold) {
		return true
	} else {
		return false
	}
}

;取色组
GetColor(x,y)
{
	PixelGetColor, color, x, y, RGB
	StringRight color,color,10 ;
	return color
}

;绝对取色
F9::
	MouseGetPos, mouseX, mouseY
	PixelGetColor, color, %mouseX%, %mouseY%, RGB
	StringRight color,color,10
	;tooltip, %mouseX%，%mouseY%颜色是：%color%
	tooltip, %mouseX%，%mouseY%颜色是：%color%, 0, 0
	Clipboard=GetColor(%mouseX%,%mouseY%)=="%color%"
return

;相似取色
F11::
	MouseGetPos, mouseX, mouseY
	PixelGetColor, color, %mouseX%, %mouseY%, RGB
	StringRight color,color,10
	;IsColorSeems()
	tooltip, %mouseX%，%mouseY%颜色seems：%color%, 0, 0
	Clipboard=IsColorSeems(%mouseX%,%mouseY%, "%color%")
return