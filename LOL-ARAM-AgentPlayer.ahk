#NoEnv
SetBatchLines, -1
Process, Priority,, High
SetControlDelay -1
SetKeyDelay -1
SendMode Input
SetWorkingDir %A_ScriptDir%

;如果不是管理员，就自动切换管理员运行
if !A_IsAdmin 
	Run *RunAs "%A_AhkPath%" /r "%A_ScriptFullPath%"


;这个是启动按键组
F1::  
	If (OpenFlag)
	{
		SetTimer, Action, off
		SetTimer, Move, off
		SetTimer, UIDetect, off
		SetTimer, SearchEnemy, off
		OpenFlag := ""	
	}
	Else  
    	{  
		SetTimer, Action, 550
		SetTimer, Move, 50
		SetTimer, UIDetect, 1500
		SetTimer, SearchEnemy, 500
		OpenFlag := 1
	}

Return


UIDetect:
if(GetColor(525,180)=="0x1A2128" && GetColor(505,680)=="0xFFFFFF")   ; 在房间且对局是亮的
{
	Click 505,680
}
if(GetColor(573,298)=="0x0C3048")   ; 接受
{
	Click 593,550
}
if(GetColor(636,657)=="0x333B42" || GetColor(639,657)=="0x36484F")	;continue
{
	Click 527,683
}
Return



SearchEnemy:

; 定义默认的跟随位置左边（通常在正中间偏右一点的位置）
	DefaultposX = 760
	DefaultposY = 540

; 定义搜索范围的左上角和右下角坐标
	StartX := 10
	StartY := 180
	EndX := 1200
	EndY := 850

; 定义红色的颜色值，这里使用RGB(255,0,0)作为示例
	SearchColor := 0x9A251B

; 判断是否死亡，如果死亡状态，按P购物
	if(GetColor(437,1026)=="0x010304" && GetColor(438,1008)=="0x010D07")
	{
		;MsgBox, G!
		sendinput {p}
		sleep 300
	
		MouseMove, 360,540
		sleep 300
		Click, Left
		sleep 100
		Click, Left
		sleep 100

		MouseMove, 760,540
		sleep 300
		Click, Right
		sleep 100
		Click, Right
		sleep 100

		sendinput {p}
		sleep 300
		Return
	}

; 搜索敌人并移动鼠标
	PixelSearch, 横坐标, 纵坐标, StartX, StartY, EndX, EndY ,0x9A251B, 2, Fast RGB
	if ErrorLevel
		MouseMove, DefaultposX,DefaultposY
		;MsgBox, 指定区域没找到！此时会走到土著附近的一个点去
	else
	{
		;MsgBox,%横坐标%,%纵坐标%，瞄准敌人，开炮！
		targetX := 横坐标 + 35
		targetY := 纵坐标 + 70
		MouseMove, targetX,targetY



		sendinput rerqw
		sleep 130
	
		sendinput,^r
		sleep 10
		sendinput,^w
		sleep 15
		sendinput,^e
		sleep 10
		sendinput,^q
		
		sleep 20

		sendinput re
		sleep 150
		sendinput qwrd

	}

return



Move:
	sendinput {F2}
	sendinput {v}
Return



Action:

    tooltip, 开启, 760, 1  


   ;激活游戏窗口
   IfWinExist, League of Legends (TM) Client
   {
       WinActivate
   }

Return



;取色组
GetColor(x,y)
{
PixelGetColor, color, x, y, RGB
StringRight color,color,10 ;
return color
}


F9::
MouseGetPos, mouseX, mouseY
PixelGetColor, color, %mouseX%, %mouseY%, RGB
StringRight color,color,10 ;
tooltip, %mouseX%，%mouseY%颜色是：%color%
Clipboard=GetColor(%mouseX%,%mouseY%)=="%color%"
return