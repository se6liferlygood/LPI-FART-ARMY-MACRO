#Requires AutoHotkey v2.0.18+
#SingleInstance Force
ProcessSetPriority "H"
SetKeyDelay(-1)
SetMouseDelay(-1)
CoordMode("ToolTip","Screen")
SetTitleMatchMode(3)
SendLevel(1)

multiStr(str,multi) {
    return StrReplace(Format("{:0" multi "}",0),0,str)
}

ahkExist(ahkFile) {
    prevDetectHiddenWindows := A_DetectHiddenWindows, prevTitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows(true), SetTitleMatchMode(2) ;2 is default
    exists := WinExist(ahkFile " ahk_class AutoHotkey")
    DetectHiddenWindows(prevDetectHiddenWindows), SetTitleMatchMode(prevTitleMatchMode)
    return exists
}

checkReader() {
    if(!FileExist("files\info")) {
        FileAppend("","files\info")
    }
    if(!ahkExist("FARTlog.ahk")) {
        Run "files\FARTlog.ahk"
    }
}

global title := "FART ARMY MACRO"

InputBox2(prompt,default) {
    global title
    return prompt=""? default:InputBox(prompt,title,,default).Value
}

global vars := ["smashKeys","smashTimes","per","keys","tmin","tmax","tmash","tmode","delay","mt","cmode","KeyBinds","restart","msg","chatKey","ltime"]
global space := Chr(3)
saveSettings() {
    global vars, space
    try {
        FileDelete("files\settings")
    }
    loop vars.Length {
        switch Type(%vars[A_Index]%) {
            case "Array":
                i := A_Index
                l := %vars[A_Index]%.Length
                loop l {
                    FileAppend(%vars[i]%[A_Index] (A_Index<l? space:""),"files\settings")
                }
                FileAppend("`n","files\settings")
            default: 
                FileAppend(%vars[A_Index]% "`n","files\settings")
        }
    }
}

setGlobal(var,value) {
    global
    %var% := value
}

loadSettings() {
    global vars, space, KeyBinds, keybindsm, keymap
    loop read "files\settings" {
        switch Type(%vars[A_Index]%) {
            case "Array":
                arr := StrSplit(A_LoopReadLine,space)
                setGlobal(vars[A_Index],arr)
            default: 
                setGlobal(vars[A_Index],A_LoopReadLine)
        }
    }
    global keysd := "{space down}", keysu := "{space up}"
    loop StrLen(keys) {
        index := SubStr(keys,A_Index,1)
        keysd .= "{" index " down}"
        keysu .= "{" index " up}"
    }
    global x := [A_ScreenWidth/2+A_ScreenWidth*per,A_ScreenWidth/2-A_ScreenWidth*per] ;x array does not get saved in case A_ScreenWidth changes
    loop KeyBinds.Length {
        keymap[KeyBinds[A_Index]] := true
        try { ;yeah the user will prob change the keybind if they notice its not working
            Hotkey(KeyBinds[A_Index],keybindsm[A_Index],"On")
        }
    }
}
global allowedf := Map("settings",true,"FARTlog.ahk",true,"FART ARMY MACRO.ahk",true,"info",true)
allowedf.Default := false

checkEnviroment() {
    checkReader()
    if(FileExist("README.md")) {
        FileDelete("README.md")
    }
    if(A_ScriptName != "FART ARMY MACRO.ahk") {
        MsgBox("THIS FILE MUST BE NAMED FART ARMY MACRO",title)
        ExitApp()
    }
    loop Files A_ScriptDir "\*", "R" {
        if(A_Index > 4 || !allowedf[A_LoopFileName]) {
            MsgBox("THIS MACRO MUST BE PUT IN AN EMPTY NEW FOLDER!",title)
            ExitApp()
        }
    }
    if(!FileExist("files\FARTlog.ahk")) {
        MsgBox("YOU ARE MISSING FILES THAT ARE REQUIRED FOR THIS MACRO TO WORK!",title)
        ExitApp()
    }
}
checkEnviroment()

global ComSpec := EnvGet("ComSpec")
executeCommand(command) {
    global ComSpec
    RunWait(ComSpec . ' /C ' . command, , "Hide")
}

global version := "", ltime := 18

blockInternetAccess(filePath := version "RobloxPlayerBeta.exe") {
    if(filePath != "") {
        executeCommand('netsh advfirewall firewall add rule name="BlockApp" dir=out action=block program=' . filePath . ' enable=yes >NUL')
    }
}

