#Requires AutoHotkey v2.0.18+
#SingleInstance Force
ProcessSetPriority "High"
SetKeyDelay(-1)
SetMouseDelay(-1)
CoordMode("ToolTip","Screen")
SendLevel(1)

global title := "FART ARMY MACRO"

InputBox2(prompt,default) {
    return prompt=""? default:InputBox(prompt,title,,default).Value
}

global vars := ["multi7","swordnkey","per","keys","tmin","tmax","tmash","tmode","delay","mt","cmode","KeyBinds","restart","msg","chatKey"]
global space := Chr(3)
saveSettings() {
    global vars, space
    try {
        FileDelete("settings")
    }
    loop vars.Length {
        switch Type(%vars[A_Index]%) {
            case "Array":
                i := A_Index
                l := %vars[A_Index]%.Length
                loop l {
                    FileAppend(%vars[i]%[A_Index] (A_Index<l? space:""),"settings")
                }
                FileAppend("`n","settings")
            default: 
                FileAppend(%vars[A_Index]% "`n","settings")
        }
    }
}

setGlobal(var,value) {
    global
    %var% := value
}

loadSettings() {
    global vars, space, KeyBinds, keybindsm, keymap
    loop read "settings" {
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
global allowedf := Map()
allowedf.Default := false
allowedf["settings"] := true
allowedf["FART ARMY MACRO.ahk"] := true

checkEnviroment() {
    if(A_ScriptName != "FART ARMY MACRO.ahk") {
        MsgBox("THIS FILE MUST BE NAMED FART ARMY MACRO")
        ExitApp()
    }
    loop Files A_ScriptDir "\*" {
        if(A_Index > 2 || !allowedf[A_LoopFileName]) {
            MsgBox("THIS MACRO MUST BE PUT IN AN EMPTY NEW FOLDER!",title)
            ExitApp()
        }
    }
}
checkEnviroment()

SuspendedPID := Map()
SuspendedPID.Default := false
freeze(bool:=false,toggle:=true,key:="") {
    PID := WinGetPID("A")
    h := DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", PID)&&!WinActive("FART ARMY MACRO")
    if(((bool&&!SuspendedPID[PID])||(toggle&&!SuspendedPID[PID]))&&h) {
        if(toggle) {
            ToolTip("FREEZE TOGGLE!`n`nPRESS " key " TO UNFREEZE!",0,0,2)
        }
        DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
        SuspendedPID[PID] := true
    } else if(h&&((toggle&&SuspendedPID[PID])||(!bool&&SuspendedPID[PID]))) {
        if(toggle) {
            ToolTip(,,,2)
        }
        DllCall("ntdll.dll\NtResumeProcess", "Int", h)
        SuspendedPID[PID] := false
    }
}

getkey(key) {
    return InStr(key,"*!")=1? SubStr(key,3,1):SubStr(key,2)
}

freezetoggle(ThisHotkey) {
    freeze(,,translatekeybind(A_ThisHotkey))
}

global multi7 := 4, swordnkey := ["2","3"] ;key is second index

dance7jump(ThisHotKey) { ;dance7 jump multiplier
    global multi7, swordnkey, x, y
    key := getkey(A_ThisHotkey)
    MouseMove(x[2],y) ;to calibrate speed macro so the user will face the right direction if they use speed macro right afterwards
    while GetKeyState(key,"P")||A_Index<=multi7 { ;so the user can press once for set amount of multiplication or hold for more
        freeze(true,false) ;makes it less likely for the player to teleport
        SendEvent(swordnkey[1] swordnkey[2])
        freeze(false,false)
        Sleep 50
    }
    Sleep 50
    SendEvent(swordnkey[1])
}

dance7() { ;customize dance7 jump multiplier
    global swordnkey
    try {
        swordnkey[2] := Integer(InputBox2("where is key in your toolbar?",swordnkey[2]))
        swordnkey[2] := Abs(swordnkey[2])+(swordnkey[2]=0)
        swordnkey[1] := Integer(InputBox2("what gear in your toolbar will the dance7 jump macro swap to?",swordnkey[1]))
        swordnkey[1] := Abs(swordnkey[1])+(swordnkey[1]=0)
        global multi7 := Integer(InputBox2("dance7 jump minimum multiplier",multi7))
        multi7 := Abs(multi7)+(multi7=0)
    } catch {
        MsgBox("you were supposed to type a number")
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
        MsgBox("you were supposed to type a number")
    }
}

global tmin := 5, tmax := 10, tmode := true, tmash := "qe", tindex := -1, delay := 25 ;tmode false = semi auto, tmode true = full auto

toolbarm(ThisHotKey) { ;use toolbar
    global tmin, tmax, tmode, tmash, tindex := tmin*(tindex=-1)+tindex*(tindex!=-1)
    key := getkey(A_ThisHotkey)
    while((tmode&&GetKeyState(key,"P"))||A_Index=1) {
        SendEvent("{" tindex "}{LButton}{Raw}" tmash)
        tindex := (tindex+1)*(tindex<tmax&&tindex<9&&tindex>=tmin)+tmin*(tindex>=tmax||tindex<tmin)
        Sleep delay*tmode-!tmode
    }
    while(GetKeyState(key,"P")&&!tmode) {
        Sleep 10
    }
}

toolbar() { ;customize use toolbar
    global tindex := -1
    global tmode := (MsgBox("CURRENT MODE: " (tmode? "FULL AUTO":"SEMI AUTO") "`n`npress yes to keep current mode`n`npress no to change to " (!tmode? "FULL AUTO":"SEMI AUTO"),,"YesNo")="Yes")? tmode:!tmode
    global tmash := StrLower(InputBox2("what keys will be pressed every gear swap?",tmash))
    try {
        global tmin := Integer(InputBox2("where in the toolbar will this macro start?",tmin))
        tmin := Abs(tmin)
        global tmax := Integer(InputBox2("where in the toolbar will this macro end?" ((tmax=10)? "`n`n10 here means that it ends at 0":""),tmax))
        tmax := Abs(tmax)+(tmax=0)*9
        global delay := Integer(InputBox2(tmode? "milisecond delay between every gear swap?":"",delay))
        delay := Abs(delay)+(delay=0)*25
    } catch {
        MsgBox("you were supposed to type a number")
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

global mt := f(50), cmode := true ;mode true = hold, false = toggle

autoclick(ThisHotKey) { ;autoclicker
    global mt, cmode
    key := getkey(A_ThisHotkey)
    while(!cmode&&GetKeyState(key,"P")) {
        Sleep 10
    }
    altkey := InStr(A_ThisHotkey,"*!")=1
    ToolTip("AUTOCLICKER ON" (!cmode?"`n`nHOLD " StrUpper(altkey? "ALT " key:key) " TO TURN OFF AUTOCLICKER":""),A_ScreenWidth*0.1,A_ScreenHeight*0.1)
    while((cmode&&GetKeyState(key,"P"))||(!cmode&&!((altkey&&GetKeyState(key,"P")&&GetKeyState('Alt',"P"))||(GetKeyState(key,"P"))))) {
        loop mt[1] {
            Click
        }
        Sleep mt[2]
    }
    ToolTip()
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

global msg := "/e dance7"
global chatKey := "/"
autochat(ThisHotKey) {
    oclip := A_Clipboard
    A_Clipboard := msg
    SendEvent("{RAW}" chatKey)
    Sleep 20
    SendEvent("^v")
    Sleep 20
    SendEvent("{Enter}")
    Sleep 20
    A_Clipboard := oclip
}

cautochat() {
    global msg := InputBox2("what will this macro auto chat?",msg)
    global chatKey := InputBox2("what key do you press to chat?",chatKey)
}

global cfunc := [toolbar,speed,autoc,dance7,cautochat,CustomizeKeybinds]

customizeMenu() {
    choose := "."
    global cfunc, title
    while(choose!="") {
        choose := InputBox("TYPE THE NUMBER TO CHOOSE`n`n1. customize toolbar macro`n2. customize speed macro`n3. customize autoclicker`n4. customize dance7 jump multiplier macro`n5. customize auto chat message`n6. customize keybinds`n`npress cancel when you are done",title,'H' A_ScreenHeight/3).Value
        try {
            cfunc[choose]()
        }
    }
    saveSettings()
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
    "*!v", ;dance7 jump
    "*!f", ;freeze toggle
    "*!q" ;auto chat
]

global keybindsm := [ ;match
    toolbarm,
    speedm,
    autoclick,
    dance7jump,
    freezetoggle,
    autochat
]

global keymap := Map() ;map for checking if duplicate keybinds
keymap.Default := false

CustomizeKeybinds() {
    global KeyBinds, keybindsm, keymap, title
    while(true) {
        try {
            opt := Integer(InputBox("CHOOSE WHAT MACRO KEYBIND TO CUSTOMIZE!`n`n1. toolbar macro: " translatekeybind(KeyBinds[1]) "`n2. speed macro: " translatekeybind(KeyBinds[2]) "`n3. autoclicker: " translatekeybind(KeyBinds[3]) "`n4. dance7 jump: " translatekeybind(KeyBinds[4]) "`n5. freeze toggle: " translatekeybind(KeyBinds[5]) "`n6. auto chat: " translatekeybind(KeyBinds[6]) "`n`nPRESS CANCEL WHEN YOU ARE DONE!",title,"H" A_ScreenHeight/3).Value)
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
if(!FileExist("settings") || FileRead("settings")="") {
    saveSettings()
}
loadSettings()

if(!restart) {
    MsgBox("THIS MACRO IS MADE FOR THESE ROBLOX SETTINGS:`n`ncamera sensitivity: 1`nFPS: 60`n`nIF YOU DONT USE THESE SETTINGS THEN THIS MACRO WONT WORK AS EXPECTED!",title)
} else {
    restart := false
    saveSettings()
}
while(MsgBox("YOU CAN PRESS SOMEWHERE ELSE TO HIDE THIS!`n`nuse toolbar macro: " translatekeybind(KeyBinds[1]) "`nspeed macro: " translatekeybind(KeyBinds[2]) "`nautoclicker: " translatekeybind(KeyBinds[3]) "`ndance7 jump macro: " translatekeybind(KeyBinds[4]) "`nfreeze toggle: " translatekeybind(KeyBinds[5]) "`nauto chat: " translatekeybind(KeyBinds[6]) "`n`npress OK to customize the macros`npress cancel to exit this macro",title,"OKCancel")="OK"? customizeMenu():ExitApp()) {
    checkEnviroment()
}
