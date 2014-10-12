Dim account, password, fifaClient,title,titleId,accounts, text, baseX,baseY,logLocation,imgLocation
// change value accordingly
fifaClient = "F:\Program Files\腾讯游戏\FIFA Online 3\TCLS\Client.exe"
sound = "F:\Program Files (x86)\腾讯游戏\QQ炫舞\Resources\media\audio\action\action_ui_youlechang.wav"
text = Plugin.File.ReadFileEx("C:\yole\qqaccount.txt")

//配置信息
Dim mgrCycleTimes,mode, autoSelectPlayer
mgrCycleTimes = 50// 循环多少次经理人
autoSelectPlayer = False //经理人是否自动选球员，自动选要改成True

// 1 ----- 手动登陆到经理人界面并且选好联赛和队伍，不用准备，自动刷经理人
// 2 ----- 循环登陆text文件中的每个账号，不打比赛。适用于9:00到9:30的活动
// 3 ----- 自动登陆，自动打经理人
// 4 ----- 手动登陆，自动经理人排位。登陆并且到练习场界面，然后F10
mode=3

// 多开需要调这两个变量
baseX = 0
baseY = 0

logLocation = "C:\yole\fifa.log" // optional, only used for debug
imgLocation = "C:\yole\imgs\" // optional, only used for debug
title = "FIFA Online 3登录程序"
accounts = Split(text, "|")

Randomize
titleId = Int((1000 - 1 + 1) * Rnd + 1)

//Delay  13*60*60*1000

If mode = 1 Then 
	For mgrCycleTimes
		Dim result
		result = runAutoMgr(Hwnd)
		If result = False Then 
			Exit For
		End If
		Delay 5000		
		Call log(info(0) & " finished autoMgr, count:" & count)
	Next
	Delay 1000
ElseIf mode = 2 Then
	Call startFifaHelper(False)
ElseIf mode = 3 Then
	Call startFifaHelper(True)
ElseIf mode = 4 Then
	Call enterAndRunMgrWithPeople()
Else 
	MsgBox("模式错误")
End If
RunApp sound


Function startFifaHelper(isPlay)
	Dim count, pair, info, Hwnd
	For count = 0 To (Ubound(accounts)-1) Step 1
		pair = accounts(count) // store account/password
		info = Split(pair, "/")
		Call startApp()
		Delay 2000 //
		
		Call login(info(0), info(1), info(2))
		
		Call launch(titleId)
		Hwnd = Plugin.Window.Find(0, "FIFA" & titleId)
		
		If isPlay = True Then 
		 	Call enterAndRunMgrWithAI(Hwnd)
		Else 
			Delay 30*1000 
		End If	
		
		Call exitGame(Hwnd)
	Next	
End Function


//-----below all functions defined-------
Function startApp()
	RunApp fifaClient
	Hwnd = Plugin.Window.Find(0, title)
	While Hwnd = 0
		Delay 5000
		Hwnd = Plugin.Window.Find(0, title)
	Wend
	Call Plugin.Window.Move(Hwnd, baseX, baseY)
	
	Do
		Delay 2000
		 // loading bar complete
		FindColor 800+baseX,650+baseY,1000+baseX,760+baseY,"FCF56C",intX,intY
		If intX > 0 And intY > 0 Then 
			Delay 800
			Exit Do
		End If
	Loop
	
	TracePrint "window position OK!"
End Function

Function login(name, pwd, region)
	MoveTo 1107+baseX, 386+baseY // account name text box
	Delay 500
	LeftClick 1
	Delay 300
	KeyPress "BackSpace", 12
	Delay 500
	Call log("start login with:" & name)
	SayString name
	Delay 1000
	KeyPress "Tab", 1  // password text box
	Delay 1000
	Call lib.键盘.KeyList(pwd,0,50)
	//Call typePwd(pwd)
	Delay 500
	Call Plugin.Window.Active(Hwnd)
	KeyPress "Enter", 1
	Delay 5000
	
	Call chooseRegion(region)