unblockInternetAccess(filePath := version "RobloxPlayerBeta.exe") {
    if(filePath != "") {
        executeCommand('netsh advfirewall firewall delete rule name="BlockApp" program=' . filePath . ' >NUL')
    }
    ToolTip(,,,4)
}

exits(a,b) {
    global version
    getCurrent(false)
    try {
        unblockInternetAccess()
    }
}

OnExit(exits)

global xx := A_ScreenWidth*0.1, yy := A_ScreenHeight*0.1

lagSwitch(ThisHotKey) {
    global title, version, ltime, xx, yy
    key := getkey(A_ThisHotkey)
    if(A_IsAdmin) {
        altkey := InStr(A_ThisHotkey,"*!")=1
        getCurrent(false)
        if(version != "") {
            blockInternetAccess()
            time := A_Now
            SetTimer(unblockInternetAccess,ltime*1000+100)
            passed := 0
            left := 0
            while(passed < ltime && !(!altkey&&GetKeyState(key,"P")||(altkey&&GetKeyState(key,"P")&&GetKeyState("Alt","P")))) {
                passed := DateDiff(A_Now,time,"S")
                if(left != ltime-passed && ltime-passed >= 0) {
                    left := ltime-passed
                    ToolTip("LAG SWITCH!`nHOLD " StrUpper(altkey? "ALT " key:key) " TO STOP`n" ltime-passed,xx,yy,4)
                }
                Sleep 50
            }
            SetTimer(unblockInternetAccess,0)
            unblockInternetAccess()
            while(GetKeyState(key,"P")) {
                Sleep 10
            }
        } else {
            MsgBox("YOU MUST START ROBLOX FIRST TO LAG SWITCH!",title)
        }
    } else {
        MsgBox("YOU MUST RUN THIS SCRIPT AS AN ADMIN FOR LAG SWITCH TO WORK!",title)
    }
    blocked := 0
}

clagSwitch() {
    global ltime
    try {
        ltime := Abs(Integer(InputBox2("max lag switch time in seconds",ltime)))
    } catch {
        MsgBox("you were supposed to type a number",title)
    }
}

SuspendedPID := Map()
SuspendedPID.Default := false
freeze(bool:=false,toggle:=false,key:="") {
    PID := WinGetPID("A")
    h := DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", PID)
    safe := !WinActive("FART ARMY MACRO")
    if(safe&&h) {
        if((bool&&!SuspendedPID[PID])||(toggle&&!SuspendedPID[PID])) {
            if(toggle) {
                ToolTip("FREEZE TOGGLE!`n`nPRESS " key " TO UNFREEZE!",0,0,2)
            }
            DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
            SuspendedPID[PID] := true
        } else if((toggle&&SuspendedPID[PID])||(!bool&&SuspendedPID[PID])) {
            if(toggle) {
                ToolTip(,,,2)
            }
            DllCall("ntdll.dll\NtResumeProcess", "Int", h)
            SuspendedPID[PID] := false
        }
    }
}

getkey(key) {
    return InStr(key,"*!")=1? SubStr(key,3,1):SubStr(key,2)
}

freezetoggle(ThisHotkey) {
    freeze(,true,translatekeybind(A_ThisHotkey))
}

global smashKeys := "1", smashTimes := 1700, leap := 100

keySmasher(ThisHotKey) {
    global smashKeys, smashTimes, leap
    completed := 0
    freeze(true)
    kstr := multiStr(smashKeys,leap)
    kstr2 := multiStr(smashKeys,smashTimes-Floor(smashTimes/leap)*leap)
    while((completed<smashTimes||A_Index=1)&&A_Index<smashTimes) {
        if(completed+leap>smashTimes) {
            completed += smashTimes-completed
            SendEvent("{RAW}" kstr2)
        } else {
            completed += leap
            SendEvent("{RAW}" kstr)
        }
    }
    freeze(false)
}

ckeySmasher() {
    global smashKeys := InputBox2("what keys will you smash",smashKeys), title
    try {
        global smashTimes := Abs(Integer(InputBox2("how many times will you smash these keys?",smashTimes)))
        smashTimes := smashTimes + (smashTimes=0)
    } catch {
        MsgBox("you were supposed to type a number",title)
    }
}

