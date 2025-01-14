# LOL-ARAM-AgentPlayer
基于AHK脚本的英雄联盟(LoL)极地大乱斗模式自动操作脚本，用来研究以何种形式复刻玩家的游戏行为。

您可以花费3分钟时间进行配置，让这个程序帮你完成一场LoL大乱斗游戏。 

An auto script for the League of Legends(LoL) ARAM mode based on AHK script, aimed at researching whether the gaming patterns of players can be surpassed by machines and in what form.(For educational purposes only)
You can spend 3 minutes to configure, and let this program help you complete a game of ARAM.

# 注意事项
本项目所使用技术为取色和模拟按键等非侵入式方法，不对游戏内存进行非法访问和存取。后续的逻辑判断方面会逐步按需增加Fuzzing和ML等方式，并完善Monitor以支持用于分析的行为数据生成。当前版本仅线性模拟。

本项目仅供学习使用，作者仅提供有限的技术支持，谢绝任何与此项目直接有关的商用合作。

本项目累计测试约500小时，暂未出现被检测情况。推荐5轮车找朋友沟通后进行测试。**切勿用来进行刷金币、恶意掉分和elo优化等行为**。由恶意行为导致的一切游戏资产封停和受损，作者概不负责。

# 使用说明
请按照以下步骤安装ahk并运行：

1）clone仓库中ahk_v2安装包和.ahk后缀的脚本源码

2）设置游戏内屏幕分辨率 1400x1050 无边框模式，游戏大厅客户端选择 1280x720 

  -- 如需使用虚拟机，建议直接在显示设置-高级中，设置分辨率为 1400x1050
  
3）在LOL客户端，热键设置中，将玩家移动的备选快捷键设置为v

4）双击运行LOL-ARAM-AgentPlayer.ahk脚本，进入大乱斗模式组队页面，按F1启动


# 更新日志
## v1.2.6 
  更新屏幕识别范围，现在不会出现因目标在边缘，导致窗口错误滑动的情况；
  更新 SearchEnemy() 函数的配准逻辑（将文字方案转为图像方案了）；
  优化该脚本暂停问题，现在允许 alt+tab 暂停，再次按下 alt+tab 时退出脚本；
  优化了高屏幕分辨率下的大厅识别相关功能。
  

## v1.2.5 
  更新ARAM模式的结构，将识别和攻击逻辑进行分离；
  优化部分识别逻辑，显著增加了1400x1050分辨率下的锁敌性能。

## v1.2.4 
  将原有代码根据不同的操作系统和屏幕分辨率解耦，以OOP作为基本结构，对代码进行工程化。

## v1.2.0 
  由于频繁的取色问题，将原有代码从ahkv1更新到ahkv2。

## v1.1.0 
  提交支持匹配、完成对局的最小原型，基于ahkv1。
