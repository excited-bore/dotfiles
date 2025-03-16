; Define a hotkey (e.g., Win+L) to run lazygit.exe
#HotIf WinActive("ahk_class ConsoleWindowClass") or WinActive("ahk_exe WindowsTerminal.exe")
    ; The script will only work when the specified window is active.
    ; Replace 'Console' with the PowerShell class and 'Terminal' with the Windows Terminal class.

    F3:: ; Press F3 to run lazygit when either PowerShell or Windows Terminal is active
    { 
        SendInput "lazygit.exe{Enter}" 
    }

    return
#HotIf