global per := 0.15, keys := "wa", keysd := "{space down}{w down}{a down}", keysu := "{space up}{w up}{a up}", x := [A_ScreenWidth/2+A_ScreenWidth*per,A_ScreenWidth/2-A_ScreenWidth*per], y := A_ScreenHeight/2

speedm(ThisHotkey) { ;speed
    global per, keysd, keysu, x, y
    key := getkey(A_ThisHotkey)
    SendEvent(keysd)
    while GetKeyState(key,"P")||A_Index=1 {
        loop 2 {
            MouseMove(x[A_Index],y)
            Sleep 1
        }
    }
    SendEvent(keysu)
}

speed() { ;customize speed
    global keys := StrLower(InputBox2("what wasd keys will the speed macro hold down?", keys))
    global keysd := "{space down}"
    global keysu := "{space up}"
    global title
    dupecheck := Map()
    dupecheck.Default := false
    str := ""
    loop StrLen(keys) {
        index := SubStr(keys,A_Index,1)
        if((index="w"||index="a"||index="s"||index="d")&&!dupecheck[index]) {
            keysd .= "{" index " down}"
            keysu .= "{" index " up}"
            str .= index
        }
        dupecheck[index] := true
    }
    global keys := str
    try {
        global per := Integer(InputBox2("how much percentage of your screenwidth will the cursor move away from the center of the screen?",Round(per*100)))/100
        per := Abs(per)+(per=0)*0.15
        global x := [A_ScreenWidth/2+A_ScreenWidth*per,A_ScreenWidth/2-A_ScreenWidth*per]
    } catch {
        MsgBox("you were supposed to type a number",title)
    }
}

global tmin := 1, tmax := 10, tmode := true, tmash := "qe", tindex := -1, delay := 25 ;tmode false = semi auto, tmode true = full auto

toolbarm(ThisHotKey) { ;use toolbar
    global tmin, tmax, tmode, tmash, tindex := (tindex=-1)? tmin:tindex
    key := getkey(A_ThisHotkey)
    while((tmode&&GetKeyState(key,"P"))||A_Index=1) {
        SendEvent("{" (tindex>=10? 0:tindex) "}{LButton}{Raw}" tmash)
        tindex := tmin+Mod(tindex,tmax-tmin+1)
        Sleep delay*tmode-!tmode
    }
    while(GetKeyState(key,"P")&&!tmode) {
        Sleep 10
    }
}

toolbar() { ;customize use toolbar
    global tindex := -1, title
    global tmode := (MsgBox("CURRENT MODE: " (tmode? "FULL AUTO":"SEMI AUTO") "`n`npress yes to keep current mode`n`npress no to change to " (!tmode? "FULL AUTO":"SEMI AUTO"),title,"YesNo")="Yes")? tmode:!tmode
    global tmash := StrLower(InputBox2("what keys will be pressed every gear swap?",tmash))
    try {
        global tmin := Abs(Integer(InputBox2("where in the toolbar will this macro start?",tmin)))
        tmin := (tmin=0||tmin>=10)? 1:tmin
        global tmax := Abs(Integer(InputBox2("where in the toolbar will this macro end?`n`n10 here means that it ends at 0",tmax)))
        tmax := (tmax=0||tmax>=10)? 10:tmax
        global delay := Integer(InputBox2(tmode? "milisecond delay between every gear swap?":"",delay))
        delay := Abs(delay)+(delay=0)*25
    } catch {
        MsgBox("you were supposed to type a number",title)
    }
    if(tmin > tmax) {
        t := tmax
        tmax := tmin
        tmin := t
    }
}

f(CPS,limit := 50) { ;sleep is limitied in ahk, thus a multiplier has to be used to achieve higher CPS
    CPS := (CPS=0)+Abs(CPS)
    return [Ceil(CPS/limit),(Ceil(CPS/limit)*1000)/CPS] ;https://www.desmos.com/calculator/aefmbh27s4 made by me
}

global mt := f(100), cmode := true ;mode true = hold, false = toggle

