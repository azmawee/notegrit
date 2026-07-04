# Tiny Classic Notepad launcher - IFEO default-Notepad installer (Windows 10/11). BSD-2 (see LICENSE).
#Requires -RunAsAdministrator
$ErrorActionPreference = 'Stop'

# ---- paths ----
$InstallDir = Join-Path $env:ProgramFiles 'TinyClassicNotepad'
$BackupDir  = Join-Path $InstallDir 'backup'
$LogFile    = Join-Path $BackupDir 'install.log'
$EditorSrc  = Join-Path $PSScriptRoot '..\notepad.exe'   # next to src\, built by build.bat
$EditorDst  = Join-Path $InstallDir 'notepad.exe'
$IfeoKey    = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe'
$OrigPaths  = @("$env:WINDIR\System32\notepad.exe", "$env:WINDIR\SysWOW64\notepad.exe")

function Write-Log($msg) {
    $line = "{0}  {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
    if (-not (Test-Path $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null }
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
    Write-Host $line
}

function Get-WinVersion {
    $build = 0
    try { $b = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction Stop).CurrentBuild
          [int]$build = [int]$b } catch {}
    $ver = [System.Environment]::OSVersion.Version
    if ($build -ge 22000) { return @{ Label = 'Windows 11'; Build = $build; Ver = $ver } }
    if ($build -ge 10240) { return @{ Label = 'Windows 10'; Build = $build; Ver = $ver } }
    return @{ Label = 'Windows (older than 10)'; Build = $build; Ver = $ver }
}

function Get-InstallState {
    if (Test-Path $IfeoKey) {
        $d = (Get-ItemProperty $IfeoKey -ErrorAction SilentlyContinue).Debugger
        if ($d) { return "INSTALLED (IFEO Debugger = $d)" }
    }
    return 'NOT INSTALLED'
}

function Backup-Originals {
    foreach ($p in $OrigPaths) {
        if (Test-Path $p) {
            $tag = if ($p -match 'SysWOW64') { 'SysWOW64' } else { 'System32' }
            $dst = Join-Path $BackupDir ("{0}_notepad.exe.original" -f $tag)
            if (-not (Test-Path $dst)) {
                Copy-Item $p $dst -Force
                Write-Log "backed up $p -> $dst"
            } else {
                Write-Log "backup already exists: $dst (kept)"
            }
        }
    }
}

function Install-Editor {
    if (-not (Test-Path $EditorSrc)) { throw "Editor not found: $EditorSrc (run build.bat first)" }
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Copy-Item $EditorSrc $EditorDst -Force
    Write-Log "copied editor -> $EditorDst"

    Write-Host 'Backing up original notepad.exe files (just in case)...' -ForegroundColor Cyan
    Backup-Originals

    # IFEO Debugger: redirect every Win32 notepad.exe launch to our editor.
    if (-not (Test-Path $IfeoKey)) { New-Item -Path $IfeoKey -Force | Out-Null }
    Set-ItemProperty -Path $IfeoKey -Name 'Debugger' -Value ('"{0}"' -f $EditorDst) -Type String
    Write-Log "set IFEO Debugger -> `"$EditorDst`""

    $wv = Get-WinVersion
    Write-Host ''
    Write-Host ('Done. Detected ' + $wv.Label + ' (build ' + $wv.Build + ').') -ForegroundColor Green
    Write-Host 'Try it now: Win+R -> notepad   (or: notepad somefile.txt)' -ForegroundColor Green
    if ($wv.Label -eq 'Windows 11') {
        Write-Host ''
        Write-Host 'Windows 11 note: .txt files may still open the Store Notepad.' -ForegroundColor Yellow
        Write-Host 'IFEO covers the Win32 path. For .txt too, pick this editor in Settings:' -ForegroundColor Yellow
        Write-Host '  opening Default Apps page in 3 seconds... (you click once; Win11 blocks silent changes)' -ForegroundColor Yellow
        Start-Sleep -Seconds 3
        Start-Process 'ms-settings:defaultapps'
        Write-Log 'opened ms-settings:defaultapps (Win11)'
    }
}

function Uninstall-Editor {
    if (Test-Path $IfeoKey) {
        Remove-Item -Path $IfeoKey -Recurse -Force
        Write-Log 'removed IFEO key'
        Write-Host 'IFEO redirect removed. Win+R notepad now opens the original Notepad.' -ForegroundColor Green
    } else {
        Write-Host 'IFEO key not present (nothing to remove).' -ForegroundColor Yellow
    }
    # leave the backup + installed editor in place (harmless, reusable). Tell the user.
    if (Test-Path $EditorDst) {
        Write-Host "Editor kept at $EditorDst (delete the folder manually if you want it gone)." -ForegroundColor DarkGray
    }
}

# ---- menu ----
function Show-Menu {
    $wv = Get-WinVersion
    Write-Host ''
    Write-Host '=== Tiny Classic Notepad launcher ===' -ForegroundColor Cyan
    Write-Host ('Windows : ' + $wv.Label + ' (build ' + $wv.Build + ')')
    Write-Host ('State   : ' + (Get-InstallState))
    Write-Host ('Install : ' + $InstallDir)
    Write-Host '--------------------------------------'
    Write-Host '  1  Install  (backup + set as default Notepad via IFEO)'
    Write-Host '  2  Uninstall / Restore  (remove IFEO redirect)'
    Write-Host '  3  Backup only  (copy original notepad.exe aside)'
    Write-Host '  4  Status  (re-show version + install state)'
    Write-Host '  0  Exit'
    Write-Host '--------------------------------------'
}

Write-Log 'launcher started'
Show-Menu
while ($true) {
    $c = Read-Host 'Choice'
    switch ($c) {
        '1' { try { Install-Editor } catch { Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red; Write-Log ('ERROR: ' + $_.Exception.Message) } ; Show-Menu }
        '2' { try { Uninstall-Editor } catch { Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red } ; Show-Menu }
        '3' { try { Backup-Originals; Write-Host 'Backup done.' -ForegroundColor Green } catch { Write-Host ('ERROR: ' + $_.Exception.Message) -ForegroundColor Red } ; Show-Menu }
        '4' { Show-Menu }
        '0' { Write-Log 'launcher exited'; break }
        default { Write-Host 'Pick 1, 2, 3, 4 or 0.' -ForegroundColor Yellow }
    }
    if ($c -eq '0') { break }
}
