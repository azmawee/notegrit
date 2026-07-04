; NoteGrit installer / uninstaller / portable extractor. FASM. BSD-2 (see LICENSE).
; Admin-elevated (manifest). Wide (W) APIs for Win10/11.
;   (no arg)            -> install to Program Files (x86)\NoteGrit (+ ARP, App Paths, Open With)
;   /uninstall          -> remove install + registry, self-delete
;   /portable [dir]     -> extract notegrit.exe to <dir> (default: beside this exe), no registry
format PE GUI 4.0
entry Start
include 'win32a.inc'

CSIDL_PROGRAM_FILESX86 = 002Ah
RT_MANIFEST            = 24
RT_RCDATA              = 10
GENERIC_WRITE          = 40000000h
CREATE_ALWAYS          = 2
FILE_ATTRIBUTE_NORMAL  = 00000080h
MAXP                   = 260
SHCNE_ASSOCCHANGED     = 08000000h
SHCNF_IDLIST           = 00001000h

; setup-dialog control IDs
IDC_PATH   = 100
IDC_SHELL  = 101
IDC_TXT    = 102
IDC_BROWSE = 103
BST_CHECKED = 1

struct BROWSEINFOW
  hwndOwner      dd ?
  pidlRoot       dd ?
  pszDisplayName dd ?
  lpszTitle      dd ?
  ulFlags        dd ?
  lpfn           dd ?
  lParam         dd ?
  iImage         dd ?
ends

section '.data' data readable writeable

gInst   dd 0
gHK     dd 0
gCb     dd 0
gDw     dd 0

pfBuf       rb MAXP*2
instDir     rb MAXP*2
exePath     rb MAXP*2
uninstPath  rb MAXP*2
srcExe      rb MAXP*2
selfPath    rb MAXP*2
runDir      rb MAXP*2
portDir     rb MAXP*2
regCmd      rb MAXP*2
uninstQuoted rb MAXP*2
cmdParams   rb MAXP*4
gMsg        rb MAXP*4

; --- registry sub-keys (wide) ---
kAppPaths  du 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\notegrit.exe',0
kApps      du 'Applications\notegrit.exe',0
kAppsCmd   du 'Applications\notegrit.exe\shell\open\command',0
kUninst    du 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NoteGrit',0
kProgID    du 'NoteGrit.txt',0
kProgIDCmd du 'NoteGrit.txt\shell\open\command',0
kProgIDIco du 'NoteGrit.txt\DefaultIcon',0
kTxtOWL    du '.txt\OpenWithProgids',0
kShellVerb du '*\shell\EditWithNoteGrit',0
kShellCmd  du '*\shell\EditWithNoteGrit\command',0

; --- value names (wide) ---
vnPath            du 'Path',0
vnIcon            du 'Icon',0
vnDisplayName     du 'DisplayName',0
vnDisplayVersion  du 'DisplayVersion',0
vnPublisher       du 'Publisher',0
vnDisplayIcon     du 'DisplayIcon',0
vnInstallLoc      du 'InstallLocation',0
vnUninstallString du 'UninstallString',0
vnNoModify        du 'NoModify',0
vnNoRepair        du 'NoRepair',0

; --- data (wide) ---
vName  du 'NoteGrit',0
vVer   du '1.00',0
vPub   du 'Azmawee',0
vDesc  du 'NoteGrit Text Document',0

; --- path fragments (wide) ---
sSubNoteGrit      du '\NoteGrit',0
sSubNotegritExe   du '\notegrit.exe',0
sSubUninstallExe  du '\uninstall.exe',0
sSpacePct1        du ' "%1"',0

; --- cmd self-delete fragments (wide) ---
sCmdHead du '/c ping -n 3 127.0.0.1 >nul & del "',0
sCmdMid  du '" & rd /s /q "',0
sCmdTail du '"',0
sCmdExe  du 'cmd.exe',0

