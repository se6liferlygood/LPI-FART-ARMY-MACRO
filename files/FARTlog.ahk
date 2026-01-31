#Requires AutoHotkey v2.0
#SingleInstance Force
;CoordMode("ToolTip","Screen")
SetTitleMatchMode(3)

global users := [] ;all users roblox directories needs to get checked in case running as admin changes what user they run the macro as (otherwise there would be problems)

loop files, "C:\*.*", "D" {
    try {
        test := A_LoopFilePath "\Roblox\logs\"
        if(DirExist(test)) {
            try {
                code := Random()
                FileAppend("",test code)
                FileDelete(test code)
                users.Push(test)
            }
        }
    }
}

loop files, "C:\Users\*.*", "D" {
    try {
        test := A_LoopFilePath "\AppData\Local\Roblox\logs\"
        if(DirExist(test)) {
            try {
                code := Random()
                FileAppend("",test code)
                FileDelete(test code)
                users.Push(test)
            }
        }
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

try {
    FileDelete("info")
}
FileAppend("","info")

try {
    getLogFile()
} catch {
    ExitApp() ;yeah the user wont be able to serverhop or rejoin or lag switch if this is the case
}

SleepEx(Milliseconds) { ;THIS FUNCTION IS NOT WRITTEN BY ME! credits go to https://www.reddit.com/r/AutoHotkey/comments/11g0san/need_help_with_my_dllcall/
    static tps := _tps(), start := 0, current := 0
    DllCall("QueryPerformanceCounter", "Int64*", &start)
    end := start + (Milliseconds * tps)
    loop {
        DllCall("QueryPerformanceCounter", "Int64*", &current)
    } until (current >= end)
    _tps() {
        freq := 0
        DllCall("QueryPerformanceFrequency", "Int64*", &freq)
        return freq //= 1000
    }
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
        } else if(InStr(rline,"[FLog::UpdateController] WindowsUpdateController: updaterFullPath: ") > 0) {
            version := StrReplace(SubStr(rline,67+InStr(rline,"[FLog::UpdateController] WindowsUpdateController: updaterFullPath: ")),"\RobloxPlayerInstaller.exe","\")
            update := true
        } else if(InStr(rline,"[FLog::UpdateController] Checking if updater exists at")) {
            version := SubStr(rline,1,InStr(rline,"RobloxPlayerInstaller.exe")-1)
            version := StrReplace(SubStr(version,InStr(version,"C:\")),"\RobloxPlayerInstaller.exe")
            update := true
        } else if(placeID="126647205032462"&&InStr(rline,"ANGLE",1)&&FileExist("speedY")) {
            str := SubStr(rline,InStr(rline,"ANGLE(")+6)
            str := SubStr(str,1,InStr(str,")")-1)
            ;try {
                angle := Number(str)
                redo2:
                try {
                    FileAppend(angle " ","speedY")
                } catch {
                    Sleep 50
                    goto redo2
                }
                ;ToolTip("" angle,A_ScreenWidth/2,A_ScreenHeight/2+20)
            ;}
        }
        while(lcurrent >= lsize) {
            lcurrent := lsize
            lsize := FileGetSize(logPath)
            if(update) {
                try {
                    try {
                        FileDelete("info")
                    }
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
            if(placeID="126647205032462") {
                Sleep 10
            } else {
                Sleep 250
            }
        }
        if(seeking) {
            break
        }
    }
}
