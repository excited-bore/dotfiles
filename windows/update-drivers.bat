@echo off
setlocal enabledelayedexpansion

:: Get manufacturer
for /f "skip=1 tokens=*" %%M in ('wmic computersystem get manufacturer') do (
    set "manufacturer=%%M"
    goto :gotManu
)
:gotManu

:: Trim trailing spaces
call :TrimTrailing "%manufacturer%" manufacturer

echo Manufacturer: '%manufacturer%'

if /i "%manufacturer%"=="HP" set HP=1
if /i "%manufacturer%"=="Hewlett-Packard" set HP=1

if /i "%manufacturer%"=="Dell Inc." (
    echo This is a Dell system.
) else if defined HP (
    echo This is a HP system.
) else if /i "%manufacturer%"=="LENOVO" (
    echo This is a Lenovo system.
) else if /i "%manufacturer%"=="ASUSTeK COMPUTER INC." (
    echo This is an ASUS system.
) else if /i "%manufacturer%"=="Acer" (
    echo This is an Acer system.
) else if /i "%manufacturer%"=="Gigabyte Technology Co., Ltd." (
    echo This is a Gigabyte system.
) else (
    echo Unknown system.
)

pause
exit /b

:: -----------------------
:: Subroutine: Trim trailing spaces from variables (f.ex. for gigabyte, 'wmic computersystem get manufacturer' would give us "Gigabyte Technology Co., Ltd.  ")
:: -----------------------
:TrimTrailing
:: Get first argument
:: The '~' removes potential quotes ("My argument" becomes My argument)
set "str=%~1"
:loop
if not "%str:~-1%"==" " goto trimDone
set "str=%str:~0,-1%"
goto loop
:trimDone
set "%2=%str%"
exit /b