; --- messages (wide) ---
sTitle   du 'NoteGrit Setup',0
sAskUn   du 'Uninstall NoteGrit? Files and registry entries will be removed.',0
sUnDone  du 'NoteGrit uninstalled (folder will be removed shortly).',0
sPort    du 'NoteGrit extracted as portable.',0
sFail    du 'Setup failed. Run as administrator, next to notegrit.exe.',0
sNL      du 13,10,0
; setup-dialog text
sTag      du 'NoteGrit v1.01 - a tiny, fast Notepad-style editor.',0
sInstHdr  du 'Install to:',0
sBrowseTitle du 'Select the folder to install NoteGrit into:',0
sDoesHdr  du 'This will:',0
sDoesBody du 'Copy notegrit.exe and add it to Run (Win+R -> notegrit), Open With, and Apps & Features (uninstallable from Settings).',0
sChkShell du 'Add "Edit with NoteGrit" to the right-click menu',0
sChkTxt   du 'Set as the recommended .txt editor',0
sShellTxt du 'Edit with NoteGrit',0
sBtnInst  du 'Install',0
sBtnCan   du 'Cancel',0
; completion / portable info
sDone1    du 'NoteGrit installed.',0
sDone2    du 'Location: ',0
sDone3    du 'Try: Win+R -> notegrit',0

section '.code' code readable executable

Start:
  invoke GetModuleHandleW,0
  mov [gInst],eax
  invoke GetCommandLineW
  mov esi,eax
  call SkipWS
  call SkipToken
  call SkipWS
  cmp word [esi],0
  je DoInstall
  cmp word [esi],'/'
  je .sw
  cmp word [esi],'-'
  je .sw
  jmp DoInstall
.sw:
  mov ax,[esi+2]
  cmp ax,'A'
  jb .lok
  cmp ax,'Z'
  ja .lok
  add ax,32
.lok:
  cmp ax,'u'
  je DoUninstall
  cmp ax,'p'
  je DoPortable
  jmp DoInstall

; ---- skip whitespace / one token in wide cmdline (esi = cursor) ----
SkipWS:
  cmp word [esi],' '
  jne .s1
  add esi,2
  jmp SkipWS
.s1:
  cmp word [esi],9
  jne .s2
  add esi,2
  jmp SkipWS
.s2:
  ret

SkipToken:
  cmp word [esi],'"'
  jne .bare
  add esi,2
.q:
  cmp word [esi],0
  je .d
  cmp word [esi],'"'
  je .qe
  add esi,2
  jmp .q
.qe:
  add esi,2
  jmp .d
.bare:
  cmp word [esi],0
  je .d
  cmp word [esi],' '
  je .d
  cmp word [esi],9
  je .d
  add esi,2
  jmp .bare
.d:
  ret

; ---- compute common paths (pfBuf, instDir, exePath, uninstPath, srcExe, runDir) ----
ComputePaths:
  invoke SHGetFolderPathW,0,CSIDL_PROGRAM_FILESX86,0,0,pfBuf
  test eax,eax
  jne .err
  stdcall WCpy,instDir,pfBuf
  stdcall WCat,instDir,sSubNoteGrit
  stdcall WCpy,exePath,instDir
  stdcall WCat,exePath,sSubNotegritExe
  stdcall WCpy,uninstPath,instDir
  stdcall WCat,uninstPath,sSubUninstallExe
  invoke GetModuleFileNameW,0,selfPath,MAXP
  stdcall WCpy,runDir,selfPath
  stdcall DirOf,runDir
  stdcall WCpy,srcExe,runDir
  stdcall WCat,srcExe,sSubNotegritExe
  stdcall WQuote,regCmd,exePath
  stdcall WCat,regCmd,sSpacePct1
  stdcall WQuote,uninstQuoted,uninstPath
  xor eax,eax
  ret
.err:
  mov eax,1
  ret