autoclick(ThisHotKey) { ;autoclicker
    global mt, cmode
    key := getkey(A_ThisHotkey)
    while(!cmode&&GetKeyState(key,"P")) {
        Sleep 10
    }
    altkey := InStr(A_ThisHotkey,"*!")=1
    ToolTip("AUTOCLICKER ON" (!cmode?"`n`nHOLD " StrUpper(altkey? "ALT " key:key) " TO TURN OFF AUTOCLICKER":""),A_ScreenWidth*0.1,A_ScreenHeight*0.1,3)
    while((cmode&&GetKeyState(key,"P"))||(!cmode&&!((altkey&&GetKeyState(key,"P")&&GetKeyState('Alt',"P"))||(GetKeyState(key,"P")&&!altkey)))) {
        loop mt[1] {
            Click
        }
        Sleep mt[2]
    }
    ToolTip(,,,3)
    while(!cmode&&GetKeyState(key,"P")) {
        Sleep 10
    }
}

autoc() { ;customize autoclicker
    global mt, cmode, title
    try {
        mt := f(Round(InputBox2("CPS`n`nclicks per second",Round(mt[1]*(1000/mt[2])))))
        cmode := MsgBox("current autoclicker mode: " (cmode?"HOLD":"TOGGLE") "`n`npress yes to keep current autoclicker mode`n`npress no to change to " (!cmode?"HOLD":"TOGGLE"),title,"YesNo")="Yes"? cmode:!cmode
    }
}

global msg := "LPI fart army macro made by DodaInteMigDummaBajs"
global chatKey := "/"
autochat(ThisHotKey) {
    BlockInput(1)
    oclip := A_Clipboard
    A_Clipboard := msg
    SendEvent("{RAW}" chatKey)
    Sleep 25
    SendEvent("^v")
    Sleep 25
    SendEvent("{Enter}")
    Sleep 25
    A_Clipboard := oclip
    BlockInput(0)
}

cautochat() {
    global msg := InputBox2("what will this macro auto chat?",msg)
    global chatKey := InputBox2("what key do you press to chat?",chatKey)
}

global user := "", version := "", placeID := "", jobID := "", sList := [], whr := ComObject("WinHttp.WinHttpRequest.5.1")

getServers(place,exclude) {
    global title, whr
    try {
        whr.Open("GET", "https://games.roblox.com/v1/games/" place "/servers/0?excludeFullGames=true&limit=50", False), whr.Send()
        arr := StrSplit(whr.ResponseText,'"')
        Sarr := []
        loop arr.Length {
            if(arr[A_Index] = "id" && InStr(arr[A_Index+2],"-")>0 && arr[A_Index+2] != exclude) {
                Sarr.Push(arr[A_Index+2])
            }
        }
        return Sarr
    } catch as err {
        if(MsgBox("no servers were found`npress ok to see the error message and response",title)="OK") {
            try {
                MsgBox(err.Message,title)
                MsgBox(whr.ResponseText,title)
            }
        }
    }
    try {
        whr.Close() ;I think have to do this, am not so sure
    }
}

global closeAction := ["l","{Enter}","{Escape}","l","{Enter}"]
global robloxes := ["Roblox Game Client","Roblox","RobloxPlayerBeta.exe","RobloxPlayerInstaller.exe","RobloxPlayerInstaller.exe (32 bit)","Roblox (32 bit)","RobloxPlayerInstaller.exe (64 bit)","Roblox (64 bit)"] ;yep

closeRoblox() {
    global closeAction, robloxes
    while(WinExist("Pick an app")&&A_Index<20) {
        WinClose("Pick an app")
        Sleep 25
    }
    if(WinExist("Roblox")) {
        BlockInput(1)
        WinActivate("Roblox")
        Sleep 25
        loop 2 {
            loop closeAction.Length {
                SendEvent(closeAction[A_Index])
                Sleep 25
            }
        }
        closed := false
        while(!closed&&A_Index<20) {
            closed := true
            try {
                if(ProcessExist(WinGetPID("Roblox"))) {
                    closed := false
                }
                ProcessClose(WinGetPID("Roblox"))
            }
            loop robloxes.Length {
                try {
                    if(ProcessExist(robloxes[A_Index])) {
                        closed := false
                    }
                    ProcessClose(robloxes[A_Index])
                }
            }
            Sleep 25
        }
        BlockInput(0)
    }
}