End Function

Function chooseRegion(region)
	For 4
		KeyPress "Left", 1
		Delay 800
	Next

	For (region - 1)
		Call Plugin.Window.Active(Hwnd)
		KeyPress "Right", 1
		Delay 1500
	Next
	
	Call Plugin.Window.Active(Hwnd)
	KeyPress "Enter", 1
End Function

Function launch(titleId)
	Hwnd = Plugin.Window.Find(0, "FIFA")
	While Hwnd = 0
		Delay 5000
		Hwnd = Plugin.Window.Find(0, "FIFA")
	Wend
	Delay 3000
	Call Plugin.Window.Move(Hwnd, baseX, baseY)
	Call log("window moved to 0,0")

	// wait for parepare screen	
	Do
		Delay 1850
		//FindColor baseX + 266, baseY + 436, baseX + 391, baseY + 484, "F6F5F5", intX, intY
		FindColor baseX+30,baseY+285,baseX+100,baseY+415,"FFFFFF",intX,intY
		If intX > 0 And intY > 0 Then 
			Exit Do
		End If
	Loop
	Delay 12 * 1000 
	
	MoveTo baseX+483, baseY+90 // move to a point in screen
	LeftClick 2
	Call log("move and clicked")
	Delay 2000
	MoveTo baseX+483, baseY+90 // move to X of Ad
	LeftClick 1// close X
	Call log("clicked X of ad")
	Delay 3000
	MoveTo baseX+571, baseY+482 // enter game
	LeftClick 1     // △ button
	Delay 15*1000  //a little long
	
	MoveTo baseX+325, baseY+430  // every day task button
	LeftClick 1
	Delay 3000 // need wait

	Call Plugin.Window.SetText(Hwnd, "FIFA" & titleId)// change title	
	//Call Plugin.File.CreateFolder("D:temp")
	//Delay 2 * 60 * 1000
	//TracePrint "finished:" & account(i)

End Function

Function enterMgrFromMainPage(Hwnd)
	Delay 2000
	MoveTo baseX+242, baseY+464
	Delay 500
	LeftClick 1
	Delay 5000  //shold long !!!!!!!!!
	MoveTo baseX+557, baseY+399// choose mgr mod
	Delay 500
	LeftClick 1
	Delay 6000	
	
	Call clickRenew()// 
	Delay 2*1000
	
	MoveTo baseX+446, baseY+406//choose VS computer
	Delay 500
	LeftClick 1
	Delay 1500
	Call log("choosed vs computer")

	MoveTo baseX+534, baseY+209 // click leauge
	Delay 500
	LeftClick 1
	Delay 1500
	MoveTo baseX+550, baseY+270// choose Ireland
	Delay 500
	MouseWheel -10 // scrool down
	Delay 500
	MouseWheel - 10 
	Delay 500
	MouseWheel - 10 
	Delay 500
	MouseWheel - 10 
	Delay 500
	MouseWheel - 10 
	Delay 500
	MouseWheel -10 
	Delay 1500
	LeftClick 1 // choose IreIand
	Delay 1500
	
	MoveTo baseX+540, baseY+285// click Team
	Delay 500
	LeftClick 1
	Delay 1500
	MoveTo baseX+533, baseY+474// choose Team
	Delay 1500
	MouseWheel -10 // scrool down
	Delay 200
	MouseWheel -10 
	Delay 1000
	LeftClick 1 // choose Team
	Delay 1500
End Function

Function enterRnakingMgrFromMainPage(Hwnd)
	Delay 2000
	MoveTo baseX+320, baseY+464
	Delay 500
	LeftClick 1
	Delay 5000  //shold long !!!!!!!!!	
End Function

//  *********    functions for mgr    ***************

