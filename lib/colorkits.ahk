#Requires AutoHotkey v2.0

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



; 取色组
GetColor(x, y) {
    color := PixelGetColor(x, y, "RGB")
    color := SubStr(color, -10) ; 获取颜色的最后10个字符
    return color
}

; 绝对取色
F9:: {
    MouseGetPos &mouseX, &mouseY
    color := PixelGetColor(mouseX, mouseY, "RGB")
    color := SubStr(color, -10)
    ; tooltip, mouseX, mouseY "颜色是：" color
    tooltip(mouseX ", " mouseY " 颜色是：" color, 0, 0)
    Clipboard := (GetColor(mouseX, mouseY) == color)
}

; 相似取色
F11:: {
    MouseGetPos &mouseX, &mouseY
    color := PixelGetColor(mouseX, mouseY, "RGB")
    color := SubStr(color, -10)
    ; IsColorSeems()
    tooltip(mouseX ", " mouseY " 颜色seems：" color, 0, 0)
    Clipboard := IsColorSeems(mouseX, mouseY, color)
}

