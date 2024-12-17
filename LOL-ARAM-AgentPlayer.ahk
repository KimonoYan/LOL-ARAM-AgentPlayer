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



; 全局变量定义
MoveFlag := 0
FollowTargetFlag := 0

; 定义默认的跟随位置左边（通常在正中间偏右一点的位置）
DefaultposX = 760
DefaultposY = 540

; 定义搜索范围的左上角和右下角坐标
StartX := 10
StartY := 180
EndX := 1200
EndY := 850

; 红色目标的匹配程度允许的容差，越高越癫
RedCrazyLevel := 1



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
		SetTimer, Action, 3500
		SetTimer, Move, 180
		SetTimer, UIDetect, 2500
		SetTimer, SearchEnemy, 500
		SetTimer, ChangeFlag, 30000
		OpenFlag := 1
	}

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

if((GetColor(525,180)=="0x1A2128" && GetColor(505,680)=="0xFFFFFF") || (GetColor(101,107)=="0x1CA9D7"))   ; 在房间且对局是亮的(乱斗or进步之桥)
{
	Click 505,680
}
if(GetColor(573,298)=="0x0C3048" || GetColor(633,324)=="0x006C90" || GetColor(815,560)=="0x081518")   ; 接受
{
	Click 593,550
}
if(GetColor(636,657)=="0x333B42" || GetColor(639,657)=="0x36484F")	;continue
{
	Click 527,683
}
if(GetColor(638,655)=="0x01111C" || GetColor(640,657)=="0x383939" || GetColor(971,685)=="0x01111C")	;continue-进步之桥版本
{
	Click 527,683
}
if(GetColor(815,560)=="0x2F2748")
{
	Click 815,560
}
Return



SearchEnemy:

; 定义红色的颜色值，这里使用RGB(255,0,0)作为示例
	;
	SearchColor := 0x9A251B

; 判断是否死亡，如果死亡状态，按P购物
	if((GetColor(437,1026)=="0x010304" && GetColor(438,1008)=="0x010D07") )
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
		Click, Left
		sleep 100
		Click, Left
		sleep 100

		sendinput {p}
		sleep 300
		Return
	}

; 搜索敌人并移动鼠标: if未找到目标-移动，else找到目标-攻击
	PixelSearch, 横坐标, 纵坐标, StartX, StartY, EndX, EndY ,0x9A251B, RedCrazyLevel, Fast RGB
	if (ErrorLevel != 0)
	{
		if(MoveFlag == 0)
		{
			MouseMove, (DefaultposX-20),(DefaultposY-40)
		}
		else if(MoveFlag == 1)
		{
			MouseMove, (DefaultposX-80),(DefaultposY+20)
		}
		else if(MoveFlag == 2)
		{
			MouseMove, (DefaultposX+55),(DefaultposY+20)
		}
		
		;MsgBox, 指定区域没找到！此时会走到土著附近的一个点去
	}
	else
	{
		PixelSearch, 玩家位置X, 玩家位置Y, StartX, StartY, EndX, EndY ,0x63DB5D,1, Fast RGB
		if (ErrorLevel != 0)
		{
			;MsgBox, 找bu到玩家 %玩家位置X% %玩家位置Y%！
		}
		else{
			;MsgBox, 找到玩家 %玩家位置X% %玩家位置Y%！
		
		
			;MsgBox,%横坐标%,%纵坐标%，瞄准敌人，开炮！
			targetX := 横坐标 + 35
			targetY := 纵坐标 + 70
			MouseMove, targetX,targetY
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
		}

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
	else{
		if(FollowTargetFlag == 0){
			sendinput {F2}
		}
		else{
			sendinput {F4}
		}
		sendinput {v}
	}
	
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


F11::
MouseGetPos, mouseX, mouseY
PixelGetColor, color, %mouseX%, %mouseY%, RGB
StringRight color,color,10 ;
tooltip, %mouseX%，%mouseY%颜色是：%color%
Clipboard=GetColor(%mouseX%,%mouseY%)=="%color%"
return