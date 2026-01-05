#Requires AutoHotkey v2.0.18+
#SingleInstance Force
ProcessSetPriority("R")
SetKeyDelay(-1)
SetMouseDelay(-1)
CoordMode("ToolTip","Screen")
CoordMode("Mouse","Screen")
SetTitleMatchMode(3)
SendLevel(1)
SetDefaultMouseSpeed(0)
SendMode("Event")

multiStr(str,multi) {
    return StrReplace(Format("{:0" multi "}",0),0,str)
}

ahkExist(ahkFile) {
    prevDetectHiddenWindows := A_DetectHiddenWindows, prevTitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows(true), SetTitleMatchMode(3)
    exists := WinExist(ahkFile " ahk_class AutoHotkey")
    DetectHiddenWindows(prevDetectHiddenWindows), SetTitleMatchMode(prevTitleMatchMode)
    return exists
}

waitForKey(specifyKey:="{All}") {
    h := InputHook()
    h.KeyOpt(specifyKey, "E")
    h.Start()
    h.Wait()
    return h.EndKey
}

isKeybindHeld(keybind) {
    loop parse keybind,,"*" {
        if !(GetKeyState(A_LoopField=="^"?"Control":A_LoopField=="!"?"Alt":A_LoopField,"P")) {
            return false
        }
    }
    return true
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

InputBox2(prompt,default,numberInput,height := A_ScreenHeight/4.5) {
    global title
    if(prompt="") {
        return default
    }
    if(numberInput) {
        val := InputBox(prompt,title,"H" height " W" A_ScreenWidth/4,default).Value
        while(!IsNumber(val)) {
            MsgBox("you are supposed to type a number",title)
            val := InputBox(prompt,title,"H" height " W" A_ScreenWidth/4,default).Value
        }
        return val
    }
    return InputBox(prompt,title,"H" height " W" A_ScreenWidth/4,default).Value
}

InputBox3(ErrorLevel,prompt,default,number,cancelReturn:=false,height := A_ScreenHeight/4.5) { ;used for multistep setups that can be cancelled anywhere along the way
    global title
    val := InputBox(prompt,title,"H" height " W" A_ScreenWidth/4,default)
    while(!IsNumber(val.Value)&&number&&val.Result="OK") {
        if(MsgBox("you are supposed to type a number",title,"OKCancel")="Cancel") {
            %ErrorLevel% := false
            return Number&&!IsNumber(default)?0:default
        }
        val := InputBox(prompt,title,"H" height " W" A_ScreenWidth/4,default)
    }
    %ErrorLevel% := val.Result="OK"
    return Number&&!IsNumber(val.Value)?0:val.Value
}

MultiLineInputBox(text,default,errorLevel:="",multiStepCancel:=false) {
    global title
    MyGui := Gui(,title)
    MyGui.SetFont("s10","Segoe UI")
    MyGui.AddText(,text)
    MyGui.AddEdit("r30 w1000 vValue HScroll",default)
    MyGui.AddButton("","OK").OnEvent("Click",done)
    MyGui.AddButton("yp","CANCEL").OnEvent("Click",cancel)
    MyGui.Show()
    complete := false
    newVal := false
    val := Object()
    done(*) {
        val := MyGui.Submit()
        complete := true
        newVal := true
    }
    cancel(*) {
        MyGui.Destroy()
        complete := true
        newVal := false
    }
    while(!complete) {
        Sleep 50
    }
    if(multiStepCancel) {
        %errorLevel% := newVal        
    }
    return newVal?val.Value:default
}

SleepEx(Milliseconds,boolPointer := &internalBool) {
    static tps := _tps(), start := 0, current := 0, internalBool := true
    DllCall("QueryPerformanceCounter", "Int64*", &start)
    end := start + (Milliseconds * tps)
    while(current < end && %boolPointer%) { ;pointer is used so sleep can be stopped in fart army script if u press CTRL+ALT+E
        DllCall("QueryPerformanceCounter", "Int64*", &current)
    }
    _tps() {
        freq := 0
        DllCall("QueryPerformanceFrequency", "Int64*", &freq)
        return freq //= 1000
    }
}

;I have no idea how this works. But I managed to translate it to ahk v2
toGray(base,digits,value) { ;https://en.wikipedia.org/wiki/Gray_code#n-ary_Gray_code
    gray := []
    baseN := []
    loop digits {
        gray.Push(0)
        baseN.Push(Mod(value,base))
        value := Integer(value/base)
    }
    shift := 0
    i := digits
    while(i--) {
        gray[i+1] := Mod(baseN[i+1]+shift,base)
        shift := shift+base-gray[i+1]
    }
    return gray
}


skyboxSetup() { ;move tool xyz, mesh button, mesh file button, file mesh texture id, mesh file size xyz, mesh file offset xyz
    global title
    static tipOrigin := 13
    static resetTips(upTo) {
        loop upTo {
            ToolTip(,,,tipOrigin+A_Index)
        }
    }
    static isDone(arr) {
        loop arr.Length {
            if(!arr[A_Index]) {
                return false
            }
        }
        return true
    }
    setup := {
        z: [[0,0],[0,0],[0,0]], ;coordinates xyz
        mesh: [0,0], ;mesh button
        file: [0,0], ;file mesh
        texture: [0,0], ;texture id
        ms: [[0,0],[0,0],[0,0]], ;mesh size xyz
        mo: [[0,0],[0,0],[0,0]] ;mesh offset xyz
    }
    Pics := []
    Texts := [
        "STEP 1/4`n`nplace or select a part`nuse move tool in f3x`npress the number keys to place out the numbers as this image shows`n`npress 0 when you are done",
        "STEP 2/4`n`ngo to mesh in f3x`nhold your cursor over ADD MESH then press 1`n`npress 0 when you are done",
        "STEP 3/4`n`npress ADD MESH then select type`nhold your cursor over file then press 1`n`npress 0 when you are done",
        "STEP 4/4`n`npress file then use the number keys to place out the numbers`n`npress 0 when you are done"
    ]
    loop 4 {
        Pics.Push(LoadPicture(A_ScriptDir "\files\skyboxMacroSetup\stage" A_Index ".png"))
    }
    MyGui := Gui("+AlwaysOnTop +ToolWindow -SysMenu",title)
    MyGui.SetFont("s10")
    Text := MyGui.Add("text",,Texts[1])
    Pic := MyGui.Add("Pic", "w400 h-1 +Border", "HBITMAP:*" Pics[1])
    MyGui.Add("text",,"you can press E to cancel skybox setup")
    setupGuard := [[false,false,false],[false],[false],[false,false,false,false,false,false,false]] ;false false false falsefalselsfdlalsle
    stage := 0
    input := ""
    while stage<=4 {
        switch stage {
            case 0: ;setup for the setup
                if(MsgBox("YOU MUST EQUIP A NEW F3X WITH NO GUI MOVED!`n`nPRESS YES IF YOU CAN DO THE SETUP!`n`nTHIS SETUP WILL BLOCK YOUR KEY INPUT SO YOU MUST BE READY!",title,"YesNo")="Yes") {
                    stage++
                    MyGui.Show()
                    MyGui.Move(0)
                } else {
                    return false
                }
            case 1: ;move tool xyz
                input := waitForKey()
                MouseGetPos(&px,&py)
                switch input {
                    case "1": ;x
                        setup.z[1] := [px,py]
                        setupGuard[1][1] := true
                        ToolTip(1,px,py,tipOrigin+1)
                    case "2": ;y
                        setup.z[2] := [px,py]
                        setupGuard[1][2] := true
                        ToolTip(2,px,py,tipOrigin+2)
                    case "3": ;z
                        setup.z[3] := [px,py]
                        setupGuard[1][3] := true
                        ToolTip(3,px,py,tipOrigin+3)
                    case "0":
                        if(isDone(setupGuard[1])) {
                            stage++
                            Pic.Value := "HBITMAP:*" Pics[stage]
                            Text.Value := Texts[stage]
                            resetTips(3)
                        }
                }
            case 2: ;mesh button
                input := waitForKey()
                MouseGetPos(&px,&py)
                switch input {
                    case "1":
                        setup.mesh := [px,py]
                        setupGuard[2][1] := true
                        ToolTip(1,px,py,tipOrigin+1)
                    case "0":
                        if(isDone(setupGuard[2])) {
                            stage++
                            Pic.Value := "HBITMAP:*" Pics[stage]
                            Text.Value := Texts[stage]
                            resetTips(1)
                        }
                }
            case 3: ;mesh file button 
                input := waitForKey()
                MouseGetPos(&px,&py)
                switch input {
                    case "1":
                        setup.file := [px,py]
                        setupGuard[3][1] := true
                        ToolTip(1,px,py,tipOrigin+1)
                    case "0":
                        if(isDone(setupGuard[3])) {
                            stage++
                            Pic.Value := "HBITMAP:*" Pics[stage]
                            Text.Value := Texts[stage]
                            resetTips(1)
                        }
                }
            case 4: ;mesh size, offset, texture id
                input := waitForKey()
                MouseGetPos(&px,&py)
                switch input {
                    case "1": ;mesh size x
                        setup.ms[1] := [px,py]
                        setupGuard[4][1] := true
                        ToolTip(1,px,py,tipOrigin+1)
                    case "2": ;mesh size y
                        setup.ms[2] := [px,py]
                        setupGuard[4][2] := true
                        ToolTip(2,px,py,tipOrigin+2)
                    case "3": ;mesh size z
                        setup.ms[3] := [px,py]
                        setupGuard[4][3] := true
                        ToolTip(3,px,py,tipOrigin+3)
                    case "4": ;mesh offset x
                        setup.mo[1] := [px,py]
                        setupGuard[4][4] := true
                        ToolTip(4,px,py,tipOrigin+4)
                    case "5": ;mesh offset y
                        setup.mo[2] := [px,py]
                        setupGuard[4][5] := true
                        ToolTip(5,px,py,tipOrigin+5)
                    case "6": ;mesh offset z
                        setup.mo[3] := [px,py]
                        setupGuard[4][6] := true
                        ToolTip(6,px,py,tipOrigin+6)
                    case "7": ;mesh texture id
                        setup.texture := [px,py]
                        setupGuard[4][7] := true
                        ToolTip(7,px,py,tipOrigin+7)
                    case "0":
                        if(isDone(setupGuard[4])) {
                            stage++
                            resetTips(7)
                        }
                }
        }
        if(input="e") {
            MyGui.Destroy()
            return false
        }
    }
    MyGui.Destroy()
    return setup
}

global f3x := {
    z: [[0,0],[0,0],[0,0]], ;coordinates xyz
    mesh: [0,0], ;mesh button
    file: [0,0], ;file mesh
    texture: [0,0], ;texture id
    ms: [[0,0],[0,0],[0,0]], ;mesh size xyz
    mo: [[0,0],[0,0],[0,0]] ;mesh offset xyz
}

global fuckYouRoblox := 10 ;makes sure roblox has detected the cursor is moved to a screen coordinate
Fclick(x,y,n:=fuckYouRoblox) {
    global fuckYouRoblox
    loop n {
        MouseMove(x+(Random()>0.5?-1:1),y+(Random()>0.5?-1:1))
        MouseMove(x,y)
    }
    Click
}
Fmove(x,y,n:=fuckYouRoblox) {
    global fuckYouRoblox
    loop n {
        MouseMove(x+(Random()>0.5?-1:1),y+(Random()>0.5?-1:1))
        MouseMove(x,y)
    }
} 

f3xInput(input,what,key,ping:=100,buildSpeed:=50,reset:=false) {
    static xyz := {
        z: ["A","B","C"],
        x: ["A","B","C"],
        ms: ["A","B","C"],
        mo: ["A","B","C"]
    }
    static prevKey := "h"
    global f3x
    if(!reset) {
        needsPing := false
        loop 3 {
            if(xyz.%what%[A_Index]!=input[A_Index]) {
                Sleep needsPing? ping:-1
                if(key!=prevKey) {
                    prevKey := key
                    SendEvent(key)
                    Sleep buildSpeed
                }
                A_Clipboard := input[A_Index]
                xyz.%what%[A_Index] := input[A_Index]
                Fclick(f3x.%(what="x"?"z":what)%[A_Index]*)
                Sleep buildSpeed/2
                SendEvent("^v")
                Sleep buildSpeed/2
                SendEvent("{Enter}")
                Sleep buildSpeed
                needsPing := true
            }
        }
    } else {
        prevKey := "h"
        loop 3 {
            r := Chr(64+A_Index)
            xyz.z[A_Index] := r ;resets to A,B,C
            xyz.x[A_Index] := r
            xyz.ms[A_Index] := r
            xyz.mo[A_Index] := r
        }
    }
}

global skyboxID := "16073927858", skyboxSize := "-2E4"
skybox(id:=skyboxID,size:="-2E4",base:=2,pingWait:=100,buildSpeed:=50) {
    static pos := [ ;precalculated values
        ["-0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF","0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF"], ;2^3 = 8 skybox parts
        ["-0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF","0","0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF"], ;3^3 = 27 skybox parts
        ["-0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF","-0X5555552AAAAAA9555555555555555555","0X5555552AAAAAA9555555555555555555","0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF"], ;4^3 = 64 skybox parts
        ["-0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF","-0X7FFFFFBFFFFFFDFFFFFFFFFFFFFFFFFF.8","0","0X7FFFFFBFFFFFFDFFFFFFFFFFFFFFFFFF.8","0XFFFFFF7FFFFFFBFFFFFFFFFFFFFFFFFF"] ;5^3 = 125 skybox parts
    ] 
    /*static pos := [
        ["-10","10"],
        ["-10","0","10"],
        ["-10","-3.333","3.333","10"],
        ["-10","-5","0","5","10"]
    ]*/
    last := A_Clipboard
    global f3x
    WinActivate("Roblox")
    Sleep buildSpeed
    SendEvent("j")
    Click
    Sleep pingWait*2
    A_Clipboard := "nan"
    Fclick(f3x.z[2]*)
    Sleep buildSpeed
    SendEvent("^v")
    Sleep buildSpeed
    SendEvent("{Enter}")
    Sleep buildSpeed
    SendEvent("x")
    Sleep pingWait*2
    f3xInput([0,0,0],"x","x",pingWait,buildSpeed)
    Sleep pingWait
    SendEvent("h")
    Sleep pingWait
    Fclick(f3x.mesh*)
    Sleep pingWait
    Fclick(f3x.mesh*)
    Sleep pingWait
    Fclick(f3x.file*)
    Sleep pingWait
    Fclick(f3x.texture*)
    A_Clipboard := id
    Sleep buildSpeed
    SendEvent("^v")
    Sleep buildSpeed
    SendEvent("{Enter}")
    Sleep buildSpeed
    f3xInput([size,size,size],"ms","h",pingWait,buildSpeed)
    Sleep buildSpeed
    n := base**3
    p := base-1
    loop n {
        ToolTip("YOU CAN PRESS E TO CANCEL SKYBOX MACRO`n`n" A_Index "/" n,A_ScreenWidth/2,A_ScreenHeight/2)
        if(A_PriorKey="e") {
            ToolTip()
            f3xInput([],"","",0,,true)
            A_Clipboard := last
            return
        }
        gray := toGray(base,3,A_Index-1)
        f3xInput([pos[p][base-gray[1]],pos[p][base-gray[2]],pos[p][base-gray[3]]],"mo","h",pingWait,buildSpeed)
        f3xInput([pos[p][gray[1]+1],pos[p][gray[2]+1],pos[p][gray[3]+1]],"z","z",pingWait,buildSpeed)
        if(A_Index!=n) {
            SendEvent("^c")
            Sleep pingWait
        }
    }
    ntime := 0
    ToolTip()
    f3xInput([],"","",0,,true)
    A_Clipboard := last
}

global hasDoneSkyboxSetup := false
skyboxm(ThisHotKey) {
    global skyboxID, skyboxSize, f3x, title, hasDoneSkyboxSetup
    r := false
    if(MsgBox(hasDoneSkyboxSetup?"do you want to redo skybox macro setup?":"YOU NEED TO DO THE SKYBOX MACRO SETUP FIRST TO USE IT",title,"YesNo")="Yes") {
        val := skyboxSetup()
        if(Type(val)="Object") {
            f3x := val
            hasDoneSkyboxSetup := true
            saveSettings()
        } else {
            saveSettings()
            return
        }
    }
    if(!hasDoneSkyboxSetup) {
        saveSettings()
        return
    }
    ping := InputBox3(&r,"WHAT IS YOUR AVARAGE PING?","",true)
    if(!r) {
        saveSettings()
        return
    }
    skyboxID := InputBox3(&r,"SKYBOX ID`n`nfart army skybox is 16073927858",skyboxID,false)
    if(!r) {
        saveSettings()
        return
    }
    skyboxSize := InputBox3(&r,"SKYBOX SIZE`n`nskybox size must be negative`nE is scientific notation`n-2E4 = -20000, (4 zeros, -20 thousand)",skyboxSize,false)
    if(!r) {
        saveSettings()
        return
    }
    base := InputBox3(&r,"HIDE LEADERBOARD IF IT IS IN THE WAY OF F3X!`n`nCHOOSE AMOUNT OF SKYBOX PARTS`n`n1. 8 skybox parts`n2. 27 skybox parts`n3. 64 skybox parts`n4. 125 skybox parts`n`nWARNING: many skybox parts is laggy","",true)+1
    if(!r||!(base>=2&&base<=5)) {
        saveSettings()
        return
    }
    saveSettings()
    skybox(skyboxID,skyboxSize,base,Ceil(ping/50)*125)
}

class fartArmyScript { ;I like the syntax and way of programming classes, I wish I could easily code this as an object in ahk v2 but meh it doesnt matter so much
    waitflag := -1
    index := 1
    loopstack := []
    rList := ""
    variables := Map()
    variables.default := ""
    inf := -1
    varChar := '‡'
    errorChar := '■'
    errorCode := '±¬††'
    executing := 0
    currentKey := "x"
    pClip := ""
    freq := 0
    isLag := false
    isFrozen := false
    frame := 1000/60

    syntaxMark := "" ;band aid solution

    __New() {
        temp := 0 ;something weird happens if I use &this.freq
        DllCall("QueryPerformanceFrequency","int64*",&temp)
        this.freq := temp
    }

    syntaxError(fartScript,index,action,explanation) {
        return MultiLineInputBox("SYNTAX ERROR!`n`nAT ACTION " index+1 ", " action "`n`n" explanation "`n`nthe error has been marked with " this.errorChar "`nyou can remove the " this.errorChar,StrReplace(SubStr(fartScript,1,StrLen(fartScript)-1),this.syntaxMark,this.errorChar this.syntaxMark this.errorChar,true,,1)) " "
    }
    syntaxError2(fartScript,explanation) {
        return MultiLineInputBox("SYNTAX ERROR!`n`n" explanation,SubStr(fartScript,1,StrLen(fartScript)-1)) " "
    }
    firstInvalidKey(input) { ;1 error fix at a time ensures they dont do it again
        special := false
        key := ""
        loop parse input {
            if(A_LoopField="{") {
                special := true
                continue
            } else if(A_LoopField="}") {
                special := false
                try {
                    GetKeyState(key,"P")
                } catch {
                    return key=""?" ":key
                }
                key := ""
                continue
            }
            if(special) {
                key .= A_LoopField
            }
        }
        return ""
    }
    syntax(Mstr,user) {
        dstr := Mstr
        syntaxRedo:
        Marr := []
        str := ""
        Rstr := ""
        parantes := 0
        curly := 0
        bunny := false
        variable := false
        REDO := false
        Lcount := 0
        ENDcount := 0
        space := false
        len := StrLen(Mstr)
        line := ""
        loop parse dstr {
            fBool := bunny||variable
            switch(A_LoopField) {
                case "(":
                    if(!fBool) {
                        parantes++
                    }
                case ")":
                    if(!fBool) {
                        parantes--
                    }
                case "{":
                    if(!fBool) {
                        curly++
                    }
                case "}":
                    if(!fBool) {
                        curly--
                    }
                case '"':
                    bunny := !bunny
                case this.varChar:
                    variable := !variable
            }
            cBool := !fBool&&curly=0&&parantes=0
            if(((A_LoopField!=" "&&Ord(A_LoopField)!=10)||parantes>0||curly>0||fBool)&&A_Index!=StrLen(dstr)) {
                if(A_LoopField!=this.errorChar||fbool) {
                    str .= cBool? StrUpper(A_LoopField):A_LoopField
                    this.syntaxMark .= A_LoopField
                }
            } else if(str!="") {
                ;I basically have to code myself here as a syntax checker making sure the users type the code correctly for fucks sake.
                ;Otherwise there would be lots of errors and they would all go to me asking about it and how to fix it.
                ;You could say this code is ME watching over their shoulder so they type correctly.
                ;I have to think about all possible ways some retard can FUCK UP the code and I must be able add checks in the future for if some RETARD finds a way to fuck up it even more.
                ;ALWAYS assume the users are retarded.
                if(A_Index=StrLen(dstr)) {
                    switch { ;this looks more nice and is faster to write than a gigantic else if chain (this basically acts the same as an else if chain in ahk v2 if there is no input in the switch function) https://www.autohotkey.com/docs/v2/lib/Switch.htm#examples
                        case variable:
                            dstr := this.syntaxError2(dstr,"YOU'VE GOT AN UNFINISHED " this.varChar this.varChar "`n`nThis is variable name notation. You press alt+space to type it!")
                            REDO := true
                        case bunny:
                            dstr := this.syntaxError2(dstr,'YOU`'VE GOT AN UNFINISHED ""')
                            REDO := true
                        case curly!=0:
                            dstr := this.syntaxError2(dstr,"YOU'VE GOT AN UNFINISHED {}")
                            REDO := true
                        case parantes!=0:
                            dstr := this.syntaxError2(dstr,"YOU'VE GOT AN UNFINISHED ()")
                            REDO := true
                    }
                    if(REDO) {
                        goto syntaxRedo
                    }
                }
                switch(SubStr(str,1,2)) { ;TODO: xWF, xMD, xMC, xFW, xCS, xSS, xSR, xSH, xCR, xCM, xW, xL, xK, xH, xR, xT, xF, xM, xdC, xV, xEND, xinbuilt, xlogic, xSYNTAX, xunknown. Mark x to show when syntax for each of these have been added
                    case "WF":
                        if(!IsNumber(this.eval(SubStr(str,3)))&&str!="WF") {
                            dstr := this.syntaxError(dstr,Marr.Length,str,"WF means waitflag. You are supposed to type a number after WF that tells what wait there will be in miliseconds before every input action")
                            REDO := true
                        }
                    case "MD":
                        err := "MD stands for mouse drag. You are supposed to put 4 numbers inside a () after MD like this MD(x1,y1,x2,y2). These numbers are the 2 screen coordinates. It starts at the first coordinte then drags to the second."
                        if(SubStr(str,3,1)!="("||SubStr(str,-1,1)!=")") { ;no ()
                            dstr := this.syntaxError(dstr,Marr.Length,str,err)
                            REDO := true
                        } else {
                            coord := StrSplit(SubStr(str,4,StrLen(str)-4),",")
                            loop 4 {
                                try {
                                    if(!IsNumber(this.eval(coord[A_Index],true))) { ;not a number
                                        dstr := this.syntaxError(dstr,Marr.Length,str,err " YOU ARE SUPPOSED TO PUT 4 NUMBERS!")
                                        REDO := true
                                        break
                                    }
                                } catch { ;no 4 numbers
                                    dstr := this.syntaxError(dstr,Marr.Length,str,err " YOU ARE SUPPOSED TO PUT 4 NUMBERS!")
                                    REDO := true
                                    break
                                }
                            }
                            if(coord.Length>4&&!REDO) { ;too many numbers
                                dstr := this.syntaxError(dstr,Marr.Length,str,err " YOU ARE SUPPOSED TO PUT 4 NUMBERS!")
                                REDO := true
                            }
                        }
                    case "MC":
                        err := "MC stands for move mouse then click. You put 2 numbers inside () after MC like this MC(x,y). The mouse moves to these coordinates then it clicks there once."
                        if(SubStr(str,3,1)!="("||SubStr(str,-1,1)!=")") { ;no ()
                            dstr := this.syntaxError(dstr,Marr.Length,str,err)
                            REDO := true
                        } else {
                            coord := StrSplit(SubStr(str,4,StrLen(str)-4),",")
                            loop 2 {
                                try {
                                    if(!IsNumber(this.eval(coord[A_Index],true))) { ;not a number
                                        dstr := this.syntaxError(dstr,marr.Length,str,err " YOU ARE SUPPOSED TO PUT 2 NUMBERS IN THE ()")
                                        REDO := true
                                        break
                                    }
                                } catch { ;no 2 numbers
                                    dstr := this.syntaxError(dstr,marr.Length,str,err " YOU ARE SUPPOSED TO PUT 2 NUMBERS IN THE ()")
                                    REDO := true
                                    break
                                }
                            }
                            if(coord.length>2&&!REDO) { ;too many numbers
                                dstr := this.syntaxError(dstr,marr.Length,str,err " YOU ARE SUPPOSED TO PUT 2 NUMBERS IN THE ()")
                                REDO := true
                            }
                        }
                    case "FW":
                        eStr := this.eval(str)
                        path := "files\macro\custom\" SubStr(eStr,4,StrLen(eStr)-4)
                        err := "FW stands for file wait. You type it like this: FW(filename). It runs a file from the custom folder in files\macro and the W in FW means that the entire macro is paused until the file run has finished."
                        if(SubStr(str,3,1)!="("||SubStr(str,-1,1)!=")") { ;no ()
                            dstr := this.syntaxError(dstr,Marr.Length,str,err " YOU HAVE FORGOTTEN TO ADD ()")
                            REDO := true
                        } else if(!FileExist(path)) { ;file does not exist
                            dstr := this.syntaxError(dstr,Marr.Length,str,err " THE FILE PATH YOU ENETERED DOES NOT EXIST! " path)
                            REDO := true
                        }
                    case "CR":
                        if(!IsNumber(this.eval(SubStr(str,3)))&&str!="CL") {
                            dstr := this.syntaxError(dstr,Marr.Length,str,"CL means click right. It clicks with the right mouse button. YOU ARE SUPPOSED TO PUT A NUMBER AFTERWARDS THAT SAYS HOW MANY TIMES IT WILL CLICK!")
                            REDO := true
                        }
                    case "CM":
                        if(!IsNumber(this.eval(SubStr(str,3)))&&str!="CM") {
                            dstr := this.syntaxError(dstr,Marr.Length,str,"CM means click middle. It clicks with the middle mouse button AKA scoll button. YOU ARE SUPPOSED TO PUT A NUMBER AFTERWARDS THAT SAYS HOW MANY TIMES IT WILL CLICK!")
                            REDO := true
                        }
                    case "CS","SS","SR","SH","F1","F0": ;so they dont get flagged as unknown
                    default:
                    switch(SubStr(str,1,1)) {
                        case "W":
                            if(!IsNumber(this.eval(SubStr(str,2)))&&str!="W") {
                                dstr := this.syntaxError(dstr,Marr.Length,str,"W means wait. It waits the specified miliseconds that is after W. YOU ARE SUPPOSED TO TYPE A NUMBER AFTER W")
                                REDO := true
                            }
                        case "L":
                            Lcount++
                            rest := SubStr(str,2)
                            if(!IsNumber(this.eval(rest))&&str!="L"&&rest!="F") {
                                dstr := this.syntaxError(dstr,Marr.Length,str,"L means loop. It executes the code that is between L and END the amount of times thats specified after L. YOU ARE SUPPOSED TO PUT A NUMBER AFTER L")
                                REDO := true
                            }
                        case "K":
                            if(str="K") {
                                dstr := this.syntaxError(dstr,Marr.Length,str,"K means key. It presses the specified keys that are after K. SPECIFY WHAT KEYS K WILL PRESS!")
                                REDO := true
                            }
                        case "H":
                            if(str="H") {
                                dstr := this.syntaxError(dstr,Marr.Length,str,"H means holds. It holds the specified keys that are after H. SPECIFY WHAT KEYS H WILL HOLD!")
                                REDO := true
                            }
                        case "R": ;if only R is used then it releases all keys that are held down by H, this means I only need this as a check so it does not mark this as unknown
                        case "T":
                            err := "T stands for text. It does text input. You type it like this T(text here)."
                            if(SubStr(str,2,1)!="("||SubStr(str,-1,1)!=")") { ;no ()
                                dstr := this.syntaxError(dstr,Marr.Length,str," YOU HAVE FORGOTTEN ()")
                                REDO := true
                            } else if(SubStr(str,3,StrLen(str)-3)="") { ;nothing inside ()
                                dstr := this.syntaxError(dstr,Marr.Length,str," SPECIFY WHAT T WILL TYPE!")
                                REDO := true
                            }
                        case "F":
                            eStr := this.eval(str)
                            path := "files\macro\custom\" SubStr(eStr,3,StrLen(eStr)-3)
                            err := "F stands for file. You type it like this: F(filename). It runs a file from the custom folder in files\macro"
                            if(SubStr(str,2,1)!="("||SubStr(str,-1,1)!=")") { ;no ()
                                dstr := this.syntaxError(dstr,Marr.Length,str,err " YOU HAVE FORGOTTEN TO ADD ()")
                                REDO := true
                            } else if(!FileExist(path)) { ;file does not exist
                                dstr := this.syntaxError(dstr,Marr.Length,str,err " THE FILE PATH YOU ENETERED DOES NOT EXIST! " path)
                                REDO := true
                            }
                        case "M":
                            err := "M stands for mouse move. You put 2 numbers inside () after M like this M(x,y). The cursor moves to these coordinates."
                            if(SubStr(str,2,1)!="("||SubStr(str,-1,1)!=")") { ;no ()
                                dstr := this.syntaxError(dstr,Marr.Length,str,err)
                                REDO := true
                            } else {
                                coord := StrSplit(SubStr(str,3,StrLen(str)-3),",")
                                loop 2 {
                                    try {
                                        if(!IsNumber(this.eval(coord[A_Index],true))) { ;not a number
                                            dstr := this.syntaxError(dstr,marr.Length,str,err " YOU ARE SUPPOSED TO PUT 2 NUMBERS IN THE ()")
                                            REDO := true
                                            break
                                        }
                                    } catch { ;no 2 numbers
                                        dstr := this.syntaxError(dstr,marr.Length,str,err " YOU ARE SUPPOSED TO PUT 2 NUMBERS IN THE ()")
                                        REDO := true
                                        break
                                    }
                                }
                                if(coord.length>2&&!REDO) { ;too many numbers
                                    dstr := this.syntaxError(dstr,marr.Length,str,err " YOU ARE SUPPOSED TO PUT 2 NUMBERS IN THE ()")
                                    REDO := true
                                }
                            }
                        case "C":
                            if(!IsNumber(this.eval(SubStr(str,2)))&&str!="C") {
                                dstr := this.syntaxError(dstr,Marr.Length,str,"C means click. It clicks with the left mouse button. YOU ARE SUPPOSED TO PUT A NUMBER AFTERWARDS THAT SAYS HOW MANY TIMES IT WILL CLICK!")
                                REDO := true
                            }
                        case "V":
                            noV := SubStr(str,2)
                            parts := []
                            equal := InStr(noV,"=")
                            key := ""
                            if(equal) {
                                parts.Push(SubStr(noV,1,equal-1),SubStr(nov,equal+1))
                                key := this.firstInvalidKey(parts[2])
                            }
                            try {
                                isString := SubStr(parts[2],1,1)='"'&&SubStr(parts[2],-1,1)='"'
                                if(isString) {
                                    key := ""
                                }
                            }
                            if(!equal) { ;no = error
                                dstr := this.syntaxError(dstr,Marr.Length,str,"V assigns variables, you have forgotten to add a = sign to note what the variable will be assigned to")
                                REDO := true
                            } else if(SubStr(parts[1],1,1)!=this.varChar&&SubStr(parts[1],-1,1)!=this.varChar) { ;no variable notation error
                                dstr := this.syntaxError(dstr,Marr.Length,str,'You have forgotten notation that says THIS IS A VARIABLE! The variable notation is ' this.varChar 'this' this.varChar ', where "this" is located inside ' this.varChar this.varChar '. You can press alt+space to type this! THIS ERROR IS LOCATED IN THE FIRST PART OF V BEFORE =')
                                REDO := true
                            } else if(key!="") { ;invalid key
                                dstr := this.syntaxError(dstr,Marr.Length,str,"INVALID KEY: " key "`nYOU CANT CHECK THE KEY STATE OF: " key)
                                REDO := true
                            } else if(!isString&&this.eval(this.logicKeys(parts[2]),true)=this.errorCode) { ;no " error / logic error
                                dstr := this.syntaxError(dstr,Marr.Length,str,'You have either forgotten to add "" to note the variable is text, OR you have done some error in the expression. This syntax error is what you assigned the variable to! THIS ERROR IS LOCATED IN THE SECOND PART OF V AFTER =')
                                REDO := true
                            } else {
                                switch(parts[1]) {
                                    case this.varChar "X" this.varChar, this.varChar "Y" this.varChar:
                                        dstr := this.syntaxError(dstr,Marr.Length,str,"INVALID VARIABLE NAME! " this.varChar "X" this.varChar " AND " this.varChar "Y" this.varChar " ARE INBUILT VARIABLES THAT TELL THE X AND Y COORDINATE OF THE CURSOR!")
                                        REDO := true
                                    case this.varChar "W" this.varChar, this.varChar "H" this.varChar:
                                        dstr := this.syntaxError(dstr,Marr.Length,str,"INVALID VARIABLE NAME! " this.varChar "W" this.varChar " AND " this.varChar "H" this.varChar " ARE INBUILT VARIABLES THAT TELL THE SCREEN HEIGHT/WIDTH!")
                                        REDO := true
                                    case this.varChar "I" this.varChar:
                                        dstr := this.syntaxError(dstr,Marr.Length,str,"INVALID VARIABLE NAME! " this.varChar "I" this.varChar " IS AN INBUILT VARIABLE THAT TELLS THE CURRENT COUNT OF THE CURRENT LOOP!")
                                        REDO := true
                                    case this.varChar "K" this.varChar:
                                        dstr := this.syntaxError(dstr,Marr.Length,str,"INVALID VARIABLE NAME! " this.varChar "K" this.varChar " IS AN INBUILT VARIABLE THAT TELLS WHAT KEY THE SCRIPT KEYBIND IS")
                                        REDO := true
                                    case this.varChar "T" this.varChar:
                                        dstr := this.syntaxError(dstr,Marr.Length,str,"INVALID VARIABLE NAME! " this.varChar "T" this.varChar " IS AN INBUILT VARIABLE THAT TELLS THE CURRENT TIME IN MILISECONDS SINCE BOOT")
                                        REDO := true
                                    default:
                                        if(StrReplace(parts[1],this.varChar,"")="") {
                                            dstr := this.syntaxError(dstr,Marr.Length,str,"INVALID VARIABLE NAME!")
                                            REDO := true
                                        } else {
                                            if(isString) { ;store the variables for future checking
                                                this.V([SubStr(parts[1],2,StrLen(parts[1])-2),parts[2],true])
                                            } else {
                                                this.V([SubStr(parts[1],2,StrLen(parts[1])-2),this.eval(this.logicKeys(parts[2]),true),false])
                                            }
                                        }
                                }
                            }
                        default:
                        switch(str) {
                            case "END":
                                ENDcount++
                            default:
                                e := SubStr(str,1,1)
                                le := SubStr(str,-1,1)
                                if((e="!"||e="(")&&SubStr(str,-1,1)=le) { ;logic
                                    key := this.firstInvalidKey(str)
                                    if(key!="") {
                                        dstr := this.syntaxError(dstr,Marr.Length,str,"INVALID KEY: " key "`nYOU CANT CHECK THE KEY STATE OF: " key)
                                        REDO := true
                                    } else if(this.eval(this.logicKeys(str),true)=this.errorCode) {
                                        dstr := this.syntaxError(dstr,Marr.Length,str,"YOU HAVE DONE SOMETHING WRONG IN THIS LOGIC STATEMENT!") ;very helpful I know
                                        REDO := true
                                    }
                                } else if(e!="{"||le!="}") { ;unknown
                                    dstr := this.syntaxError(dstr,Marr.Length,str,"UNDEFINED ACTION!")
                                    REDO := true
                                }
                        }
                    }
                }
                if(REDO) {
                    goto syntaxRedo ;no recursion gang
                }
                Marr.Push(str)
                Rstr .= Marr.Length=1? str:(space?" ":line) str
                str := ""
                line := ""
                this.syntaxMark := ""
            }
            if(cbool) {
                if(A_LoopField=" ") {
                    space := true
                } else if(A_LoopField=Chr(10)) {
                    space := false
                    line .= A_LoopField
                }
            }
        }
        if(Lcount!=ENDcount) {
            dstr := this.syntaxError2(dstr,"YOU DONT HAVE AS MANY L AS THERE ARE END!`n`namount of L: " Lcount "`namount of END: " ENDcount "`n`nYOU NEED TO DEFINE WHERE ALL LOOPS START AND END!")
            goto syntaxRedo ;no recursion needed, nuh uh
        } else if(user) {
            MsgBox("YOU PRESS CTRL ALT E TO EXIT A RUNNING FART ARMY SCRIPT!",title)
        }
        this.variables.Clear()
        return [Rstr,Marr]
    }
    inputSyntax(str) { ;input from K, H, R has to be lowercase, otherwise it presses shift. This function is here to do lowercase but not on variables since otherwise it would ruin variable names
        output := ""
        isVar := !SubStr(str,1,1)=this.varChar
        loop parse str, this.varChar {
            output .= isVar? this.varChar A_LoopField this.varChar : StrLower(A_LoopField)
            isVar := !isVar
        } else {
            return str
        }
        return output
    }
    compile(Mstr,user) {
        step1 := this.syntax(Mstr " ",user) ;syntax will return an array of strings then the compiler will turn that into instructions which the execute function follows
        Sarr := step1[2]
        Marr := []
        skipTo := 0
        loop Sarr.length {
            index := A_Index
            upTo := [SubStr(Sarr[A_Index],1,1),SubStr(Sarr[A_Index],1,2)]
            lUpTo := [SubStr(Sarr[A_Index],-1,1)]
            switch(upTo[2]) { ;COMPACT
                case "WF": ;WF
                    Marr.Push(["WF",SubStr(Sarr[A_Index],3)])
                case "MD": ;MD
                    coord := StrSplit(SubStr(Sarr[A_Index],4,StrLen(Sarr[A_Index])-4),",")
                    Marr.Push(["MD",[coord[1],coord[2],coord[3],coord[4]]])
                case "MC": ;MC
                    coord := StrSplit(SubStr(Sarr[A_Index],4,StrLen(Sarr[A_Index])-4),",")
                    Marr.Push(["MC",[coord[1],coord[2]]])
                case "FW": ;FW
                    Marr.Push(["FW",SubStr(Sarr[A_Index],4,StrLen(Sarr[A_Index])-4)])
                case "CS","SS","SR","SH","F1","F0":
                    Marr.Push([upTo[2],0])
                case "CR","CM":
                    Marr.Push([upTo[2],Sarr[A_Index]=upTo[2]? 1:SubStr(Sarr[A_Index],3)])
                default: 
                switch(upto[1]) {
                    case "W": ;W
                        Marr.Push(["W",SubStr(Sarr[A_Index],2)])
                    case "L": ;L
                        rest := SubStr(Sarr[A_Index],2)
                        Marr.Push(["L",rest="F"?this.inf:rest=""? 1:rest])
                    case "K","H","R":
                        Marr.Push([upTo[1],this.inputSyntax(SubStr(Sarr[A_Index],2))])
                    case "T":
                        Marr.Push(["T",SubStr(Sarr[A_Index],3,StrLen(Sarr[A_Index])-3)])
                    case "F":
                        Marr.Push(["F",SubStr(Sarr[A_Index],3,StrLen(Sarr[A_Index])-3)])
                    case "M": ;M
                        coord := StrSplit(SubStr(Sarr[A_Index],3,StrLen(Sarr[A_Index])-3),",")
                        Marr.Push(["M",[coord[1],coord[2]]])
                    case "C": ;C
                        Marr.Push(["C",Sarr[A_Index]="C"? 1:SubStr(Sarr[A_Index],2)])
                    case "V": ;V
                        NoV := SubStr(Sarr[A_Index],2)
                        equal := InStr(noV,"=")
                        parts := [SubStr(noV,1,equal-1),SubStr(nov,equal+1)]
                        bool := SubStr(parts[2],1,1)='"'&&lUpTo[1]='"'
                        Marr.Push(["V",[SubStr(parts[1],2,StrLen(parts[1])-2),bool? SubStr(parts[2],2,StrLen(parts[2])-2):parts[2],bool]])
                    default:
                    switch {
                        case upTo[1]="{"&&lUpTo[1]="}": ;special keys
                            Marr.Push(["specialKey",Sarr[A_Index]])
                        case Sarr[A_Index]="END": ;END
                            Marr.Push(["END",0])
                        default: 
                            skipTo := A_Index+1
                            try {
                                if(SubStr(Sarr[skipTo],1,1)="L") {
                                    depth := 0
                                    loop Sarr.Length-index-1 {
                                        lindex := A_Index+index+1
                                        if(SubStr(Sarr[lindex],1,1)="L") {
                                            depth++
                                        } else if(Sarr[lindex]="END") {
                                            if(depth>0) {
                                                depth--
                                            } else {
                                                skipTo := lindex
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                            Marr.Push(["logic",[Sarr[A_Index],skipTo]])
                    }
                }
            }
        }
        return [step1[1],Marr] ;syntax corrected script, compiled script
    }
    eval(input,e2:=false) {
        try {
            output := ""
            isVar := !SubStr(input,1,1)=this.varChar
            loop parse input, this.varChar {
                if(isVar) {
                    ;MsgBox(A_LoopField)
                    switch(A_LoopField) {
                        case "X","Y":
                            MouseGetPos(&px,&py)
                            output .= A_LoopField="X"? px:py
                        case "I":
                            output .= this.loopstack.Length=0? "0":"" this.loopstack[this.loopstack.Length][3]-this.loopstack[this.loopstack.Length][2]+1
                        case "W":
                            output .= "" A_ScreenWidth
                        case "H":
                            output .= "" A_ScreenHeight
                        case "K":
                            try {
                                output .= e2?GetKeyState(this.currentKey,"P"):this.currentKey
                            } catch {
                                output .= 0
                            }
                        case "T":
                            time := 0
                            DllCall("QueryPerformanceCounter","int64*",&time)
                            output .= "" 1000*time/this.freq ;measurment of time is in miliseconds
                        default:
                            output .= "" this.variables.Get(A_LoopField)
                    }
                } else {
                    output .= A_LoopField
                }
                isVar := !isVar
            } else {
                return e2? eval(input):input
            }
            return e2? eval(output):output
        } catch as err {
            return this.errorCode
        }
    }
    logicKeys(input) {
        iinput := ""
        variable := false
        special := false
        checkKey := ""
        loop parse input {
            if(A_LoopField=this.varChar) {
                variable := !variable
            } else if(A_LoopField="{") {
                special := true
                continue
            } else if(A_LoopField="}") {
                special := false
                iinput .= GetKeyState(checkKey,"P")
                checkKey := ""
                continue
            }
            if(special) {
                checkKey .= A_LoopField
            } else {
                iinput .= Ord(A_LoopField)>=65&&Ord(A_LoopField)<=90&&!variable? GetKeyState(A_LoopField,"P") : A_LoopField
            }
        }
        return iinput
    }

    WF(input) {
        this.waitflag := Integer(this.eval(input))
    }
    W(input) {
        global fartRunning
        SleepEx(Integer(this.eval(input)),&fartRunning)
    }
    L(input) {
        iinput := this.eval(input)
        this.loopstack.Push([this.index,iinput,iinput])
    }
    END(input) {
        if(this.loopstack.Length=0) {
            return
        }
        if(this.loopstack[this.loopstack.Length][2]>0) {
            this.loopstack[this.loopstack.Length][2]--
            if(this.loopstack[this.loopstack.Length][2]<=0) {
                this.loopstack.Pop()
            } else {
                this.index := this.loopstack[this.loopstack.Length][1]
            }
        } else {
            this.index := this.loopstack[this.loopstack.Length][1]
        }
    }
    CS(input) {
        this.isLag := true
        getCurrent(false)
        blockInternetAccess()
    }
    SS(input) {
        this.isLag := false
        getCurrent(false)
        unblockInternetAccess()
    }
    F1(input) {
        this.isFrozen := true
        freeze(true)
    }
    F0(input) {
        this.isFrozen := false
        freeze(false)
    }
    SR(input) {
        rejoin()
    }
    SH(input) {
        serverHop()
    }
    K(input) {
        SendEvent("{RAW}" this.eval(input))
    }
    T(input) {
        if(this.pClip="") {
            this.pClip := A_Clipboard
        }
        A_Clipboard := this.eval(input)
        SendEvent("^v")
    }
    H(input) {
        iinput := this.eval(input)
        loop parse iinput {
            SendEvent("{" A_LoopField " down}")
            if(InStr(this.rList,A_LoopField)=0) {
                this.rList .= A_LoopField
            }
        }
    }
    R(input) {
        if(input="") { ;release all held down keys by H
            loop parse this.rList {
                SendEvent("{" A_LoopField " up}")
            }
            this.rList := ""
            return
        }
        iinput := this.eval(input)
        loop parse iinput {
            SendEvent("{" A_LoopField " up}")
            this.rList := StrReplace(this.rList,A_LoopField,"")
        }
    }
    MD(input) {
        i1 := this.eval(input[1],true), i2 := this.eval(input[2],true), i3 := this.eval(input[3],true), i4 := this.eval(input[4],true) ;lets just hope this.eval is a fast function?
        Fmove(i1,i2)
        SleepEx(this.frame)
        SendEvent("{LButton Down}")
        SleepEx(this.frame) 
        Fmove(i3,i4)
        SleepEx(this.frame)
        SendEvent("{LButton Up}")
    }
    MC(input) {
        i1 := this.eval(input[1],true), i2 := this.eval(input[2],true)
        Fmove(i1,i2)
        Click(,i1,i2)
    }
    M(input) {
        i1 := this.eval(input[1],true), i2 := this.eval(input[2],true)
        Fmove(i1,i2)
        MouseMove(i1,i2)
    }
    C(input) {
        iinput := this.eval(input)
        loop iinput {
            Click
        }
    }
    CL(input) {
        iinput := this.eval(input)
        loop iinput {
            Click "L"
        }
    }
    CM(input) {
        iinput := this.eval(input)
        loop iinput {
            Click "M"
        }
    }
    specialKey(input) {
        SendEvent(this.eval(input))
    }
    V(input) {
        if(!input[3]) {
            this.variables.Set(input[1],this.eval(this.logicKeys(input[2]),true))
        } else {
            this.variables.Set(input[1],input[2])
        }
    }
    FW(input) {
        try {
            RunWait "files\macro\custom\" input
        }
    }
    F(input) {
        try {
            Run "files\macro\custom\" input
        }
    }
    logic(input) {
        iinput := this.logicKeys(input[1])
        if(!this.eval(iinput,true)) {
            try { ;love these try. Maybe im overusing them, same thing with goto?
                if(%this.executing%[input[2]][1]="END"&&%this.executing%[this.index+1][1]!="L") {
                    try {
                        this.loopstack.Pop()
                    }
                }
            }
            this.index := input[2] ;if logic statement is false it skips the next action
        }
    }

    execute(Marr,key) {
        global fartRunning := true
        this.executing := &Marr ;pointer
        this.currentKey := StrUpper(getkey(key))
        while(this.index<=Marr.length&&fartRunning) {
            switch(Marr[this.index][1]) { ;wait flag only happens for actions, not control, variables or logic
                case "W","WF","L","END","V","logic": ;ignores waitflag
                default:
                try { 
                    if(Marr[this.index-1][1]="W") {
                        goto ESCAPE
                    }
                }
                if(this.waitflag>0) {
                    SleepEx(this.waitflag,&fartRunning)
                }
            }
            ESCAPE:
            this.%Marr[this.index][1]%(Marr[this.index][2])
            this.index++
        } else {
            return
        }
        loop parse this.rList {
            SendEvent("{" A_LoopField " up}")
        }
        this.waitflag := -1
        this.index := 1
        this.loopstack := []
        this.rList := ""
        this.variables.Clear()
        if(this.pClip!="") {
            SleepEx(this.frame)
            A_Clipboard := this.pClip
            this.pClip := ""
        }
        if(this.isFrozen) {
            this.isFrozen := false
            freeze(false)
        }
        if(this.isLag) {
            this.isLag := false
            getCurrent(false)
            unblockInternetAccess()
        }
    }
}
global fartRunning := true
fartScript := fartArmyScript()

Alt & Space:: {
    SendEvent(fartScript.varChar fartScript.varChar "{Left}")
    while GetKeyState("Alt","P")&&GetKeyState("Space","P") {
        Sleep 10
    }
}

^!e::{
    global fartRunning := false
}

global vars := ["smashKeys","smashTimes","x","fps","sdir","keys","tmin","tmax","tmash","tmode","delay","mt","cmode","KeyBinds","restart","msg","chatKey","MPS","chatMode","ltime","f3x","skyboxID","skyboxSize","hasDoneSkyboxSetup","hasDoneSpeedCalibration"]
global space := Chr(3), space2 := Chr(4)
saveSettings() {
    global vars, space, scripts, f3x
    try {
        FileDelete("files\settings")
    }
    loop vars.Length {
        switch Type(%vars[A_Index]%) {
            case "Object": ;as of now theres only 1 object being saved, f3x (this is terrible I know, if I add more objects in the future I will write a way to deal with all objects)
                arrs1D := ["mesh","file","texture"]
                arrs2D := ["z","ms","mo"]
                loop arrs1D.Length {
                    l := f3x.%arrs1D[A_Index]%.Length
                    i := A_Index
                    loop l {
                        FileAppend(f3x.%arrs1D[i]%[A_Index] (A_Index<l? space:" "),"files\settings")
                    }
                }
                loop arrs2D.Length {
                    i := A_Index
                    loop f3x.%arrs2D[A_Index]%.Length {
                        l := f3x.%arrs2D[i]%[A_Index].Length
                        i2 := A_Index
                        loop l {
                            FileAppend(f3x.%arrs2D[i]%[i2][A_Index] (A_Index<l?space:space2),"files\settings")
                        }
                    }
                    if(A_Index!=arrs2D.Length) {
                        FileAppend(" ","files\settings")
                    }
                }
                FileAppend("`n","files\settings")
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
    try {
        FileDelete("files\macro\fartArmyScripts")
    }
    loop scripts.Length {
        FileAppend(scripts[A_Index][4] space scripts[A_Index][3] space StrReplace(scripts[A_Index][1],Chr(10),Chr(5)) "`n","files\macro\fartArmyScripts")
    }
}

setGlobal(var,value) {
    global
    %var% := value
}

loadSettings() {
    global vars, space, space2, KeyBinds, keybindsm, keymap, scripts, scriptMap, f3x
    loop read "files\settings" {
        switch Type(%vars[A_Index]%) {
            case "Object":
                arrs1D := ["mesh","file","texture"]
                arrs2D := ["z","ms","mo"]
                arr := StrSplit(A_LoopReadLine," ")
                loop arr.Length {
                    if(A_Index<=arrs1D.Length) {
                        arr1 := StrSplit(arr[A_Index],space)
                        f3x.%arrs1D[A_Index]% := arr1
                    } else {
                        arr2 := StrSplit(arr[A_Index],space2)
                        arr3 := []
                        loop arr2.Length {
                            arr3.Push(StrSplit(arr2[A_Index],space))
                        }
                        f3x.%arrs2D[A_Index-arrs1D.length]% := arr3
                    }
                }
            case "Array":
                arr := StrSplit(A_LoopReadLine,space)
                setGlobal(vars[A_Index],arr)
            default: 
                setGlobal(vars[A_Index],A_LoopReadLine)
        }
    }
    if(FileExist("files\macro\fartArmyScripts")) {
        Marr := []
        loop read "files\macro\fartArmyScripts" {
            arr := StrSplit(A_LoopReadLine,space)
            keymap[arr[1]] := true
            tArr := fartScript.compile(StrReplace(arr[3],Chr(5),Chr(10)),false) ;if startups get slow then I its this
            tArr.Push(arr[2],arr[1])
            Marr.Push(tArr)
            scriptMap[tArr[4]] := tArr[2]
            try {
            Hotkey(tArr[4],fartArmyKeybind,"On")
            }
        }
        setGlobal("scripts",Marr)
    }
    global keysd := "{space down}", keysu := "{space up}"
    loop parse keys {
        keysd .= "{" A_LoopField " down}"
        keysu .= "{" A_LoopField " up}"
    }
    loop KeyBinds.Length {
        keymap[KeyBinds[A_Index]] := true
        try { ;yeah the user will prob change the keybind if they notice its not working
            Hotkey(KeyBinds[A_Index],keybindsm[A_Index],"On")
        }
    }
}

global allowedf := Map("files",true,"FART ARMY MACRO.ahk",true)
allowedf.Default := false

checkEnviroment() {
    try {
        checkReader()
        if(FileExist("README.md")) {
            FileDelete("README.md")
        }
        if(A_ScriptName != "FART ARMY MACRO.ahk") {
            MsgBox("THIS FILE MUST BE NAMED FART ARMY MACRO",title)
            ExitApp()
        }
        loop Files A_ScriptDir "\*", "D" {
            if(A_Index > 2 || !allowedf[A_LoopFileName]) {
                MsgBox("YOU HAVE PROBABLY DOWNLOADED THIS MACRO INCORRECTLY!`n`nYOU ARE SUPPOSED TO DOWNLOAD IT THROUGH THE DOWNLOAD LINK IN README THEN EXTRACT THE ZIP FILE!",title)
                ExitApp()
            }
        }
        if(!FileExist("files\FARTlog.ahk")) {
            MsgBox("YOU HAVE PROBABLY DOWNLOADED THIS MACRO INCORRECTLY!`n`nYOU ARE SUPPOSED TO DOWNLOAD IT THROUGH THE DOWNLOAD LINK IN README THEN EXTRACT THE ZIP FILE!",title)
            ExitApp()
        }
    } catch {
        MsgBox("YOU HAVE PROBABLY DOWNLOADED THIS MACRO INCORRECTLY!`n`nYOU ARE SUPPOSED TO DOWNLOAD IT THROUGH THE DOWNLOAD LINK IN README THEN EXTRACT THE ZIP FILE!",title)
        ExitApp()
    }
}
checkEnviroment()

global ComSpec := EnvGet("ComSpec"), lagDebug := false
executeCommand(command) {
    global ComSpec
    if(lagDebug) {
        try {
            FileDelete("files\command.bat")
        }
        FileAppend(command " & pause","files\command.bat")
        RunWait("files\command.bat")
    } else {
        RunWait(ComSpec . ' /C ' . command,,"Hide")
    }
}

global version := "", ltime := 18

blockInternetAccess(filePath := version "RobloxPlayerBeta.exe") {
    if(filePath != "") {
        executeCommand('netsh advfirewall firewall add rule name="BlockApp" dir=out action=block program=' filePath ' enable=yes')
    }
}

unblockInternetAccess(filePath := version "RobloxPlayerBeta.exe") {
    if(filePath != "") {
        executeCommand('netsh advfirewall firewall delete rule name="BlockApp" program=' filePath)
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
            while(GetKeyState(key,"P")) {
                Sleep 10
            }
            blockInternetAccess()
            time := 0
            DllCall("QueryPerformanceCounter","int64*",&time) ;int64, very precise timer indeed (useless)
            time /= fartScript.freq
            SetTimer(unblockInternetAccess,ltime*1000+100)
            passed := 0
            left := 0
            while(passed < ltime && !isKeybindHeld(ThisHotKey)) {
                now := 0
                DllCall("QueryPerformanceCounter","int64*",&now)
                passed := now/fartScript.freq-time
                if(left != ltime-passed && ltime-passed >= 0) {
                    left := Round(ltime-passed,1)
                    ToolTip("LAG SWITCH!`nHOLD " translatekeybind(ThisHotKey) " TO STOP`n`n" left,xx,yy,4)
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
}

clagSwitch() {
    global ltime
    ltime := Abs(InputBox2("max lag switch time in seconds",ltime,true))
    saveSettings()
}

SuspendedPID := Map()
SuspendedPID.Default := false
freeze(bool:=false,toggle:=false,key:="") {
    try {
        PID := WinGetPID("A")
        h := DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", PID)
        safe := WinActive("Roblox")
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
}

getkey(key) {
    return SubStr(key,-1)
}

freezetoggle(ThisHotkey) {
    key := getkey(ThisHotkey)
    while GetKeyState(key,"P") {
        Sleep 10
    }
    freeze(,true,translatekeybind(ThisHotkey))
    try {
        user := GetProcessUser(WinGetPID("Roblox"))
    } catch {
        user := A_UserName
    }
    if(version!=""&&user!=A_UserName) {
        MsgBox("YOU ARE USING THIS MACRO AS " A_UserName "`nBUT YOU ARE USING ROBLOX AS " user "`n`nYOU MUST USE THIS MACRO AND ROBLOX ON THE SAME USER FOR SERVERHOP, REJOIN AND FREEZE TOGGLE TO WORK!",title)
        return
    }
    while GetKeyState(key,"P") {
        Sleep 10
    }
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
    global smashKeys, smashTimes
    while true {
        switch(InputBox2("key smasher macro`nSELECT CUSTOMIZATION`n`n1. keys: " smashKeys "`n2. how many times the keys will be pressed: " smashTimes,"",false)) {
            case 1:
                smashKeys := InputBox2("what keys will you smash",smashKeys,false), title
            case 2:
                smashTimes := Abs(Integer(InputBox2("how many times will you smash these keys?",smashTimes,true)))
                smashTimes := smashTimes + (smashTimes=0)
            default: 
                break
        }
        saveSettings()
    }
}

global keys := "w", keysd := "{space down}{w down}{a down}", keysu := "{space up}{w up}{a up}", x := 95, y := A_ScreenHeight/2, sdir := true, fps := 60, hasDoneSpeedCalibration := false, reminder := false

speedm(ThisHotkey) { ;speed
    global hasDoneSpeedCalibration, reminder, title
    if(!hasDoneSpeedCalibration&&!reminder) {
        MsgBox("IT IS RECOMMENDED THAT YOU DO SPEED CALIBRATION BEFORE USING SPEED MACRO!`n`nYOU ALSO NEED TO SPECIFY SOME SETTINGS!",title)
        MsgBox("GO TO SPEED MACRO SETTINGS TO SET EVERYTHING UP!",title)
        reminder := true
        return
    }
    key := getkey(A_ThisHotkey)
    SendEvent(keysd)
    s := [sdir*x,!sdir*x], t := 1000/fps
    MouseMove(s[1],y)
    SleepEx(t)
    MouseMove(s[2],y)
    SleepEx(t)
    while GetKeyState(key,"P") {
        MouseMove(s[1],y)
        SleepEx(t)
        MouseMove(s[2],y)
        SleepEx(t)
    }
    SendEvent(keysu)
}

speed() { ;customize speed
    global title, placeID, keys, sdir, fps, x
    while true {
        switch(InputBox2("speed macro`nSELECT CUSTOMIZATION`n`n1. WASD keys: " keys "`n2. direction: " (sdir?"NORMAL":"REVERSE") "`n3. your roblox FPS: " fps "`n4. pixels: " x " (SPEED MACRO CALIBRATION CAN BE DONE HERE!)","",false)) {
            case 1:
                keys := StrLower(InputBox2("what wasd keys will the speed macro hold down?`n`nW IS RECOMMENDED!", keys,false))
                global keysd := "{space down}"
                global keysu := "{space up}"
                dupecheck := Map()
                dupecheck.Default := false
                str := ""
                loop parse keys {
                    switch(A_LoopField) {
                        case "w","a","s","d":
                            if(!dupecheck[A_LoopField]) {
                                keysd .= "{" A_LoopField " down}"
                                keysu .= "{" A_LoopField " up}"
                                str .= A_LoopField
                                dupecheck[A_LoopField] := true
                            }
                    }
                }
                keys := str
            case 2:
                sdir := MsgBox("press yes to keep current speed direction`n`npress no to reverse the direction" ,title,"YesNo")="Yes"? sdir:!sdir
            case 3:
                fps := Integer(Abs(InputBox2("what is your roblox fps?`n`nyou can press shift+F5 to view your fps in roblox`nyou can also customize max fps in roblox`nits best to use a stable fps`nstable meaning that your fps remains mostly the same",fps,true)))
            case 4:
                if((MsgBox("do you want to auto find right amount of pixels for speed?",title,"YesNo")="Yes")? MsgBox("are you sure you want to auto find the right amount of pixels?`n`nIT WILL MAKE YOU LEAVE AND JOIN A CALIBRATION GAME!",,"YesNo")="Yes":false) {
                    if(!join("126647205032462")) {
                        MsgBox("MACRO FAILED TO JOIN CALIBRATION GAME!")
                        x := Floor(Abs(InputBox2("how many pixels will the cursor move?",x,true)))
                        return
                    }
                    ToolTip("JOINING CALIBRATION GAME!`n`nYOU CAN HOLD E TO EXIT AUTO SETUP IF YOU ARE PERM STUCK!",A_ScreenWidth/2,A_ScreenHeight/2+50,7)
                    e := false
                    while(placeID!="126647205032462"&&!e) {
                        Sleep 100
                        if(GetKeyState("e","P")) {
                            e := true
                        }
                        getCurrent()
                    }
                    Sleep 1000
                    while(!WinExist("Roblox")&&!e) {
                        Sleep 100
                        if(GetKeyState("e","P")) {
                            e := true
                        }
                    }
                    if(e) {
                        ToolTip(,,,7)
                        return
                    }
                    Sleep 1000
                    while(WinExist("Pick an app")&&A_Index<30) {  ;I FUCKING HATE THIS POP UP!
                        WinClose("Pick an app")
                        Sleep 25
                    }
                    ToolTip(,,,7)
                    done := 0
                    ToolTip("PRESS ENTER 3 TIMES TO START SPEED CALIBRATION ONCE YOU HAVE FULLY LOADED INTO THE GAME!",A_ScreenWidth/2,A_ScreenHeight/2+50,7)
                    while done<3 {
                        if(waitForKey("{Enter}")=="Enter") {
                            done++
                            ToolTip("PRESS ENTER 3 TIMES TO START SPEED CALIBRATION ONCE YOU HAVE FULLY LOADED INTO THE GAME!`n`nIF YOU TOUCH YOUR MOUSE WHILE CALIBRATION IS DONE IT WILL FUCK IT UP! DONT BE RETARDED!`n`n" done "/3",A_ScreenWidth/2,A_ScreenHeight/2+50,7)
                            while GetKeyState("Enter","P") {
                                Sleep 10
                            }
                        }
                    }
                    Sleep 500
                    ToolTip(,,,7)
                    WinActivate("Roblox")
                    x := speedCalibrate(x)
                    SendEvent("{Escape}")
                    Sleep 50
                    SendEvent("l")
                    Sleep 50
                    SendEvent("{Enter}")
                    Sleep 50
                    global hasDoneSpeedCalibration := true
                } else {
                    x := Floor(Abs(InputBox2("how many pixels will the cursor move?",x,true)))
                }
            default:
                break
        }
        saveSettings()
    }
}

speedCalibrate(originalx) {
    y := A_ScreenHeight/2
    speed := 50
    Sleep 100
    SendEvent("r") ;just in case the user had paused
    Sleep 100
    SendEvent("{Enter}") ;respawn time is 0 in calibration game
    Sleep 500
    MouseMove(0,y)
    Sleep speed
    Send("r")
    Sleep speed
    x := 0
    nthRoot := 0
    angle := 0
    if(FileExist("files\speedY")) {
        FileDelete("files\speedY")
        FileAppend("","files\speedY")
    } else {
        FileAppend("","files\speedY")
    }
    Sleep 100
    loop 2 {
        x++
        ;ToolTip(x,A_ScreenWidth/2,A_ScreenHeight/2-50)
        MouseMove(x,y)
        Sleep 100
        SendEvent("t")
        Sleep 100
    }
    while(FileRead("files\speedY") = "" && !GetKeyState("e","P")) {
        SleepEx(1)
    }
    Yarr := StrSplit(FileRead("files\speedY")," ")
    a := -(Yarr[1]-Yarr[2])
    b := Yarr[1]-a*(x-1)+180
    lowest := [0,1E10]
    FileDelete("files\speedY")
    FileAppend("","files\speedY")
    offset := 0
    x2 := 0
    while !GetKeyState("e","P")&&x2<=A_ScreenWidth {
        x2 := Round((180-b+360*nthRoot)/a-offset)
        ;ToolTip(x,A_ScreenWidth/2,A_ScreenHeight/2-50)
        MouseMove(x2,y)
        Sleep 100
        SendEvent("t")
        redo:
        try {
            while(FileRead("files\speedY") = "" && !GetKeyState("e","P")) {
                SleepEx(1)
            }
            nthRoot++
            angle := Number(FileRead("files\speedY"))
        } catch {
            Sleep 90
            goto redo
        }
        completion := Round(100*x2/A_ScreenWidth)
        completion := completion<=100?completion:100 ;band aid solution
        ToolTip("HOLD E TO STOP CALIBRATING!`n`nCOMPLETION: " completion "%`n`nLOWEST ANGLE FOUND:`nPIXEL: " lowest[1] "`nANGLE: " lowest[2] "`n`nCURRENTLY BEING TESTED:`nPIXEL: " x2 "`nANGLE: " angle,A_ScreenWidth/2,A_ScreenHeight/2+50)
        if(Abs(angle) < Abs(lowest[2]) && Abs(angle) >= 0.095) { ;perfect 180 unstable for speed (I tested)
            lowest := [x2,angle]
        }
        offset := ((180-b+angle+360*Round(x2/(360/a)))/a)-x2
        FileDelete("files\speedY")
        FileAppend("","files\speedY")
    }
    FileDelete("files\speedY")
    Sleep 500
    ToolTip()
    return lowest[1]
}

global tmin := 1, tmax := 10, tmode := true, tmash := "qe", tindex := -1, delay := 25 ;tmode false = semi auto, tmode true = full auto

toolbarm(ThisHotKey) { ;use toolbar
    global tmin, tmax, tmode, tmash, tindex := (tindex=-1)? tmin:tindex
    key := getkey(ThisHotkey)
    while((tmode&&GetKeyState(key,"P"))||A_Index=1) {
        SendEvent("{" (tindex) "}{LButton}{Raw}" tmash)
        tindex := Mod(tmin+Mod(tindex-tmin+1,tmax-tmin+1),10)
        SleepEx(delay*tmode-!tmode)
    }
    while(GetKeyState(key,"P")&&!tmode) {
        Sleep 10
    }
}

toolbar() { ;customize use toolbar
    global tindex := -1, title, tmode, tmash, tmin, tmax, delay
    while true {
        switch(InputBox2('toolbar macro`nSELECT CUSTOMIZATION`n`n1. mode: ' (tmode?"FULL AUTO":"SEMI AUTO") '`n2. keys pressed every gear swap: ' tmash '`n3. start and end: ' tmin '-' tmax (tmode?"`n4. milisecond delay between every gear swap: " delay:""),"",false)) {
            case 1:
                tmode := (MsgBox("CURRENT MODE: " (tmode? "FULL AUTO":"SEMI AUTO") "`n`npress yes to keep current mode`n`npress no to change to " (!tmode? "FULL AUTO":"SEMI AUTO"),title,"YesNo")="Yes")? tmode:!tmode
            case 2:
                tmash := StrLower(InputBox2("what keys will be pressed every gear swap?",tmash,false))
            case 3:
                tmin := Abs(Integer(InputBox2("where in the toolbar will this macro start?",tmin,true)))
                tmin := (tmin=0||tmin>=10)? 1:tmin
                tmax := Abs(Integer(InputBox2("where in the toolbar will this macro end?`n`n10 here means that it ends at 0",tmax,true)))
                tmax := (tmax=0||tmax>=10)? 10:tmax
                if(tmin > tmax) {
                    t := tmax
                    tmax := tmin
                    tmin := t
                }
            case 4:
                if(tmode) {
                    delay := Integer(InputBox2("milisecond delay between every gear swap?",delay,true))
                    delay := Abs(delay)+(delay=0)*25
                } else {
                    break ;semi auto doesnt use delay
                }
            default: 
                break
        }
        saveSettings()
    }
}

f(CPS,limit := 50) { ;sleep is limitied in ahk, thus a multiplier has to be used to achieve higher CPS
    CPS := (CPS=0)+Abs(CPS), r := Ceil(CPS/limit)
    return [r,r*1000/CPS] ;https://www.desmos.com/calculator/aefmbh27s4
}

global mt := f(100), cmode := true ;mode true = hold, false = toggle

autoclick(ThisHotKey) { ;autoclicker
    global mt, cmode
    key := getkey(ThisHotKey)
    if(cmode) {
        ToolTip("AUTOCLICKER ON",A_ScreenWidth*0.1,A_ScreenHeight*0.1,3)
        while(GetKeyState(key,"P")) {
            loop mt[1] {
                Click
            }
            Sleep(mt[2])
        }
    } else {
        while(GetKeyState(key,"P")) {
            Sleep 10
        }
        ToolTip("AUTOCLICKER ON`n`nHOLD " translatekeybind(A_ThisHotkey) " TO TURN OFF AUTOCLICKER",A_ScreenWidth*0.1,A_ScreenHeight*0.1,3)
        while(!isKeybindHeld(ThisHotKey)) {
            loop mt[1] {
                Click
            }
            Sleep(mt[2])
        }
        while(GetKeyState(key,"P")) {
            Sleep 10
        }
    }
    ToolTip(,,,3)
}

autoc() { ;customize autoclicker
    global mt, cmode, title
    CPS := Round(mt[1]*(1000/mt[2]))
    while true {
        switch(InputBox2('autoclicker`nSELECT CUSTOMIZATION`n`n1. CPS (clicks per second): ' CPS '`n2. mode: ' (cmode?"HOLD":"TOGGLE"),"",false)) {
            case 1:
                mt := f(Round(InputBox2("CPS`n`nclicks per second",CPS,true)))
                CPS := Round(mt[1]*(1000/mt[2]))
            case 2:
                cmode := MsgBox("current autoclicker mode: " (cmode?"HOLD":"TOGGLE") "`n`npress yes to keep current autoclicker mode`n`npress no to change to " (!cmode?"HOLD":"TOGGLE"),title,"YesNo")="Yes"? cmode:!cmode
            default:
                break
        }
        saveSettings()
    }
}

global msg := "/e silly2", chatKey := "/", MPS := 30, chatMode := 3 ;1 = hold spam, 2 = once, 3 = toggle spam
autochat(ThisHotKey) {
    global msg, chatKey, MPS, chatMode, xx, yy
    oclip := A_Clipboard
    A_Clipboard := msg
    key := getkey(ThisHotKey)
    time := 1000/(MPS*3)
    if(chatMode=3) {
        while(GetKeyState(key,"P")) {
            Sleep 10
        }
        ToolTip("HOLD " translatekeybind(ThisHotKey) " TO STOP SPAMMING!",xx,yy,10)
    }
    while(chatMode=1?GetKeyState(key,"P"):chatMode=2?A_Index=1:!isKeybindHeld(ThisHotKey)) {
        SendEvent("{RAW}" chatKey)
        SleepEx(time)
        SendEvent("^v")
        SleepEx(time)
        SendEvent("{alt up}{Enter}")
        SleepEx(time)
    }
    if(chatMode=3) {
        while(GetKeyState(key,"P")) {
            Sleep 10
        }
        ToolTip(,,,10)
    }
    A_Clipboard := oclip
}

cautochat() {
    global msg, chatKey, MPS, chatMode
    while true {
        switch(InputBox2('auto chat`nSELECT CUSTOMIZATION`n`n1. message: "' msg '"`n2. chatkey: ' chatKey '`n3. mode: ' (chatMode=1?'HOLD SPAM':chatMode=2?'ONCE':'TOGGLE SPAM') (chatMode!=2?'`n4. message per second: ' MPS:''),"",false)) {
            case 1:
                msg := InputBox2("what will this macro auto chat?",msg,false)
            case 2:
                chatKey := InputBox2("what key do you press to chat?",chatKey,false)
            case 3:
                test := InputBox2("select chat mode`n`n1. hold for spam`n2. chat once`n3. toggle spam",chatMode,false)
                if(IsNumber(test)&&test>=1&&test<=3) {
                    chatMode := Integer(test)
                }
            case 4:
                if(chatMode=2) {
                    break
                }
                MPS := Integer(InputBox2("MPS`nmessage per second",MPS,true))
                MPS := Abs(MPS)+(MPS=0)
            default:
                break
        }
        saveSettings()
    }
}

global version := "", placeID := "", jobID := "", sList := [], whr := ComObject("WinHttp.WinHttpRequest.5.1")

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

getCurrent(update := true, getServers := true) {
    global placeID, jobID, sList, title, version
    done := false
    while(!done&&A_Index<20) {
        done := true
        try {
            arr := StrSplit(FileRead("files\info"),Chr(10))
            if(update&&(arr[2]!=placeID||arr[3]!=jobID)) {
                placeID := arr[2]=""? placeID:arr[2]
                jobID := arr[3]=""? jobID:arr[3]
                if(getServers) {
                    sList := getServers(placeID,jobID)
                }
            }
            version := arr[1]
        } catch as err {
            Sleep 50
            done := false
        }
    }
}

joinLink(place,job) {
    return "roblox://experiences/start?placeId=" place "&gameInstanceId=" job
}

GetProcessUser(PID) ;NOT WRITTEN BY ME! https://pastebin.com/fQDtXTrr
{
    CharSet := "UTF-16"
    TOKEN_QUERY := 0x0008
    PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
    
    hProcess := DllCall("OpenProcess", "uint", PROCESS_QUERY_LIMITED_INFORMATION, "int", 0, "uint", PID, "ptr")
    if !hProcess
        return "Access Denied"
    
    hToken := 0
    if !DllCall("advapi32.dll\OpenProcessToken", "ptr", hProcess, "uint", TOKEN_QUERY, "ptr*", &hToken)
    {
        DllCall("CloseHandle", "ptr", hProcess)
        return "Access Denied"
    }
    
    size := 0
    DllCall("advapi32.dll\GetTokenInformation", "ptr", hToken, "int", 1, "ptr", 0, "uint", 0, "uint*", &size)
    TOKENINFO := Buffer(size, 0)
    
    if !DllCall("advapi32.dll\GetTokenInformation", "ptr", hToken, "int", 1, "ptr", TOKENINFO, "uint", size, "uint*", &size)
    {
        DllCall("CloseHandle", "ptr", hToken)
        DllCall("CloseHandle", "ptr", hProcess)
        return "Access Denied"
    }
    
    pSID := NumGet(TOKENINFO, 0, "ptr")
    cchName := 260
    cchDomain := 260
    Name := Buffer(cchName * 2, 0)
    Domain := Buffer(cchDomain * 2, 0)
    peUse := 0
    
    if !DllCall("advapi32.dll\LookupAccountSidW", "ptr", 0, "ptr", pSID, "ptr", Name, "uint*", &cchName, "ptr", Domain, "uint*", &cchDomain, "uint*", &peUse)
    {
        user := "Unknown"
    }
    else
    {
        user := StrGet(Domain, CharSet) "\" StrGet(Name, CharSet)
    }
    
    DllCall("CloseHandle", "ptr", hToken)
    DllCall("CloseHandle", "ptr", hProcess)
    
    return SubStr(user,InStr(user,"\")+1) ;I only added this
}

serverHop() {
    global placeID, jobID, sList, title
    getCurrent()
    try {
        user := GetProcessUser(WinGetPID("Roblox"))
    } catch {
        user := A_UserName ,placeID := "", jobID := "", sList := []
    }
    if(user!=A_UserName) {
        MsgBox("YOU ARE USING THIS MACRO AS " A_UserName "`nBUT YOU ARE USING ROBLOX AS " user "`n`nYOU MUST USE THIS MACRO AND ROBLOX ON THE SAME USER FOR SERVERHOP, REJOIN AND FREEZE TOGGLE TO WORK!",title)
        return false
    }
    if(placeID!=""&&jobID!=""&&sList!=[]&&WinExist("Roblox")&&version!="") {
        closeRoblox()
        Run joinLink(placeID,sList[sList.Length])
        jobID := sList[sList.Length]
        sList.Pop()
        if(sList.Length = 0) {
            sList := getServers(placeID,jobID)
        }
        return true
    } else {
        MsgBox("YOU MUST JOIN A GAME FIRST FOR THIS TO WORK!",title)
    }
    return false
}

rejoin() {
    global placeID, jobID, title
    getCurrent()
    try {
        user := GetProcessUser(WinGetPID("Roblox"))
    } catch {
        user := A_UserName ,placeID := "", jobID := "", sList := []
    }
    if(user!=A_UserName) {
        MsgBox("YOU ARE USING THIS MACRO AS " A_UserName "`nBUT YOU ARE USING ROBLOX AS " user "`n`nYOU MUST USE THIS MACRO AND ROBLOX ON THE SAME USER FOR SERVERHOP, REJOIN AND FREEZE TOGGLE TO WORK!",title)
        return false
    }
    if(placeID!=""&&jobID!=""&&WinExist("Roblox")&&version!="") {
        closeRoblox()
        Run joinLink(placeID,jobID)
        return true
    } else {
        MsgBox("YOU MUST JOIN A GAME FIRST FOR THIS TO WORK!",title)
    }
    return false
}

join(place) {
    global title
    if(!WinExist("Roblox")) {
        MsgBox("YOU MUST START ROBLOX FOR THIS TO WORK!",title)
        return false
    }
    try {
        user := GetProcessUser(WinGetPID("Roblox"))
    }
    if(user!=A_UserName) {
        MsgBox("YOU ARE USING THIS MACRO AS " A_UserName "`nBUT YOU ARE USING ROBLOX AS " user "`n`nYOU MUST USE THIS MACRO AND ROBLOX ON THE SAME USER FOR SERVERHOP, REJOIN AND FREEZE TOGGLE TO WORK!",title)
        return false
    }
    closeRoblox()
    Run "roblox://experiences/start?placeId=" place
    return true
}

global scripts := [] ;INTERNAL FORMAT: script, compiled script, script name, keybind (this is prob gonna cause some bugs in the future)
global scriptMap := Map()
scriptMap.Default := []

fartArmyKeybind(ThisHotKey) {
    global scriptMap
    fartScript.execute(scriptMap[ThisHotKey],ThisHotKey)
}

getScriptList() {
    global scripts
    str := "scroll if you got too many scripts`n[ script number ] [ keybind ] [ name ] [ script ]`n`n"
    loop scripts.Length {
        oneLine := StrReplace(scripts[A_Index][1],Chr(10)," ")
        str .= "[ " A_Index " ] [ " translatekeybind(scripts[A_Index][4]) " ] [ " scripts[A_Index][3] " ] [ " SubStr(oneLine,1,30) (StrLen(oneLine)>=30? "...":"") " ]`n" 
    }
    return str
}

getScript(Index) {
    global scripts
    oneLine := StrReplace(scripts[index][1],Chr(10)," ")
    return "[ script number ] [ keybind ] [ name ] [ script ]`n[ " Index " ] [ " translatekeybind(scripts[Index][4]) " ] [ " scripts[Index][3] " ] [ " SubStr(oneLine,1,30) (StrLen(oneLine)>=30? "...":"") " ]" ;one line is superior
}

gcd(a, b) { ;https://en.wikipedia.org/wiki/Euclidean_algorithm
  while (b != 0) {
    temp := b
    b := Mod(a,b)
    a := temp
  }
  return a
}

*^!m:: {
    MouseGetPos &xpos, &ypos
    nX := xpos
    dW := A_ScreenWidth
    nY := ypos
    dH := A_ScreenHeight
    gcdX := gcd(nX,dW)
    gcdY := gcd(nY,dH)
    nX := nX // gcdX
    dW := dW // gcdX
    nY := nY // gcdY
    dH := dH // gcdY
    InputBox2("SCREEN COORDINATE SHOWN AS SCREEN HEIGHT AND WIDTH MULITPLIED BY A FRACTION!","(" fartScript.varChar "W" fartScript.varChar "*" nX "/" dW "," fartScript.varChar "H" fartScript.varChar "*" nY "/" dH ")",false)
}

fartArmyScriptList() {
    global scripts, title, keymap, scriptMap, restart
    while true {
        switch InputBox2("CHOOSE ACTION:`n`n1. FART ARMY SCRIPTING TUTORIAL`n2. ADD SCRIPT`n3. EDIT SCRIPT`n4. REMOVE SCRIPT`n5. VIEW SCRIPTS","",false) {
            case 1:
                try {
                    Run "files\macro\docs\index.html"
                } catch {
                    MsgBox("YOU DONT HAVE FART ARMY SCRIPTING TUTORIAL!",title)
                }
            case 2:
                errorLevel := true
                script := fartScript.compile(MultiLineInputBox("TYPE THE FART ARMY SCRIPT!","T(hello world!)",&errorLevel,true),errorLevel)
                if(!errorLevel) {
                    goto addExit
                }
                script.Push(InputBox3(&errorLevel,"WHAT WILL YOU NAME THIS SCRIPT?","",false))
                if(!errorLevel) {
                    goto addExit
                }
                script.Push(CreateKeybind("","CHOOSE KEYBIND FOR THIS MACRO SCRIPT"))
                keymap[script[4]] := true
                scripts.Push(script)
                scriptMap[script[4]] := script[2]
                Hotkey(script[4],fartArmyKeybind,"On")
                saveSettings()
                addExit: 
            case 3:
                action := InputBox2("CHOOSE THE SCRIPT YOU WANT TO EDIT BY TYPING THE SCRIPT NUMBER`n`n" getScriptList(),"",false,A_ScreenHeight*0.6)
                try {
                    while true {
                        if(action>=1&&action<=scripts.Length&&scripts.Length!=0) {
                            switch(InputBox2(getScript(action) "`n`nCHOOSE EDIT ACTION BY TYPING THE NUMBER:`n1. edit keybind`n2. edit name`n3. edit script","",false)) {
                                case 3:
                                    arr := fartScript.compile(MultiLineInputBox("EDIT SCRIPT",scripts[action][1]),true)
                                    scripts[action][1] := arr[1]
                                    scripts[action][2] := arr[2]
                                    scriptMap[scripts[action][4]] := scripts[action][2]
                                    saveSettings()
                                case 2:
                                    scripts[action][3] := InputBox2("EDIT NAME",scripts[action][3],false)
                                    saveSettings()
                                case 1:
                                    keymap[scripts[action][4]] := false
                                    Hotkey(scripts[action][4],"Off")
                                    scriptMap.Delete(scripts[action][4])
                                    scripts[action][4] := CreateKeybind(scripts[action][4],"CHOOSE THE NEW KEYBIND")
                                    keymap[scripts[action][4]] := true
                                    Hotkey(scripts[action][4],fartArmyKeybind,"On")
                                    scriptMap[scripts[action][4]] := scripts[action][2]
                                    saveSettings()
                                default:
                                    break
                            }
                        }
                    }
                }
            case 4:
                action := InputBox2("CHOOSE THE SCRIPT YOU WANT TO REMOVE BY TYPING THE SCRIPT NUMBER`n`n" getScriptList(),"",false,A_ScreenHeight*0.6)
                if(MsgBox(getScript(action) "`n`nare you sure you want to remove this script?",title,"YesNo")="Yes") {
                    try {
                        keymap[scripts[action][4]] := false
                        scriptMap.Delete(scripts[action][4])
                        Hotkey(scripts[action][4],"Off")
                        scriptMap[scripts[action][4]] := []
                        scripts.RemoveAt(action)
                    }
                }
                saveSettings()
            case 5:
                InputBox2(getScriptList(),"",false,A_ScreenHeight*0.6)
            default:
                break
        }
    }
}



;*^!r::Reload() ;used in development

serverInfo() {
    getCurrent(true,false)
    global jobID, placeID, title
    if(jobID=""||placeID="") {
        MsgBox("you need to join a game for this to work",title)
        return
    }
    MultiLineInputBox("CURRENT SERVER INFO","placeID: " placeID "`njobID: " jobID "`njoinLink: " joinLink(placeID,jobID))
}

AlzemuCopyPaste() {
    Run "files\LPI COPY LIST\index.html"
}

global cfunc := [toolbar,speed,autoc,ckeySmasher,cautochat,clagSwitch,CustomizeKeybinds,rejoin,serverHop,serverInfo,AlzemuCopyPaste,fartArmyScriptList]

customizeMenu() {
    choose := "."
    global cfunc, title
    while(choose!="") {
        checkReader()
        choose := InputBox("TYPE THE NUMBER TO CHOOSE CUSTOMIZATION:`n1. customize toolbar macro`n2. customize speed macro`n3. customize autoclicker`n4. customize key smasher macro`n5. customize auto chat`n6. customize lag switch`n`n7. customize keybinds`n`n`nTYPE THE NUMBER TO CHOOSE ACTION:`n8. rejoin`n9. serverhop`n10. current server info`n11. COPY PASTE TOOL`n12. LPI FART ARMY SCRIPTS`n`n`npress cancel to go back",title,'H' A_ScreenHeight/2.5).Value
        try {
            cfunc[choose]() ;very similar to switch indeed
        }
    }
    return true
}

translatekeybind(input) { ;making keybinds readable
    return StrUpper(StrReplace(StrReplace(SubStr(input,2),"!","ALT "),"^","CTRL "))
}

CreateKeybind(original,msg := "") { ;ternary operators everywhere! hooray!
    global keymap, title
    overUsedGotos: ;NO RECURSION! FUCK YOU RECURSION! I WONT USE IT!
    keybind := ""
    char := ""
    enter := 0
    alt := false, ctrl := false, guard := false
    translatedOriginal := translatekeybind(original)
    inMsg := "`n`npress alt to toggle on/off alt`npress ctrl to toggle on/off ctrl`n`nyou must select a number or character`nduplicate keybinds are not allowed`nsingle character/number keybinds are not allowed`nyou must choose a keybind that includes alt or ctrl or both"
    ToolTip((msg!=""?msg "`n`n":"") (original=""? "":"old keybind: " translatedOriginal "`n") "new keybind:" inMsg,A_ScreenWidth/2,A_ScreenHeight/2)
    while(enter<3) {
        key := waitForKey()
        switch(key) {
            case "RControl","LControl":
                enter := 0
                ctrl := !ctrl
            case "LAlt","RAlt":
                enter := 0
                alt := !alt
            case "Enter":
                if(guard) {
                    enter++
                }
            default:
                enter := 0
                code := Ord(key)
                if(StrLen(key)=1&&((code>=48&&code<=57)||(code>=65&&code<=90)||(code>=97&&code<=122))) {
                    char := ((key=char)?"":StrLower(key))
                }
        }
        guard := char!=""&&(ctrl||alt)
        keybind := "*" (ctrl?"^":"") (alt?"!":"") char
        dupe := keymap[keybind]&&keybind!=original
        enter *= !dupe
        ToolTip((msg!=""?msg "`n`n":"") (original=""? "":"old keybind: " translatedOriginal "`n") "new keybind: " translatekeybind(keybind) (dupe?"`nDUPLICATE KEYBIND! TRY SOMETHING ELSE!`n":"") (enter>0?"`n`n" enter "/3 enter":(guard&&!dupe?"`n`npress enter 3 times to confirm keybind":"")) inMsg,A_ScreenWidth/2,A_ScreenHeight/2)
        while GetKeyState(key,"P") {
            Sleep 10
        }
    }
    Sleep 250
    ToolTip()
    return keybind
}

global KeyBinds := [
    "*!z", ;toolbar
    "*!x", ;speed
    "*!c", ;autoclicker
    "*!v", ;key smasher
    "*!f", ;freeze toggle
    "*!q", ;auto chat
    "*!l", ;lag switch
    "*^!b" ;skybox macro
]

global keybindsm := [ ;match
    toolbarm,
    speedm,
    autoclick,
    keySmasher,
    freezetoggle,
    autochat,
    lagSwitch,
    skyboxm
]

global keymap := Map() ;map for checking if duplicate keybinds
keymap.Default := false
keymap["*^!m"] := true
keymap["*^!e"] := true
keymap["*^!r"] := true
CustomizeKeybinds() {
    global KeyBinds, keybindsm, keymap, title
    while(true) {
        try {
            opt := Integer(InputBox("CHOOSE WHAT MACRO KEYBIND TO CUSTOMIZE!`n`n1. toolbar macro: " translatekeybind(KeyBinds[1]) "`n2. speed macro: " translatekeybind(KeyBinds[2]) "`n3. autoclicker: " translatekeybind(KeyBinds[3]) "`n4. key smasher: " translatekeybind(KeyBinds[4]) "`n5. freeze toggle: " translatekeybind(KeyBinds[5]) "`n6. auto chat: " translatekeybind(KeyBinds[6]) "`n7. lag switch: " translatekeybind(KeyBinds[7]) "`n8. skybox macro: " translatekeybind(KeyBinds[8]) "`n`nPRESS CANCEL WHEN YOU ARE DONE!",title,"H" A_ScreenHeight/3).Value)
            keybind := CreateKeybind(KeyBinds[opt])
            keymap[KeyBinds[opt]] := false
            Hotkey(KeyBinds[opt],"Off")
            KeyBinds[opt] := keybind
            keymap[keybind] := true
            Hotkey(KeyBinds[opt],keybindsm[opt],"On")
            saveSettings()
        } catch {
            break ;best method ever
        }
    }
}

global restart := false
if(!FileExist("files\settings") || FileRead("files\settings")="") {
    saveSettings()
}
loadSettings()

if(!restart) {
    MsgBox("THIS MACRO IS EXPECTED TO BE USED LIKE THIS:`n`ncamera mode: CLASSIC`n`nNORMAL ROBLOX!`nthis means no bloxstrap or anything like that!`n`nthis macro was made in LPI (lets party infinite)`n`nIF YOU DONT DO THIS THEN THIS MACRO WONT WORK AS EXPECTED!",title)
} else {
    restart := false
    saveSettings()
}
while(MsgBox("YOU CAN PRESS SOMEWHERE ELSE TO HIDE THIS!`n`n`nuse toolbar macro: " translatekeybind(KeyBinds[1]) "`nSTART: " tmin ", END: " tmax ", KEYS: `"" tmash "`", MODE: " (tmode? "FULL AUTO, DELAY: " delay "ms":"SEMI AUTO") "`n`nspeed macro: " translatekeybind(KeyBinds[2]) "`nWASD: `"" keys "`",FPS: " fps ", PIXELS: " x ", DIRECTION: " (sdir?"NORMAL":"REVERSE") "`nYOU CAN DO AUTO SETUP IF YOU WANT FASTER SPEED MACRO!`n`nautoclicker: " translatekeybind(KeyBinds[3]) "`nCPS: " Round(mt[1]*(1000/mt[2])) ", MODE: " (cmode? "HOLD":"TOGGLE") "`n`nkey smasher macro: " translatekeybind(KeyBinds[4]) "`nKEYS: `"" smashKeys "`", TIMES: " smashTimes "`n`nfreeze toggle: " translatekeybind(KeyBinds[5]) "`n`nauto chat: " translatekeybind(KeyBinds[6]) "`nMESSAGE: `"" msg "`", CHATKEY: `"" chatKey "`", MODE: " (chatMode=1?"HOLD SPAM":chatMode=2?"ONCE":"TOGGLE SPAM") (chatMode!=2?", MPS: " MPS:"") "`n`nlag switch: " translatekeybind(KeyBinds[7]) "`nMAX TIME: " ltime " seconds`nlag switch might look like exploits from others POV`nuse it with caution because it might get you banned`n`nskybox macro: " translatekeybind(KeyBinds[8]) "`n`n`npress OK to customize the macros or for more tools`npress cancel to exit this macro",title,"OKCancel")="OK"? customizeMenu():(ExitApp())) {
    checkEnviroment()
}


;NOT WRITTEN BY ME!
eval(e,test:=false) { ;https://github.com/TheArkive/eval_ahk2
    
    nothrow := false
    If test="nothrow"
        nothrow := true, test:=false
    
    e := RegExReplace(e,"(!|~)[ \t]+","$1")
    
    If (test And Trim(e,"`t ") = "")
        return false
    Else If (test) {
        t1 := !RegExMatch(Trim(e),"i)(^[^\d!~\-\x28 ]|! |~ |[g-wyz]+|['\" . '"\$@#%\{\}\[\]\\,;\``_])') ; only return true/false testing "e" as expression
        t2 := ( !InStr(e,"++") && !InStr(e,"--"))
        t3 := !RegExMatch(e,"i)(?<![a-f\dx])[a-f]")
        t4a := !RegExMatch(e,"i)(?<!0)x")
        t4b := !RegExMatch(e,"i)x(?![a-f\d])")
        t4 := (t4a || t4b)
        
        StrReplace(e,"?","?",,&q) ; count question marks
        StrReplace(e,":",":",,&c) ; count colons
        t5 := (q=c)
        
        return (t1 && t2 && t3 && t4 && t5)
    }
    
    If RegExMatch(e,"i)(! |~ |[g-wyz]+|['\" . '"\$@#%\{\}\[\]\\,;\``_])',&m) ; check for invalid characters, non-numbers, invalid punctuation, etc.
        throw Error("Syntax error.`r`n     Reason: " Chr(34) m[1] Chr(34) "`r`n`r`nExpression: " e,-1,"Not a math expression.")
    
    If ( InStr(e,"++") || InStr(e,"--") )
        throw Error("Syntax error.`r`n     Reason: -- and ++ are not valid.",-1,"Not a math expression.")
    
    StrReplace(e,"?","?",,&q) ; count question marks
    StrReplace(e,":",":",,&c) ; count colons
    If (q!=c)
        throw Error("Syntax error.`r`n     Reason: ternary statement must be complete with question mark (?) and colon (:).",-1)
    
    StrReplace(e,"(","(",,&LP), StrReplace(e,")",")",,&RP)
    If (LP != RP)
        throw Error("Invalid grouping with parenthesis.  You must ensure the same number of ( and ) exist in the expression.`r`n`r`nExpression:`r`n    " e,-1)
    
    e := RegExReplace(e,'(?<!\d)\.','0.')                               ; fix instances of decimal without leading integer
    
    While RegExMatch(e, "i)(\x28[^\x28\x29]+\x29)", &m) {               ; match phrase surrounded by parenthesis, inner-most first
        ans := _eval(match := m[0])                                     ; match and calculate result
        ans := (SubStr(ans,1,1) = "-") ? " " ans : ans                  ; resolved sub-expr value, add space for legit negative sign, ie. " -3"
        e := RegExReplace(StrReplace(e,match,ans,,,1),"(!|~) +","$1")   ; perform substitution, remove resulting spaces between !/~ and resolved value
        
        If e="inf"
            Break
    }
    
    If e!="inf"
        e := _eval(e)
    
    If IsInteger(e)
        return Integer(e)
    Else if (e="inf") && nothrow
        return e
    Else if (e="inf")
        throw Error("Number too large.",-1)
    Else
        return Float(e)
}

_eval(e) { ; support function for pure math expression without parenthesis
    If IsNumber(e)
        return e
    
    If RegExMatch(e,"i)(^[^\d!~\-\x28 ]|! |~ |[g-wyz]+|['\" . '"\$@#%\{\}\[\]\\,;\``_])',&m) ; check for invalid characters, non-numbers, invalid punctuation, etc.
        throw Error("Syntax error.`r`n     Reason: " Chr(34) m[1] Chr(34),-1,"Not a math expression.")
    
    Static _n   := "(?:\d+\.\d+(?:e\+\d+|e\-\d+|e\d+)?|0x[\dA-F]+|\d+)"  ; Regex to identify float/scientific notation, then hex, then base-10 numbers.  Only positive.
    Static _num := "([!~\-]*" _n ")"                                   ; Expand number definition to include - / ~ / !
    Static _ops := "(?:\*\*|\*|//|/|\+|\-|>>>|<<|>>|&&|&|\^|"            ; Define list of operators, in order of prescedence.
                 . "\|\|" . "|" . "\|" . "|" . ">=|<=|>|<|!=|==|=|\?|:)"
    
    new_e := "", p := 1, prev_m := ""
    typ := "number", expr := _num           ; Start looking for a number first.
    
    While RegExMatch(e,"i)" expr,&_m,p) {   ; Separate numbers and operators (except !/~ operators) with spaces.
        mat := _m[0]                        ; Capture match pattern.  Pattern starts with "number" / alternates with "oper".
        If (typ="number") {                 ; Alternate the RegEx search between numbers and operators to improve grouping/spacing of the expression.
            mat := RegExReplace(_m[1],"\-(\d+)","#$1") ; find "negative" values, replace "-" with "#"
            typ   := "oper"
            expr  := _ops
        } Else {
            typ  := "number"
            expr := _num
        }
        
        new_e .= ((new_e!="")?" ":"") mat
        p := _m.Pos(0) + _m.Len(0)
    }
    
    e := RegExReplace(new_e," {2,}"," ")                        ; Replace e with spaced-out/grouped expression, and replace multiple spaces with single space.
    old_e := e
    
    Static order := "** !~ */ +- <> &^| >= == && ?:"            ; Order of operations with appropriate grouping.
    Static opers := StrSplit(order," ")
    Static n := "#?" _n                                         ; Basic number defiintion with # in place - for negative numbers.
    
    For i, op in opers {                                        ; Loop through operators in order of prescedence.
        
        If e="inf"
            return e
        
        Switch op {
            
            Case "**":
                
                val2 := "", i_count := 0 ; just in case...
                sub_e := "", new_sub_e := ""                    ; Initialize temp vars for the building of sub-expressions.
                p := 1                                          ; Position tracking.
                fail_count := 0                                 ; These expressions can be broken up in different sections in the main expression, so track search fails.
                Static rg_ex1 := "([#!~\-]*" _n ")( *\*\* *)"   ; RegEx for number and exponent (**).  For 1st iteration in next WHILE loop.
                Static rg_ex2 := "([#!~\-]*" _n ")( *\*\* *)?"  ; RegEx for number and maybe exponent (**) for 2nd+ iteration in next WHILE loop.
                rg_ex := rg_ex1
                
                While (r := RegExMatch(e,"i)" rg_ex,&z,p)) {    ; Extract expr before resolving, because this needs to be right-to-left.
                    (z[2] = "") ? fail_count++ : ""             ; Increment fail count when "**" not found.  fail_count = 1 means the end of a sub-expr, but there may be more.
                    p := z.Pos(0) + z.Len(0)                    ; Adjust search position.
                    sub_e .= z[0]                               ; Append valid match to sub_e.
                    
                    If (fail_count = 1 And InStr(sub_e,"**")) { ; ****** End of exponenent expression, so evalute and replace. ******
                        new_sub_e := sub_e
                        While RegExMatch(new_sub_e,"i)([#!~]*)?(" _n ") *(\*\*) *([#!~\-]*" _n ")$",&y) { ; Get last 2 operands and operator with any unary - ! or ~.
                            mat := y[0]                          ; Capture full match.
                            o_op := y[1]                         ; Outside operators must be solved last, ie. -2 ** 3 is -(2 ** 3).
                            v1 := y[2]                           ; First operand.
                            v2 := StrReplace(y[4],"#","-")       ; Switch "#" to "-"
                            v2 := _eval(v2)                      ; Evaluate the exponent (2nd operand), resolve all ! and ~ first.  This behavior is undocumented in AHK v2.
                            val2 := v1 ** v2                     ; Resolve sub-sub-expression.
                            new_sub_e := RegExReplace(new_sub_e,"\Q" mat "\E$",o_op val2) ; Ensure this substitution only happens at the end of the sub-expression.
                        }
                        
                        RegExMatch(val2,"([\-!~]*)?(" _n ")",&y) ; Check for "-" to convert to "#".
                        If (IsObject(y) And InStr(y[1],"-"))
                            val2 := StrReplace(y[1],"-","#") y[2]
                        e := StrReplace(e,sub_e,new_sub_e,,,1)  ; Replace only the first instance of the match.  Maintain "#" sub for "-".
                        sub_e := "", new_sub_e := ""            ; Reset temp vars / sub-expressions.  
                        p := 1, fail_count := 0                 ; Reset postion tracking and fail_count.  Continue looping for another exponent sub-expression.
                        
                    } Else If (fail_count > 1)                  ; No more exponent expressions to evaluate, so Break.
                        Break
                    
                    (A_Index = 1) ? rg_ex := rg_ex2 : ""        ; Switch to new search right before 2nd iteration.
                }
                
            Case "!~":
                
                While (r := RegExMatch(e,"i)(!|\~)" n,&z)) {    ; Find "inner most" expression and solve first.
                    _op  := z[1]
                    _mat := z[0]
                    v1 := StrReplace(SubStr(_mat,2),"#","-")    ; Omit regex stored operator (! or ~) and convert "#" to "-".
                    
                    If (_op = "!")
                        val2 := !v1
                    Else If (_op = "~") {
                        If !IsInteger(v1)
                            throw Error("Bitwise NOT (~) operator against non-integer value.`r`n     Invalid operation: ~" v1,-1,"Bitwise operation with non-integer.")
                        v1 := Integer(v1)
                        val2 := ~v1
                    } Else
                        throw Error("Unexpected error in NOT (! / ~) expression.",-1,"First char is not ! or ~.`r`n`r`n     Sub-Expression: " _mat)
                    
                    e := StrReplace(e,_mat,StrReplace(val2,"-","#"),,,1) ; Substitute resolved value in main expression.
                    e := RegExReplace(e,"\-(\d+)","#$1")
                    e := RegExReplace(e,"\-#","")                ; The only time a double negative "--" won't throw an error, so "##" will cancel itself out.
                }
                
            Default: ; basic left-to-right operations that need to be grouped together
                    Switch op {
                        Case "*/":  op_reg := "\*|//|/"
                        Case "+-":  op_reg := "\+|\-"
                        Case "<>":  op_reg := ">>>|<<|>>"
                        Case "&^|": op_reg := "\&|\^|\|"
                        Case ">=":  op_reg := ">\=|<\=|>|<"
                        Case "==":  op_reg := "!=|==|="
                        Case "&&":  op_reg := "&&" . "|" . "\|\|" ; && then ||
                        Case "?:":
                            If !(q := InStr(e,"?"))
                                Continue
                            c := InStr(e,":")
                            expr := StrReplace(SubStr(e,1,q-1),"#","-")
                            expr := _eval(expr)
                            res_A := SubStr(e,q+1,c-q-1)
                            res_B := SubStr(e,c+1)
                            e := (expr) ? Trim(res_A) : Trim(res_B)
                            Continue
                    }
                    
                    While (r := RegExMatch(e,"i)(" n ") +(" op_reg ") +(" n ")",&z)) {
                        o := z[2]
                        v1 := StrReplace(z[1],"#","-"), v2 := StrReplace(z[3],"#","-")
                        
                        ; =========================================================
                        ; capture operator-specific errors
                        ; =========================================================
                        If (o = "<<" Or o = ">>") And (!IsInteger(v1) Or !IsInteger(v2) Or v2<0) ; check for invalid expressions
                            throw Error("Invalid expression.`r`n     Expr: " v1 " " o " " v2,-1,"Bit shift with non-integers.")
                        If (o = "/" Or o = "//") And v2=0
                            throw Error("Invalid expression.`r`n     Expr: " v1 " " o " " v2,-1,"Divide by zero.")
                        If (o = "//") And (!IsInteger(v1) Or !IsInteger(v2))
                            throw Error("Invalid expression.`r`n     Expr: " v1 " " o " " v2,-1,"Floor division with non-integer divisor.")
                        If (o = "&" Or o = "^" Or o = "|") And (!IsInteger(v1) Or !IsInteger(v2))
                            throw Error("Invalid expression.`r`n     Expr: " v1 " " o " " v2,-1,"Bitwise operation with non-integers.")
                        
                        (IsFloat(v1)) ? v1 := Float(v1) : (IsInteger(v1)) ? v1 := Integer(v1) : ""
                        (IsFloat(v2)) ? v2 := Float(v2) : (IsInteger(v2)) ? v2 := Integer(v2) : ""
                        
                        Switch o {
                            Case "*":   val2 := v1  *  v2
                            Case "//":  val2 := v1 //  v2
                            Case "/":   val2 := v1  /  v2
                            Case "+":   val2 := v1  +  v2
                            Case "-":   val2 := v1  -  v2
                            Case ">>>": val2 := v1 >>> v2
                            Case "<<":  val2 := v1 <<  v2
                            Case ">>":  val2 := v1 >>  v2
                            Case "&":   val2 := v1  &  v2
                            Case "^":   val2 := v1  ^  v2
                            Case "|":   val2 := v1  |  v2
                            Case ">=":  val2 := v1 >=  v2
                            Case "<=":  val2 := v1 <=  v2
                            Case ">":   val2 := v1  >  v2
                            Case "<":   val2 := v1  <  v2
                            Case "!=":  val2 := v1 !=  v2
                            Case "==":  val2 := v1 ==  v2
                            Case "=":   val2 := v1  =  v2
                            Case "&&":  val2 := v1 &&  v2
                            Case "||":  val2 := v1 ||  v2
                        }
                        
                        e := StrReplace(e,z[0],StrReplace(val2,"-","#"),,,1)
                    }
                    r := 0 ; disable substitution before next iteration in FOR loop, because these subs were already done
        }
        
        If IsNumber(StrReplace(e,"#","-"))
            Break
    }
    
    e := StrReplace(e,"#","-")
    If IsNumber(StrReplace(e,"#","-")) {
        final := StrReplace(e,"#","-")
        If IsInteger(final)
            return Integer(final)
        Else If IsFloat(final)
            return Float(final)
        Else
            throw Error("fix this type: " Type(final),-1) ; this isn't supposed to be here, but just in case there's some weird type conflict, please tell me and post example.
    } Else {
        return e
    }
}