getCurrent(update := true) {
    global placeID, jobID, sList, title, version, user
    done := false
    while(!done&&A_Index<20) {
        done := true
        try {
            arr := StrSplit(FileRead("files\info"),Chr(10))
            if(update&&(arr[2]!=placeID||arr[3]!=jobID)) {
                placeID := arr[2]=""? placeID:arr[2]
                jobID := arr[3]=""? jobID:arr[3]
                sList := getServers(placeID,jobID)
            }
            version := arr[1]
            user := StrSplit(version,"\")[3]
        } catch as err {
            Sleep 50
            done := false
        }
    }
}

joinLink(place,job) {
    return "roblox://experiences/start?placeId=" place "&gameInstanceId=" job
}

serverHop() {
    global placeID, jobID, sList, title, user
    getCurrent()
    if(version!=""&&user!=A_UserName) {
        MsgBox("YOU ARE USING THIS MACRO AS " A_UserName "`nBUT YOU ARE USING ROBLOX AS " user "`n`nYOU MUST USE THIS MACRO AND ROBLOX ON THE SAME USER FOR SERVERHOP/REJOIN TO WORK!",title)
        return
    }
    if(placeID!=""&&jobID!=""&&sList!=[]) {
        closeRoblox()
        Run joinLink(placeID,sList[sList.Length])
        jobID := sList[sList.Length]
        sList.Pop()
        if(sList.Length = 0) {
            sList := getServers(placeID,jobID)
        } 
    } else {
        MsgBox("YOU MUST JOIN A GAME FIRST FOR THIS TO WORK!",title)
    }
}

rejoin() {
    global placeID, jobID, title
    getCurrent()
    if(version!=""&&user!=A_UserName) {
        MsgBox("YOU ARE USING THIS MACRO AS " A_UserName "`nBUT YOU ARE USING ROBLOX AS " user "`n`nYOU MUST USE THIS MACRO AND ROBLOX ON THE SAME USER FOR SERVERHOP/REJOIN TO WORK!",title)
        return
    }
    if(placeID!=""&&jobID!="") {
        closeRoblox()
        Run joinLink(placeID,jobID)
    } else {
        MsgBox("YOU MUST JOIN A GAME FIRST FOR THIS TO WORK!",title)
    }
}

global cfunc := [toolbar,speed,autoc,ckeySmasher,cautochat,clagSwitch,CustomizeKeybinds,rejoin,serverHop]

customizeMenu() {
    choose := "."
    global cfunc, title
    while(choose!="") {
        checkReader()
        choose := InputBox("TYPE THE NUMBER TO CHOOSE CUSTOMIZATION:`n1. customize toolbar macro`n2. customize speed macro`n3. customize autoclicker`n4. customize key smasher macro`n5. customize auto chat message`n6. customize lag switch`n`n7. customize keybinds`n`n`nTYPE THE NUMBER TO CHOOSE ACTION:`n8. rejoin`n9. serverhop`n`n`npress cancel to go back",title,'H' A_ScreenHeight/3).Value
        try {
            cfunc[choose]()
        }
        saveSettings()
    }
    return true
}

translatekeybind(input) { ;making keybinds readable
    return StrUpper(StrReplace(SubStr(input,2),"!","ALT "))
}

CreateKeybind(original) {
    done := 0
    stored := A_PriorKey
    keybind := ""
    AltKeyBind := false
    ToolTip(translatekeybind(original) "`n`nNEW KEYBIND: ",A_ScreenWidth/2,A_ScreenHeight/2)
    while(GetKeyState(stored,"P")) {
        Sleep 10
    }
    while(done<3) { ;<3
        if(A_PriorKey != stored && A_PriorKey != "Enter") {
            done := 0
            stored := A_PriorKey
            if(stored = "LAlt" || stored = "RAlt") {
                keybind := "!"
            } else if(keybind = "!" && StrLen(stored)=1&&(Ord(stored)>=97&&Ord(stored)<=122)) {
                keybind .= stored
                AltKeyBind := true
            } else {
                AltKeyBind := false
                keybind := stored
            }
            ToolTip(translatekeybind(original) "`n`nNEW KEYBIND: " StrUpper((InStr(keybind,"!")=1?StrReplace(keybind,"!","ALT " (StrLen(keybind)=1?"(LETTER KEY FOR ALT KEYBIND)":"")):keybind)) "`n`npress enter 3 times when you are done`nallowed keybinds are any single key or alt + any letter key`nduplicate keybinds are not allowed" (done>0?done "/3":""),A_ScreenWidth/2,A_ScreenHeight/2)
        } else if(GetKeyState("Enter","P")&&keybind!="!"&&keybind!="") {
            done++
            ToolTip(translatekeybind(original) "`n`nKEYBIND: " StrUpper((InStr(keybind,"!")=1?StrReplace(keybind,"!","ALT "):keybind)) "`n`npress enter 3 times when you are done`nallowed keybinds are any single key or alt + any letter key`nduplicate keybinds are not allowed" (done>0?"`n`n" done "/3":""),A_ScreenWidth/2,A_ScreenHeight/2)
            while GetKeyState("Enter","P") {
                Sleep 10
            }
        }
        Sleep 10
    }
    ToolTip()
    return "*" keybind
}

global KeyBinds := [
    "*!z", ;toolbar
    "*!x", ;speed
    "*!c", ;autoclicker
    "*!v", ;key smasher
    "*!f", ;freeze toggle
    "*!q", ;auto chat
    "*!l" ;lag switch
]

global keybindsm := [ ;match
    toolbarm,
    speedm,
    autoclick,
    keySmasher,
    freezetoggle,
    autochat,
    lagSwitch
]

global keymap := Map() ;map for checking if duplicate keybinds
keymap.Default := false

CustomizeKeybinds() {
    global KeyBinds, keybindsm, keymap, title
    while(true) {
        try {
            opt := Integer(InputBox("CHOOSE WHAT MACRO KEYBIND TO CUSTOMIZE!`n`n1. toolbar macro: " translatekeybind(KeyBinds[1]) "`n2. speed macro: " translatekeybind(KeyBinds[2]) "`n3. autoclicker: " translatekeybind(KeyBinds[3]) "`n4. key smasher: " translatekeybind(KeyBinds[4]) "`n5. freeze toggle: " translatekeybind(KeyBinds[5]) "`n6. auto chat: " translatekeybind(KeyBinds[6]) "`n7. lag switch: " translatekeybind(KeyBinds[7]) "`n`nPRESS CANCEL WHEN YOU ARE DONE!",title,"H" A_ScreenHeight/3).Value)
            keybind := CreateKeybind(KeyBinds[opt])
            if(keymap[keybind]&&keybind!=KeyBinds[opt]) {
                MsgBox("DUPLICATE KEYBIND!`n`nTRY SOMETHING ELSE!",title)
            } else {
                keymap[KeyBinds[opt]] := false
                KeyBinds[opt] := keybind
                keymap[keybind] := true
            }
        } catch {
            global restart := true
            saveSettings()
            Reload()
            Sleep 1000
        }
    }
}

global restart := false
if(!FileExist("files\settings") || FileRead("files\settings")="") {
    saveSettings()
}
loadSettings()

if(!restart) {
    MsgBox("THIS MACRO IS MADE FOR THESE ROBLOX SETTINGS:`n`ncamera sensitivity: 1`nFPS: 60`n`nIF YOU DONT USE THESE SETTINGS THEN THIS MACRO WONT WORK AS EXPECTED!",title)
} else {
    restart := false
    saveSettings()
}
while(MsgBox("YOU CAN PRESS SOMEWHERE ELSE TO HIDE THIS!`n`n`nuse toolbar macro: " translatekeybind(KeyBinds[1]) "`nSTART: " tmin ", END: " tmax ", KEYS: `"" tmash "`", MODE: " (tmode? "FULL AUTO, DELAY: " delay "ms":"SEMI AUTO") "`n`nspeed macro: " translatekeybind(KeyBinds[2]) "`nWASD: `"" keys "`", PERCENTAGE: " Round(per*100) "%`n`nautoclicker: " translatekeybind(KeyBinds[3]) "`nCPS: " Round(mt[1]*(1000/mt[2])) ", MODE: " (cmode? "HOLD":"TOGGLE") "`n`nkey smasher macro: " translatekeybind(KeyBinds[4]) "`nKEYS: `"" smashKeys "`", TIMES: " smashTimes "`n`nfreeze toggle: " translatekeybind(KeyBinds[5]) "`n`nauto chat: " translatekeybind(KeyBinds[6]) "`nMESSAGE: `"" msg "`", CHATKEY: `"" chatKey "`"`n`nlag switch: " translatekeybind(KeyBinds[7]) "`nMAX TIME: " ltime " seconds`n`n`npress OK to customize the macros or for more tools`npress cancel to exit this macro",title,"OKCancel")="OK"? customizeMenu():(ExitApp())) {
    checkEnviroment()
}