Function runAutoMgr(Hwnd)
	runAutoMgr = True
	Dim startTime
	startTime = Plugin.Sys.GetTime()
	Call clickNext()
	Call log("clicked nexted 1")
	Delay 10 * 1000
	If autoSelectPlayer = True Then 
		MoveTo baseX+150, baseY+205
		Delay 500
		LeftClick 1
		Delay 1000
	End If
	Call clickNext()// 阵容界面
	Call log("clicked nexted 2")
	Delay 5000
	Call clickNext()// 选择球衣界面
	Call log("clicked nexted 3")
	Delay 10 * 1000
	Call Plugin.Window.Active(Hwnd)
	Delay 500
	KeyPress "Esc", 1
	
	// check if in prepare screen
	Do
		Delay 3000
		// check time, 15min
		If (Plugin.Sys.GetTime() - startTime) > 12 * 60 * 1000 Then 
			Call Plugin.Pic.PrintScreen(baseX+0, baseY+0, baseX+650, baseY+520, imgLocation & Replace(Plugin.Sys.GetDateTime(),":","`") & ".jpg")
			Call log("Error: long time in one mgr")
			runAutoMgr = False
			Exit Function
		End If
		
		FindColor baseX+585, baseY+460, baseX+630, baseY+500, "1E1E1E", intX, intY
		If intX>0 And intY>0 Then
			Call log("exit mgr mode")
			Exit Do
		End If
		
		//if in game, check if animation
		If isInAnimation() = True Then 
			Call Plugin.Pic.PrintScreen(baseX, baseY, baseX+650, baseY+520, imgLocation & Replace(Plugin.Sys.GetDateTime(),":","`") & ".jpg")
			Call log("exit amnomation in mgr")
			Call Plugin.Window.Active(Hwnd)
			Delay 500
			KeyPress "Esc", 1	
		End If
	Loop
	Delay 5000
	Call clickNext()
	Call log("clicked nexted 4")
	Delay 10*1000
	
	Call clickConfirmUpgrade()
	Delay 2000
	Call clickNext()
	Call log("clicked nexted poker")
	Delay 5000
	Call clickNext()
	Call log("clicked nexted 6")
	Delay 8 * 1000
	Call clickRenew()
	Delay 2 * 1000
	Call log("end runAutoMgr")
End Function

Function runRankingMgr(Hwnd)
	Call log("start mgr...")
	runRankingMgr = True
	Dim startTime
	startTime = Plugin.Sys.GetTime()
	
	MoveTo baseX+519, baseY+407// choose mgr mod
	Delay 500
	LeftClick 1
	Delay 30 * 1000
	Call log(" choose mgr mod")
	
	For 10
		If autoSelectPlayer = True Then 
			MoveTo baseX+150, baseY+205 //click auto select people
			Delay 500
			LeftClick 1
			Delay 1000
		End If
		Call clickNext()
		Delay 10 * 1000
	Next
	
	Call log("start loop checking mgr")
	// check if in prepare screen
	Do
		Delay 3000
		// check time, 20min
		If (Plugin.Sys.GetTime() - startTime) > 20 * 60 * 1000 Then 
			Call Plugin.Pic.PrintScreen(baseX+0, baseY+0, baseX+650, baseY+520, imgLocation & Replace(Plugin.Sys.GetDateTime(),":","`") & ".jpg")
			Call log("Error: long time in one mgr"&Plugin.Sys.GetTime())
			runRankingMgr = False
			Exit Function
		End If
		
		FindColor baseX+585, baseY+460, baseX+630, baseY+500, "1E1E1E", intX, intY
		If intX>0 And intY>0 Then
			Call log("exit mgr mode")
			Beep 
			Beep
			Exit Do
		End If
		
		//if in game, check if animation
		If isMgrRankingAnimation() = True Then 
			//Call Plugin.Pic.PrintScreen(baseX, baseY, baseX+650, baseY+520, imgLocation & Replace(Plugin.Sys.GetDateTime(),":","`") & ".jpg")
			Call log("exit amnomation in mgr")
			Call Plugin.Window.Active(Hwnd)
			Delay 500
			KeyPress "Esc", 1	
		End If
	Loop
	Delay 5000
	Call clickNext() // 评分
	Delay 10*1000
	
	Call clickConfirmUpgrade() //
	Delay 2000
	Call clickNext()// poker
	Call log("clicked nexted poker")
	Delay 5000
	Call clickNext()// after poker
	Call log("clicked nexted 6")
	Delay 10*1000
	Call clickRenew()
	Call log("end runRankingMgr")
