@echo off
:: This batch file sets the CurrentUser execution policy to Bypass

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force"