@echo off
winget install --id Dell.CommandUpdate --silent --accept-package-agreements --accept-source-agreements
"C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" /scan
"C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe" /applyupdates