; ---- setup dialog template (DLGTEMPLATE, wide) ----
BIF_RETURNONLYFSDIRS = 00000001h
BIF_USENEWUI        = 00000050h
align 4
SetupDlg:
  dd  WS_POPUP or WS_CAPTION or WS_SYSMENU or DS_MODALFRAME or DS_CENTER
  dd  0
  dw  9                           ; control count
  dw  0,0,310,200                 ; x,y,cx,cy (DLUs)
  dw  0                           ; menu
  dw  0                           ; class
  du  'NoteGrit Setup',0
  align 4
  dd  WS_CHILD or WS_VISIBLE
  dd  0
  dw  10,8,290,10
  dw  0FFFFh
  dw  0FFFFh,0082h                ; STATIC
  du  'NoteGrit v1.01 - a tiny, fast Notepad-style editor.',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE
  dd  0
  dw  10,30,48,9
  dw  0FFFFh
  dw  0FFFFh,0082h                ; STATIC
  du  'Install to:',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or WS_BORDER or WS_TABSTOP or ES_AUTOHSCROLL
  dd  0
  dw  60,27,190,14
  dw  IDC_PATH
  dw  0FFFFh,0081h                ; EDIT
  du  '',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP
  dd  0
  dw  254,26,42,14
  dw  IDC_BROWSE
  dw  0FFFFh,0080h                ; BUTTON
  du  'Browse...',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE
  dd  0
  dw  10,50,290,40
  dw  0FFFFh
  dw  0FFFFh,0082h
  du  'Copy notegrit.exe and add it to Run (Win+R -> notegrit), Open With, and Apps & Features (uninstallable from Settings).',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP
  dd  0
  dw  10,100,290,10
  dw  IDC_SHELL
  dw  0FFFFh,0080h                ; BUTTON
  du  'Add "Edit with NoteGrit" to the right-click menu',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP
  dd  0
  dw  10,112,290,10
  dw  IDC_TXT
  dw  0FFFFh,0080h
  du  'Set as the recommended .txt editor',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP
  dd  0
  dw  190,176,50,14
  dw  IDCANCEL
  dw  0FFFFh,0080h
  du  'Cancel',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON or WS_TABSTOP
  dd  0
  dw  246,176,54,14
  dw  IDOK
  dw  0FFFFh,0080h
  du  'Install',0
  dw  0

; returns: 0 = cancel, else bitfield bit0=install bit1=shell bit2=.txt
proc SetupProc uses ebx,hDlg,uMsg,wParam,lParam
  cmp [uMsg],WM_INITDIALOG
  jne .ninit
  invoke SetDlgItemTextW,[hDlg],IDC_PATH,instDir
  invoke CheckDlgButton,[hDlg],IDC_SHELL,BST_CHECKED
  xor eax,eax
  ret
.ninit:
  cmp [uMsg],WM_COMMAND
  jne .ncmd
  mov eax,[wParam]
  cmp ax,IDCANCEL
  je .cancel
  cmp ax,IDC_BROWSE
  je .browse
  cmp ax,IDOK
  je .ok
  xor eax,eax
  ret
.browse:
  stdcall BrowseFolder,[hDlg]
  test eax,eax
  jz .nb
  invoke SetDlgItemTextW,[hDlg],IDC_PATH,instDir
.nb:
  xor eax,eax
  ret
.cancel:
  invoke EndDialog,[hDlg],0
  xor eax,eax
  ret
.ok:
  ; read the (possibly edited) folder back into instDir before closing
  invoke GetDlgItemTextW,[hDlg],IDC_PATH,instDir,MAXP
  test eax,eax
  jz .cancel
  mov ebx,1
  invoke IsDlgButtonChecked,[hDlg],IDC_SHELL
  test eax,eax
  jz .ns
  or ebx,2
.ns:
  invoke IsDlgButtonChecked,[hDlg],IDC_TXT
  test eax,eax
  jz .nt
  or ebx,4
.nt:
  invoke EndDialog,[hDlg],ebx
  xor eax,eax
  ret
.ncmd:
  xor eax,eax
  ret
endp

