@echo off
REM NoteGrit build - assembles src\notegrit.asm and src\installer.asm with FASM,
REM then packages both into a release ZIP. BSD-2 (see LICENSE).
setlocal enableextensions
set "ROOT=%~dp0"
set "FASM=%ROOT%tools\fasm\FASM.EXE"
set "INC=%ROOT%tools\fasm\INCLUDE"

if not exist "%FASM%" (
  echo [build] FASM not found: %FASM%
  echo [build] Get it from https://flatassembler.net ^(.zip^), extract to tools\fasm\
  exit /b 1
)

set "INCLUDE=%INC%"

echo [build] notegrit.exe
"%FASM%" "%ROOT%src\notegrit.asm" "%ROOT%notegrit.exe"
if errorlevel 1 ( echo [build] notegrit FAILED & exit /b 1 )

echo [build] Win_x86_64_Installer.exe
"%FASM%" "%ROOT%src\installer.asm" "%ROOT%Win_x86_64_Installer.exe"
if errorlevel 1 ( echo [build] installer FAILED & exit /b 1 )

echo [build] NoteGrit release ZIP
set "ZIP=%ROOT%Win_x86_64_Installer.zip"
set "PKG=%ROOT%NoteGrit_Installer"
if exist "%ZIP%" del "%ZIP%"
if exist "%PKG%" rmdir /s /q "%PKG%"
mkdir "%PKG%"
copy /Y "%ROOT%notegrit.exe" "%PKG%\" >nul
copy /Y "%ROOT%Win_x86_64_Installer.exe" "%PKG%\" >nul
powershell -NoProfile -Command "Compress-Archive -Path '%PKG%' -DestinationPath '%ZIP%'"
if errorlevel 1 ( echo [build] ZIP FAILED & exit /b 1 )
rmdir /s /q "%PKG%"

echo [build] ok -^> notegrit.exe + Win_x86_64_Installer.exe + Win_x86_64_Installer.zip
endlocal