End Function

Function enterAndRunMgrWithAI(Hwnd)
	Call enterMgrFromMainPage(Hwnd)
	For mgrCycleTimes
		Dim result
		result = runAutoMgr(Hwnd)
		If result = False Then 
			Exit For
		End If
		Delay 5000		
		Call log(info(0) & " finished autoMgr, count:" & count)
	Next
	Delay 1000
End Function

Function enterAndRunMgrWithPeople()
	Hwnd = Plugin.Window.Find(0, "FIFA")
	If Hwnd = 0 Then 
		MessageBox ("请重新手动登陆再使用该功能,如果之前使用过该脚本刷过，也需要手动重登。。")
		ExitScript
	End If
	Delay 1000
	Call Plugin.Window.Move(Hwnd, baseX, baseY)
	Delay 1000
	//Call Plugin.Window.SetText(Hwnd, "FIFA" & titleId)// change title	
	Call enterRnakingMgrFromMainPage(Hwnd)
	For mgrCycleTimes
		Dim result
		result = runRankingMgr(Hwnd)
		If result = False Then 
			Exit For
		End If
		Delay 5000		
		Call log(info(0) & " finished ru, count:" & count)
	Next
	Delay 1000
End Function


Function isInAnimation()
	FindColor baseX+575,baseY+42,baseX+614,baseY+74,"ECEAE9",intX,intY
	If intX > 0 And intY > 0 Then 
		isInAnimation = False
	Else 
		isInAnimation = True
	End If	
End Function

Function isMgrRankingAnimation()
	FindColor baseX+477,baseY+32,baseX+620,baseY+90,"EEEAE6",intX,intY
	If intX > 0 And intY > 0 Then 
		isMgrRankingAnimation = False
	Else 
		isMgrRankingAnimation = True
	End If	
End Function

Function clickNext()
	MoveTo baseX+600, baseY+483
	Delay 500
	LeftClick 1
End Function

Function clickConfirmUpgrade()
	IfColor baseX+333, baseY+414, "9D9795", 0 Then
		MoveTo baseX+333, baseY+414
		Delay 500
		LeftClick 1
		Call log("clicked upgrade")
	End If
	
	IfColor baseX+333,baseY+455,"9E9996",0 Then
		MoveTo baseX+333, baseY+455
		Delay 500
		LeftClick 1
		Call log("clicked upgrade")
	End If
End Function


Function clickRenew()
	// find if has renew button
	FindColor baseX + 244, baseY + 139, baseX + 430, baseY + 496, "8C8684", renewX, renewY
	FindColor baseX + 244, baseY + 139, baseX + 430, baseY + 496,"A4A1A4",renewX2,renewY2
	Call log("Renew " & renewX & renewX2)
	If renewX > 0 Or renewX2 > 0 Then 
			Call log("need to renew")
			MoveTo renewX, renewY
			Delay 1000
			LeftClick 1
			Call log("clicked renew")
			
			Delay 2000
			MoveTo baseX+318, baseY+305  // click confirm button
			Delay 500
			LeftClick 1
	Call log("exit click renew")
	End If		
		
End Function

Function exitGame(Hwnd)
	Call Plugin.Window.Active(Hwnd)
	Delay 500
	MoveTo baseX+628, baseY+13
	LeftClick 1
	Delay 1500
	MoveTo baseX+294, baseY+301
	LeftClick 1
	Delay 500
	//Call Plugin.File.DeleteFolder("D:temp")
	Call log("exited game")
End Function

Function log(info)
	Call Plugin.File.WriteFileEx(logLocation, Plugin.Sys.GetDateTime() & "   " & info)
End Function