; ---- folder picker: SHBrowseForFolder. on OK copies the chosen path to instDir ----
; returns eax=1 if a folder was chosen, eax=0 if cancelled/failed
proc BrowseFolder uses ebx edi,hDlg
  locals
    bi   BROWSEINFOW ?
    pidl dd ?
  endl
  lea edi,[bi]
  mov ecx,sizeof.BROWSEINFOW
  xor eax,eax
  rep stosb
  mov eax,[hDlg]
  mov [bi.hwndOwner],eax
  and dword [bi.pidlRoot],0
  mov dword [bi.pszDisplayName],pfBuf
  mov dword [bi.lpszTitle],sBrowseTitle
  mov dword [bi.ulFlags],BIF_RETURNONLYFSDIRS
  and dword [bi.lpfn],0
  and dword [bi.lParam],0
  lea eax,[bi]
  invoke SHBrowseForFolderW,eax
  test eax,eax
  jz .cancel
  mov [pidl],eax
  invoke SHGetPathFromIDListW,[pidl],instDir
  push eax
  invoke CoTaskMemFree,[pidl]
  pop eax
  test eax,eax
  jz .cancel
  mov eax,1
  ret
.cancel:
  xor eax,eax
  ret
endp

; ---- recompute downstream paths (exePath, uninstPath, regCmd, uninstQuoted) from instDir ----
proc RebuildDownstream
  stdcall WCpy,exePath,instDir
  stdcall WCat,exePath,sSubNotegritExe
  stdcall WCpy,uninstPath,instDir
  stdcall WCat,uninstPath,sSubUninstallExe
  stdcall WQuote,regCmd,exePath
  stdcall WCat,regCmd,sSpacePct1
  stdcall WQuote,uninstQuoted,uninstPath
  ret
endp

DoInstall:
  call ComputePaths
  test eax,eax
  jne .fail
  ; setup dialog: returns 0 = cancel, else bitfield (bit0=install, bit1=shell menu, bit2=.txt)
  invoke DialogBoxIndirectParamW,[gInst],SetupDlg,0,SetupProc,0
  test eax,eax
  jz .cancel
  push eax
  call RebuildDownstream             ; recompute exePath/etc from chosen instDir
  invoke CreateDirectoryW,instDir,0
  stdcall ExtractPayload,exePath
  test eax,eax
  je .fail
  invoke CopyFileW,selfPath,uninstPath,FALSE
  ; App Paths
  stdcall RegSetStrW,HKEY_LOCAL_MACHINE,kAppPaths,0,exePath
  stdcall RegSetStrW,HKEY_LOCAL_MACHINE,kAppPaths,vnPath,instDir
  ; Applications (Open With)
  stdcall RegSetStrW,HKEY_CLASSES_ROOT,kApps,0,vName
  stdcall RegSetStrW,HKEY_CLASSES_ROOT,kAppsCmd,0,regCmd
  ; ARP Uninstall
  stdcall RegSetStrW,HKEY_LOCAL_MACHINE,kUninst,vnDisplayName,vName
  stdcall RegSetStrW,HKEY_LOCAL_MACHINE,kUninst,vnDisplayVersion,vVer
  stdcall RegSetStrW,HKEY_LOCAL_MACHINE,kUninst,vnPublisher,vPub
  stdcall RegSetStrW,HKEY_LOCAL_MACHINE,kUninst,vnDisplayIcon,exePath
  stdcall RegSetStrW,HKEY_LOCAL_MACHINE,kUninst,vnInstallLoc,instDir
  stdcall RegSetStrW,HKEY_LOCAL_MACHINE,kUninst,vnUninstallString,uninstQuoted
  stdcall RegSetDwordW,HKEY_LOCAL_MACHINE,kUninst,vnNoModify,1
  stdcall RegSetDwordW,HKEY_LOCAL_MACHINE,kUninst,vnNoRepair,1
  invoke SHChangeNotify,SHCNE_ASSOCCHANGED,SHCNF_IDLIST,0,0
  pop ebx
  test ebx,2                     ; "Edit with NoteGrit" right-click menu?
  jz .noshell
  stdcall RegSetStrW,HKEY_CLASSES_ROOT,kShellVerb,0,sShellTxt
  stdcall RegSetStrW,HKEY_CLASSES_ROOT,kShellVerb,vnIcon,exePath
  stdcall RegSetStrW,HKEY_CLASSES_ROOT,kShellCmd,0,regCmd
