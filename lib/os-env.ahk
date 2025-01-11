#Requires AutoHotkey v2.0

; SetBatchLines -1
ProcessSetPriority "High"
SetControlDelay -1
SetKeyDelay -1
; 使用较慢但更兼容的发送模式
SendMode "Play"
SetWorkingDir A_ScriptDir

; 如果不是管理员，就自动切换管理员运行
if !A_IsAdmin
	Run("*RunAs", A_AhkPath, "/r " . A_ScriptFullPath)