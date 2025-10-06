#Requires AutoHotkey v2.0
#SingleInstance Force
;CoordMode("ToolTip","Screen")
SetTitleMatchMode(3)
ProcessSetPriority("H")

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
path := StrReplace(A_AppData,"\Roaming","\Local\Roblox\logs\*")
getLogFile() {
    global logPath := ""
    count := 0
    loop files path ".log" {
        if(InStr(A_LoopFileName,"_Player")>0) {
            try {
                FileDelete(A_LoopFilePath)
            } catch {
                logPath := A_LoopFilePath
                count++
            }
        }
    }
    return count
}
try {
    getLogFile()
} catch {
    ExitApp() ;yeah the user wont be able to serverhop or rejoin if this is the case
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