.noshell:
  test ebx,4                     ; .txt editor?
  jz .notxt
  stdcall RegSetStrW,HKEY_CLASSES_ROOT,kProgID,0,vDesc
  stdcall RegSetStrW,HKEY_CLASSES_ROOT,kProgIDIco,0,exePath
  stdcall RegSetStrW,HKEY_CLASSES_ROOT,kProgIDCmd,0,regCmd
  stdcall RegSetStrW,HKEY_CLASSES_ROOT,kTxtOWL,vName,vName
  invoke SHChangeNotify,SHCNE_ASSOCCHANGED,SHCNF_IDLIST,0,0
.notxt:
  ; completion: installed. \n Location: <path> \n Try: Win+R -> notegrit
  stdcall WCpy,gMsg,sDone1
  stdcall WCat,gMsg,sNL
  stdcall WCat,gMsg,sDone2
  stdcall WCat,gMsg,instDir
  stdcall WCat,gMsg,sNL
  stdcall WCat,gMsg,sDone3
  invoke MessageBoxW,0,gMsg,sTitle,MB_OK or MB_ICONINFORMATION
  invoke ExitProcess,0
.cancel:
  invoke ExitProcess,0
.fail:
  invoke MessageBoxW,0,sFail,sTitle,MB_OK or MB_ICONERROR
  invoke ExitProcess,1

DoUninstall:
  invoke MessageBoxW,0,sAskUn,sTitle,MB_YESNO or MB_ICONQUESTION
  cmp eax,IDYES
  je .go
  invoke ExitProcess,0
.go:
  call ComputePaths
  invoke SHDeleteKeyW,HKEY_LOCAL_MACHINE,kAppPaths
  invoke SHDeleteKeyW,HKEY_CLASSES_ROOT,kApps
  invoke SHDeleteKeyW,HKEY_CLASSES_ROOT,kShellVerb
  invoke SHDeleteKeyW,HKEY_CLASSES_ROOT,kProgID
  invoke SHDeleteValueW,HKEY_CLASSES_ROOT,kTxtOWL,vName
  invoke SHDeleteKeyW,HKEY_LOCAL_MACHINE,kUninst
  invoke DeleteFileW,exePath
  invoke SHChangeNotify,SHCNE_ASSOCCHANGED,SHCNF_IDLIST,0,0
  ; self-delete via cmd (runs after this process exits)
  stdcall WCpy,cmdParams,sCmdHead
  stdcall WCat,cmdParams,uninstPath
  stdcall WCat,cmdParams,sCmdMid
  stdcall WCat,cmdParams,instDir
  stdcall WCat,cmdParams,sCmdTail
  invoke ShellExecuteW,0,0,sCmdExe,cmdParams,0,SW_HIDE
  invoke MessageBoxW,0,sUnDone,sTitle,MB_OK or MB_ICONINFORMATION
  invoke ExitProcess,0

DoPortable:
  call SkipToken              ; consume "/portable"
  call SkipWS
  ; figure out the target directory
  cmp word [esi],0
  jne .argdir
  ; no dir -> extract embedded notegrit.exe beside this installer
  invoke GetModuleFileNameW,0,selfPath,MAXP
  stdcall WCpy,portDir,selfPath
  stdcall DirOf,portDir
  jmp .do
.argdir:
  stdcall CopyArgTo,portDir
