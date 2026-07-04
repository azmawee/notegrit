@echo off
REM Tiny Classic Notepad launcher - auto-elevating wrapper for install.ps1. BSD-2 (see LICENSE).
setlocal enableextensions
set "ROOT=%~dp0"
set "PS1=%ROOT%install.ps1"

net session >nul 2>&1
if errorlevel 1 (
  echo [install] Administrator rights required. Re-launching elevated...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

if not exist "%PS1%" (
  echo [install] install.ps1 not found next to this file: %PS1%
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
endlocal
