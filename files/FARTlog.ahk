#Requires AutoHotkey v2.0
#SingleInstance Force
;CoordMode("ToolTip","Screen")
SetTitleMatchMode(3)
ProcessSetPriority("H")

global users := [] ;all users roblox directories needs to get checked in case running as admin changes what user they run the macro as (otherwise there would be problems)

loop files, "C:\*.*", "D" {
    try {
        test := A_LoopFilePath "\Roblox\logs\"
        ;MsgBox(test)
        if(DirExist(test)) {
            try {
                code := Random()
                FileAppend("",test code)
                FileDelete(test code) ;hopefully  this will make so that it only adds if the macro has perms
                users.Push(test)
            }
        }
    }
}

loop files, "C:\Users\*.*", "D" {
    try {
        test := A_LoopFilePath "\AppData\Local\Roblox\logs\"
        ;MsgBox(test)
        if(DirExist(test)) {
            try {
                code := Random()
                FileAppend("",test code)
                FileDelete(test code) ;hopefully  this will make so that it only adds if the macro has perms
                users.Push(test)
                ;MsgBox("EXISTS " test)
            }
        }
    } catch as err {
        ;MsgBox(err.Message)
    }
}

ahkExist(ahkFile) {
    prevDetectHiddenWindows := A_DetectHiddenWindows, prevTitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows(true), SetTitleMatchMode(2) ;2 is default
    exists := WinExist(ahkFile " ahk_class AutoHotkey")
    DetectHiddenWindows(prevDetectHiddenWindows), SetTitleMatchMode(prevTitleMatchMode)
    return exists
}

exits(a:=0,b:=0) {
    done := false
    while(!done&&A_Index<20) {
        done := true
        try {
            FileDelete("info")
            FileAppend("","info")
        } catch {
            done := false
            Sleep 50
        }
    }
    ExitApp()
}

OnExit(exits)

checkMain() {
    if(!ahkExist("FART ARMY MACRO.ahk")) {
        exits()
    }
}

global version := "", placeID := "", jobID := "", logPath := ""
getLogFile() {
    global logPath := "", users
    count := 0
    loop users.Length {
        path := users[A_Index]
        loop files path "*.log" {
            if(InStr(A_LoopFileName,"_Player")>0) {
                try {
                    FileDelete(A_LoopFilePath)
                } catch as err {
                    logPath := A_LoopFilePath
                    count++
                }
            }
        }
    }
    return count
}

FileDelete("info")
FileAppend("","info")

try {
    getLogFile()
} catch {
    ExitApp() ;yeah the user wont be able to serverhop or rejoin or lag switch if this is the case
}

while(true) {
    redo:
    while(logPath = "") {
        checkMain()
        getLogFile()
        ;ToolTip("LOOKING FOR LOG",0,0)
        Sleep 100
    }
    try {
        lsize := FileGetSize(logPath)
    } catch {
        goto redo
    }
    lcurrent := 0
    seeking := false
    update := false
    loop read logPath {
        rline := A_LoopReadLine
        lcurrent += StrLen(A_LoopReadLine) + 2
        if(InStr(rline,"[FLog::Output] ! Joining game") > 0) {
            str := SubStr(rline,InStr(rline,"'")+1)
            str := SubStr(str,1,InStr(str,"'")-1)
            jobID := str
            str := SubStr(rline,InStr(rline," place ")+7)
            str := SubStr(str,1,InStr(str," at ")-1)
            placeID := str
            update := true
        } else if(A_Index<10) {
            if(InStr(rline,"[FLog::UpdateController] WindowsUpdateController: updaterFullPath: ") > 0) {
                version := StrReplace(SubStr(rline,67+InStr(rline,"[FLog::UpdateController] WindowsUpdateController: updaterFullPath: ")),"\RobloxPlayerInstaller.exe","\")
                update := true
            }
        }
        while(lcurrent >= lsize) {
            lcurrent := lsize
            lsize := FileGetSize(logPath)
            if(update) {
                try {
                    FileDelete("info")
                    FileAppend(version "`n" placeID "`n" jobID,"info")
                    update := false
                    ;ToolTip(FileRead("info"),0,0)
                }
            }
            checkMain()
            if(getLogFile() != 1) {
                seeking := true
                break
            }
            Sleep 100
        }
        if(seeking) {
            break
        }
    }
}
