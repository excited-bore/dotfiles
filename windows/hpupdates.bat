@echo off
winget install --id HP.ImageAssistant --silent --accept-package-agreements --accept-source-agreements
"C:\SWSetup\HPImageAssistant\HPImageAssistant.exe" /Action:Install /AutoCleanup /Category:BIOS,Drivers,Firmware /Silent