.do:
  stdcall WCpy,exePath,portDir
  stdcall WCat,exePath,sSubNotegritExe
  invoke CreateDirectoryW,portDir,0
  stdcall ExtractPayload,exePath
  test eax,eax
  je .fail
  invoke MessageBoxW,0,sPort,sTitle,MB_OK or MB_ICONINFORMATION
  invoke ExitProcess,0
.fail:
  invoke MessageBoxW,0,sFail,sTitle,MB_OK or MB_ICONERROR
  invoke ExitProcess,1

; ---- wide string helpers ----
proc WCpy uses edi esi,dst,src
  mov edi,[dst]
  mov esi,[src]
.lp:
  mov ax,[esi]
  mov [edi],ax
  add esi,2
  add edi,2
  test ax,ax
  jne .lp
  ret
endp

proc WCat uses edi esi,dst,src
  mov edi,[dst]
.find:
  cmp word [edi],0
  je .copy
  add edi,2
  jmp .find
.copy:
  mov esi,[src]
.cp:
  mov ax,[esi]
  mov [edi],ax
  add esi,2
  add edi,2
  test ax,ax
  jne .cp
  ret
endp

proc WQuote uses edi esi,dst,src
  mov edi,[dst]
  mov word [edi],'"'
  add edi,2
  mov esi,[src]
.cp:
  mov ax,[esi]
  mov [edi],ax
  add esi,2
  add edi,2
  test ax,ax
  jne .cp
  sub edi,2                 ; back to the copied null
  mov word [edi],'"'
  add edi,2
  mov word [edi],0
  ret
endp

proc DirOf uses edi esi,p
  mov edi,[p]
  xor esi,esi
.lp:
  cmp word [edi],0
  je .d
  cmp word [edi],'\'
  jne .n
  mov esi,edi
.n:
  add edi,2
  jmp .lp
.d:
  test esi,esi
  je .done
  mov word [esi],0
.done:
  ret
endp

; copy current wide token at esi (quoted or bare) into dst; advance esi past it.
proc CopyArgTo uses edi,dst
  mov edi,[dst]
  cmp word [esi],'"'
  jne .bare
  add esi,2
.q:
  cmp word [esi],0
  je .qend
  cmp word [esi],'"'
  je .qend
  mov ax,[esi]
  mov [edi],ax
  add esi,2
  add edi,2
  jmp .q
.qend:
  jmp .term
.bare:
  cmp word [esi],0
  je .term
  cmp word [esi],' '
  je .term
  cmp word [esi],9
  je .term
  mov ax,[esi]
  mov [edi],ax
  add esi,2
  add edi,2
  jmp .bare
.term:
  mov word [edi],0
  ret
endp

; ---- extract the embedded notegrit.exe resource to [dstPath]. eax=1 ok, 0 fail ----
proc ExtractPayload uses ebx esi edi, dstPath
  locals
    hFile   dd ?
    written dd ?
  endl
  invoke FindResourceW,[gInst],1,RT_RCDATA
  test eax,eax
  je .fail
  mov ebx,eax                      ; hRes
  invoke SizeofResource,[gInst],ebx
  test eax,eax
  je .fail
  mov edi,eax                      ; total bytes
  invoke LoadResource,[gInst],ebx
  test eax,eax
  je .fail
  mov ebx,eax                      ; hGlob
  invoke LockResource,ebx
  test eax,eax
  je .fail
  mov esi,eax                      ; pData
  invoke CreateFileW,[dstPath],GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
  cmp eax,-1
  je .fail
  mov [hFile],eax
.wl:
  test edi,edi
  je .ok
  cmp edi,16384
  ja .chunk
  lea eax,[written]
  invoke WriteFile,[hFile],esi,edi,eax,0
  test eax,eax
  je .wfail
  jmp .ok
.chunk:
  lea eax,[written]
  invoke WriteFile,[hFile],esi,16384,eax,0
  test eax,eax
  je .wfail
  sub edi,16384
  add esi,16384
  jmp .wl
.ok:
  invoke CloseHandle,[hFile]
  mov eax,1
  ret
