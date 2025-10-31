@echo off
:: This batch file resets the CurrentUser execution policy

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Undefined -Force"