.wfail:
  invoke CloseHandle,[hFile]
.fail:
  xor eax,eax
  ret
endp

; ---- registry helpers (Unicode) ----
proc RegSetStrW uses ebx,root,sub,val,data
  stdcall WStrLen,[data]
  inc eax
  shl eax,1                 ; bytes = (len+1)*2
  mov [gCb],eax
  invoke RegCreateKeyExW,[root],[sub],0,0,0,KEY_ALL_ACCESS,0,gHK,0
  test eax,eax
  jne .x
  invoke RegSetValueExW,[gHK],[val],0,REG_SZ,[data],[gCb]
  invoke RegCloseKey,[gHK]
.x:
  ret
endp

proc RegSetDwordW uses ebx,root,sub,val,dval
  invoke RegCreateKeyExW,[root],[sub],0,0,0,KEY_ALL_ACCESS,0,gHK,0
  test eax,eax
  jne .x
  mov eax,[dval]
  mov [gDw],eax
  invoke RegSetValueExW,[gHK],[val],0,REG_DWORD,gDw,4
  invoke RegCloseKey,[gHK]
.x:
  ret
endp

proc WStrLen uses edi,p
  mov edi,[p]
  xor eax,eax
.lp:
  cmp word [edi],0
  je .d
  add edi,2
  inc eax
  jmp .lp
.d:
  ret
endp

data import
  library kernel32,'KERNEL32.DLL',\
          advapi32,'ADVAPI32.DLL',\
          shell32,'SHELL32.DLL',\
          shlwapi,'SHLWAPI.DLL',\
          ole32,'OLE32.DLL',\
          user32,'USER32.DLL'
  import kernel32,\
    GetModuleHandleW,'GetModuleHandleW',\
    GetModuleFileNameW,'GetModuleFileNameW',\
    GetCommandLineW,'GetCommandLineW',\
    CreateDirectoryW,'CreateDirectoryW',\
    CopyFileW,'CopyFileW',\
    DeleteFileW,'DeleteFileW',\
    CreateFileW,'CreateFileW',\
    WriteFile,'WriteFile',\
    CloseHandle,'CloseHandle',\
    FindResourceW,'FindResourceW',\
    LoadResource,'LoadResource',\
    LockResource,'LockResource',\
    SizeofResource,'SizeofResource',\
    ExitProcess,'ExitProcess'
  import advapi32,\
    RegCreateKeyExW,'RegCreateKeyExW',\
    RegSetValueExW,'RegSetValueExW',\
    RegCloseKey,'RegCloseKey'
  import shell32,\
    SHGetFolderPathW,'SHGetFolderPathW',\
    ShellExecuteW,'ShellExecuteW',\
    SHChangeNotify,'SHChangeNotify',\
    SHBrowseForFolderW,'SHBrowseForFolderW',\
    SHGetPathFromIDListW,'SHGetPathFromIDListW'
  import shlwapi,\
    SHDeleteKeyW,'SHDeleteKeyW',\
    SHDeleteValueW,'SHDeleteValueW'
  import ole32,\
    CoTaskMemFree,'CoTaskMemFree'
  import user32,\
    MessageBoxW,'MessageBoxW',\
    DialogBoxIndirectParamW,'DialogBoxIndirectParamW',\
    EndDialog,'EndDialog',\
    SetDlgItemTextW,'SetDlgItemTextW',\
    GetDlgItemTextW,'GetDlgItemTextW',\
    CheckDlgButton,'CheckDlgButton',\
    IsDlgButtonChecked,'IsDlgButtonChecked'
end data

section '.rsrc' resource data readable
  directory RT_MANIFEST, manifests, RT_RCDATA, payloads
  resource manifests, 1, LANG_NEUTRAL, manifest_data
  resource payloads, 1, LANG_NEUTRAL, payload_notegrit
  resdata manifest_data
    file 'installer.manifest'
  endres
  resdata payload_notegrit
    file '..\notegrit.exe'
  endres
