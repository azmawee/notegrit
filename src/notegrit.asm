; Note Grit - a tiny editor. BSD 2-Clause (see LICENSE). Version in sVer; bump +0.01 per change.
format PE GUI 4.0
entry Main
include 'win32a.inc'

FEAT_DARKMODE = 1

WIN_W     = 800
WIN_H     = 600
ARG_MAX   = 260
CAP_MAX   = 128
CAP_TAIL  = 16        ; bytes reserved in gCap for " - Note Grit" + null (bound MakeTitle)
STAT_H    = 20
GOEDIT_ID = 1000
SCAN_MAX  = 00040000h
IDR_ICON  = 1
MIM_BACKGROUND      = 00000002h
MIM_APPLYTOSUBMENUS = 80000000h

EM_EXGETSEL        = WM_USER+52
EM_EXLINEFROMCHAR  = WM_USER+54
EM_EXSETSEL        = WM_USER+55
EM_FORMATRANGE     = WM_USER+57
EM_SETBKGNDCOLOR   = WM_USER+67
EM_SETCHARFORMAT   = WM_USER+68
EM_SETEVENTMASK    = WM_USER+69
EM_SETTARGETDEVICE = WM_USER+72
EM_EXLIMITTEXT     = WM_USER+53
EM_SETZOOM         = WM_USER+225
EM_FINDTEXTEX      = WM_USER+79
EM_STREAMIN        = WM_USER+73
SF_TEXT            = 00000001h

SCF_ALL         = 00000004h
ENM_CHANGE      = 00000001h
ENM_MOUSEEVENTS = 00020000h
ENM_SELCHANGE   = 00080000h
EN_SELCHANGE    = 00000707h
EN_MSGFILTER    = 00000700h

CFM_FACE    = 20000000h
CFM_SIZE    = 80000000h
CFM_BOLD    = 00000001h
CFM_ITALIC  = 00000002h
CFM_COLOR   = 40000000h
CFE_BOLD    = 00000001h
CFE_ITALIC  = 00000002h
CFE_AUTOCOLOR = 40000000h
CF_SCREENFONTS = 00000001h
CF_EFFECTS     = 00000100h
LF_FACESIZE = 32

HORZRES     = 8
VERTRES     = 10
LOGPIXELSX  = 88
LOGPIXELSY  = 90
VK_OEM_PLUS  = 0BBh
VK_OEM_MINUS = 0BDh
GWL_WNDPROC  = -4
DATE_SHORTDATE      = 00000001h
LOCALE_USER_DEFAULT = 00000400h
BLUE = 00FF0000h
HKEY_CURRENT_USER = 80000001h
KEY_ALL_ACCESS    = 000F003Fh
REG_DWORD         = 00000004h

CID_SAVE    = 0E100h
CID_NEW     = 0E200h
CID_EXIT    = 0E201h
CID_OPEN    = 0E202h
CID_SAVEAS  = 0E203h
CID_PRINT   = 0E204h
CID_PAGESET = 0E205h
CID_UNDO    = 0E210h
CID_CUT     = 0E211h
CID_COPY    = 0E212h
CID_PASTE   = 0E213h
CID_DELETE  = 0E214h
CID_SELALL  = 0E215h
CID_TIME    = 0E216h
CID_FIND    = 0E217h
CID_FINDNEXT= 0E218h
CID_REPLACE = 0E219h
CID_GOTO    = 0E21Ah
CID_WRAP    = 0E220h
CID_FONT    = 0E221h
CID_STATUS  = 0E230h
CID_DARK    = 0E232h
CID_ZOOMIN  = 0E233h
CID_ZOOMOUT = 0E234h
CID_ZOOMRST = 0E235h
CID_ABOUT   = 0E240h

LID_GH   = 2000
LID_WEB  = 2001
LID_FB   = 2002

DARK_BG = 001E1E1Eh
DARK_FG = 00DCDCDCh
DARK_MENUHI = 00383B40h

struct CHARRANGE
  cpMin dd ?
  cpMax dd ?
ends

struct FINDTEXTEX
  fMin   dd ?
  fMax   dd ?
  fText  dd ?
  tMin   dd ?
  tMax   dd ?
ends

struct EDITSTREAM
  dwCookie    dd ?
  dwError     dd ?
  pfnCallback dd ?
ends

struct FINDREPLACEA
  lStructSize      dd ?
  hwndOwner        dd ?
  hInstance        dd ?
  Flags            dd ?
  lpstrFindWhat    dd ?
  lpstrReplaceWith dd ?
  wFindWhatLen     dw ?
  wReplaceWithLen  dw ?
  lCustData        dd ?
  lpfnHook         dd ?
  lpTemplateName   dd ?
ends

struct LOGFONTW
  lfHeight         dd ?
  lfWidth          dd ?
  lfEscapement     dd ?
  lfOrientation    dd ?
  lfWeight         dd ?
  lfItalic         db ?
  lfUnderline      db ?
  lfStrikeOut      db ?
  lfCharSet        db ?
  lfOutPrecision   db ?
  lfClipPrecision  db ?
  lfQuality        db ?
  lfPitchAndFamily db ?
  lfFaceName       du LF_FACESIZE dup(?)
ends

struct CHARFORMATW
  cbSize      dd ?
  dwMask      dd ?
  dwEffects   dd ?
  yHeight     dd ?
  yOffset     dd ?
  crTextColor dd ?
  bCharSet    db ?
  bPitchAndFamily db ?
  szFaceName  du LF_FACESIZE dup(?)
  _pad        dw ?              ; align to 92 = sizeof(CHARFORMATW); RichEdit rejects cbSize=90
ends

struct OPENFILENAMEA
  lStructSize       dd ?
  hwndOwner         dd ?
  hInstance         dd ?
  lpstrFilter       dd ?
  lpstrCustomFilter dd ?
  nMaxCustFilter    dd ?
  nFilterIndex      dd ?
  lpstrFile         dd ?
  nMaxFile          dd ?
  lpstrFileTitle    dd ?
  nMaxFileTitle     dd ?
  lpstrInitialDir   dd ?
  lpstrTitle        dd ?
  Flags             dd ?
  nFileOffset       dw ?
  nFileExtension    dw ?
  lpstrDefExt       dd ?
  lCustData         dd ?
  lpfnHook          dd ?
  lpTemplateName    dd ?
ends

struct CHOOSEFONTW
  lStructSize    dd ?
  hwndOwner      dd ?
  hDC            dd ?
  lpLogFont      dd ?
  iPointSize     dd ?
  Flags          dd ?
  rgbColors      dd ?
  lCustData      dd ?
  lpfnHook       dd ?
  lpTemplateName dd ?
  hInstance      dd ?
  lpszStyle      dd ?
  nFontType      dw ?
  _pad           dw ?
  nSizeMin       dd ?
  nSizeMax       dd ?
ends

struct PRINTDLGA
  lStructSize         dd ?
  hwndOwner           dd ?
  hDevMode            dd ?
  hDevNames           dd ?
  hDC                 dd ?
  Flags               dd ?
  nFromPage           dw ?
  nToPage             dw ?
  nMinPage            dw ?
  nMaxPage            dw ?
  nCopies             dw ?
  hInstance           dd ?
  lCustData           dd ?
  lpfnPrintHook       dd ?
  lpfnSetupHook       dd ?
  lpPrintTemplateName dd ?
  lpSetupTemplateName dd ?
  hPrintTemplate      dd ?
  hSetupTemplate      dd ?
ends

struct DOCINFOA
  cbSize       dd ?
  lpszDocName  dd ?
  lpszOutput   dd ?
  lpszDatatype dd ?
  fwType       dd ?
ends

struct FORMATRANGE
  hdc          dd ?
  hdcTarget    dd ?
  rcL          dd ?
  rcT          dd ?
  rcR          dd ?
  rcB          dd ?
  pgL          dd ?
  pgT          dd ?
  pgR          dd ?
  pgB          dd ?
  rMin         dd ?
  rMax         dd ?
ends

struct PAGESETUPDLGA
  lStructSize             dd ?
  hwndOwner               dd ?
  hDevMode                dd ?
  hDevNames               dd ?
  Flags                   dd ?
  ptPaperSize             POINT
  rtMinMargin             RECT
  rtMargin                RECT
  hInstance               dd ?
  lCustData               dd ?
  lpfnPageSetupHook       dd ?
  lpfnPagePaintHook       dd ?
  lpPageSetupTemplateName dd ?
  hPageSetupTemplate      dd ?
ends

struct MENUINFO
  cbSize          dd ?
  fMask           dd ?
  dwStyle         dd ?
  cyMax           dd ?
  hbrBack         dd ?
  dwContextHelpID dd ?
  dwMenuData      dd ?
ends

section '.data' data readable writeable

gCls   db 'NoteGrit',0
gLib   db 'Msftedit',0
gEd    db 'RICHEDIT50W',0
gSave  db 'Save',0
gSpace db ' ',0
gZero  db 0

gMain  dd 0
gEdit  dd 0
gStat  dd 0
gInst  dd 0
gPath  rb ARG_MAX
gCap   rb CAP_MAX
gRead  dd 0
gDirty dd 0
gWrap  dd 1
gStatOn dd 1
gDark  dd 0
gNeedTally dd 1
gChars dd 0
gWords dd 0
gZoom  dd 100
gFindDlg dd 0
gFindMsg dd 0
gBrDarkBg  dd 0
gBrDarkSel dd 0
gmi    MENUINFO ?
gts    SIZE ?
gdrc   RECT ?
gOD    dd 0          ; MF_OWNERDRAW (dark) or MF_STRING=0 (light), per BuildMenus/RightClick
gPop   dd 0          ; MF_POPUP or [gOD], for top-level menu bar items
gReg     dd 0        ; HKCU\Software\NoteGrit handle (zoom persistence)
gRegType dd 0
gRegCb   dd 0
gDisp    dd 0
gOldEditProc dd 0        ; original RichEdit WndProc (subclassed for Ctrl+wheel zoom)

sNew   db 'Untitled',0
sTail  db ' - Note Grit',0
sRegKey  db 'Software\NoteGrit',0
sRegZoom db 'Zoom',0
sRegDark db 'Dark',0
sVer   db '1.00',0
sCap   db 'Note Grit',0
sCapFmt db 'About Note Grit v%s',0
sCapBuf rb 48
sSaveAsk db 'Save changes?',0
sDoc   db 'Note Grit',0
sFilter db 'Text Files',0,'*.txt',0,'All Files',0,'*.*',0,0
sFindMsgStr db 'commdlg_FindReplace',0
sStatic db 'STATIC',0
sStub   db 'notepad.exe',0
sOpen   db 'open',0
sFace   du 'Courier',0
sUrlGh  db 'https://github.com/azmawee/notegrit',0
sUrlWeb db 'https://azmawee.github.io',0
sUrlFb  db 'https://www.facebook.com/azmawee',0

sFile   db '&File',0
sEdit   db '&Edit',0
sFmt    db 'F&ormat',0
sView   db '&View',0
sHelp   db '&Help',0
sMNew   db '&New',0
sMOpen  db '&Open...',0
sMSave  db '&Save',0
sMSaveA db 'Save &As...',0
sMPage  db 'Page Set&up...',0
sMPrint db '&Print...',0
sMExit  db 'E&xit',0
sMUndo  db '&Undo',0
sMCut   db 'Cu&t',0
sMCopy  db '&Copy',0
sMPaste db '&Paste',0
sMDel   db 'De&lete',0
sMFind  db '&Find...',0
sMNext  db 'Find &Next',0
sMRepl  db '&Replace...',0
sMGoTo  db '&Go To...',0
sMSel   db 'Select &All',0
sMTime  db 'Time/&Date',0
sMWrap  db '&Word Wrap',0
sMFont  db '&Font...',0
sMStat  db '&Status Bar',0
sMDark  db 'Dark &Mode',0
sMZIn   db 'Zoom &In',0
sMZOut  db 'Zoom &Out',0
sMZRst  db 'Zoom &Reset',0
sMAbout db '&About Note Grit',0

gDate   rb 32
gTime   rb 32
gFindWhat rb 256
gReplWith rb 256
gStatLine rb 56
sLnCol  db '  Ln %d, Col %d   %d ch   %d wd   %d%%',0

fr      FINDREPLACEA ?
ofn     OPENFILENAMEA ?
sysTime SYSTEMTIME ?
lf      LOGFONTW ?
cf      CHOOSEFONTW ?
cfmt    CHARFORMATW ?
ft      FINDTEXTEX ?
cr      CHARRANGE ?
pd      PRINTDLGA ?
docInf  DOCINFOA ?
pfmt    FORMATRANGE ?
psd     PAGESETUPDLGA ?
wc      WNDCLASS ?
msg     MSG ?
wrc     RECT ?
txtLen  dd ?
hPrnDC  dd ?
hFile   dd ?
hMem    dd ?
hMap     dd ?
gMapBase dd ?
gMapOff  dd ?
gFileSize dd ?
estrm   EDITSTREAM ?

align 4
GoDlg:
  dd  WS_POPUP or WS_CAPTION or WS_SYSMENU or DS_MODALFRAME or DS_CENTER
  dd  0
  dw  2
  dw  0,0,150,46
  dw  0
  dw  0
  du  'Go To Line',0
  align 4
  dd  WS_CHILD or WS_VISIBLE or WS_BORDER or ES_NUMBER or WS_TABSTOP
  dd  0
  dw  7,7,136,12
  dw  GOEDIT_ID
  dw  0FFFFh,0081h
  dw  0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON or WS_TABSTOP
  dd  0
  dw  50,26,50,14
  dw  IDOK
  dw  0FFFFh,0080h
  du  'OK',0
  dw  0

align 4
AboutDlg:
  dd  WS_POPUP or WS_CAPTION or WS_SYSMENU or DS_MODALFRAME or DS_CENTER
  dd  0
  dw  5
  dw  0,0,210,120
  dw  0
  dw  0
  du  'About',0
  align 4
  dd  WS_CHILD or WS_VISIBLE or SS_CENTER
  dd  0
  dw  0,8,210,14
  dw  0FFFFh
  dw  0FFFFh,0082h
  du  'Note Grit by Azmawee',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or SS_NOTIFY or SS_CENTER
  dd  0
  dw  0,30,210,12
  dw  LID_GH
  dw  0FFFFh,0082h
  du  'github.com/azmawee/notegrit',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or SS_NOTIFY or SS_CENTER
  dd  0
  dw  0,46,210,12
  dw  LID_WEB
  dw  0FFFFh,0082h
  du  'azmawee.github.io',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or SS_NOTIFY or SS_CENTER
  dd  0
  dw  0,62,210,12
  dw  LID_FB
  dw  0FFFFh,0082h
  du  'facebook.com/azmawee',0
  dw  0
  align 4
  dd  WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON or WS_TABSTOP
  dd  0
  dw  80,90,50,14
  dw  IDOK
  dw  0FFFFh,0080h
  du  'OK',0
  dw  0

section '.code' code readable executable

Main:
  invoke GetModuleHandleA,0
  mov [gInst],eax
  invoke LoadLibraryA,gLib
  invoke RegisterWindowMessageA,sFindMsgStr
  mov [gFindMsg],eax
  lea edi,[wc]
  mov ecx,10
  xor eax,eax
  rep stosd
  mov [wc.lpfnWndProc],WndProc
  mov eax,[gInst]
  mov [wc.hInstance],eax
  mov [wc.lpszClassName],gCls
  invoke LoadIconA,[gInst],IDR_ICON
  mov [wc.hIcon],eax
  invoke RegisterClassA,wc
  call GrabCmdFile
  invoke CreateWindowExA,0,gCls,gCls,WS_OVERLAPPEDWINDOW or WS_VISIBLE,CW_USEDEFAULT,CW_USEDEFAULT,WIN_W,WIN_H,0,0,[gInst],0
  test eax,eax
  je .mret
  mov [gMain],eax
  call PullInFile
  xor eax,eax
  mov [gDirty],eax
  call SetTitle
.mloop:
  invoke GetMessageA,msg,0,0,0
  test eax,eax
  je .mdone
  cmp [gFindDlg],0
  je .nofd
  invoke IsDialogMessageA,[gFindDlg],msg
  test eax,eax
  jne .mloop
.nofd:
  cmp [msg.message],WM_KEYDOWN
  jne .disp
  call DoAccel
  test eax,eax
  jne .mloop
.disp:
  invoke TranslateMessage,msg
  invoke DispatchMessageA,msg
  jmp .mloop
.mdone:
  invoke ExitProcess,[msg.wParam]
.mret:
  invoke ExitProcess,0

MakeTitle:
  lea edi,[gCap]
  cmp [gDirty],0
  je .nd
  mov word [edi],'*'
  mov byte [edi+1],' '
  add edi,2
.nd:
  mov esi,gPath
  cmp byte [esi],0
  jne .findbase
  mov esi,sNew
  jmp .copyname
.findbase:
  mov ebx,esi
.base:
  mov al,[esi]
  test al,al
  je .gotbase
  cmp al,'\'
  je .mark
  cmp al,'/'
  je .mark
  inc esi
  jmp .base
.mark:
  lea ebx,[esi+1]
  inc esi
  jmp .base
.gotbase:
  mov esi,ebx
.copyname:
  mov edx,gCap
  add edx,CAP_MAX-CAP_TAIL   ; hard stop: leave room for tail+null (no overflow)
.cnlp:
  mov al,[esi]
  test al,al
  je .namedone
  cmp edi,edx
  jae .namedone
  mov [edi],al
  inc edi
  inc esi
  jmp .cnlp
.namedone:
  mov esi,sTail
.coptail:
  mov al,[esi]
  mov [edi],al
  inc edi
  inc esi
  test al,al
  jne .coptail
  ret

SetTitle:
  call MakeTitle
  invoke SetWindowTextA,[gMain],gCap
  ret

GrabCmdFile:
  invoke GetCommandLineA
  mov esi,eax
  test esi,esi
  je .none
  cmp byte [esi],'"'
  jne .bareexe
  inc esi
.qexe:
  mov al,[esi]
  test al,al
  je .none
  inc esi
  cmp al,'"'
  jne .qexe
  jmp .sksp
.bareexe:
  mov al,[esi]
  test al,al
  je .none
  cmp al,' '
  je .sksp
  cmp al,9
  je .sksp
  inc esi
  jmp .bareexe
.sksp:
  mov al,[esi]
  cmp al,' '
  je .sks1
  cmp al,9
  je .sks1
  jmp .got1
.sks1:
  inc esi
  jmp .sksp
.got1:
  call IsStubArg
  test al,al
  jz .take
  call SkipOneArg
.sksp2:
  mov al,[esi]
  cmp al,' '
  je .sk21
  cmp al,9
  je .sk21
  jmp .take
.sk21:
  inc esi
  jmp .sksp2
.take:
  cmp byte [esi],0
  je .none
  lea edi,[gPath]
  mov ecx,ARG_MAX-1
  cmp byte [esi],'"'
  jne .copybare
  inc esi
.copyq:
  mov al,[esi]
  test al,al
  je .cpdone
  cmp al,'"'
  je .cpdone
  mov [edi],al
  inc edi
  inc esi
  dec ecx
  jz .cpdone
  jmp .copyq
.copybare:
  mov al,[esi]
  test al,al
  je .cpdone
  cmp al,' '
  je .cpdone
  cmp al,9
  je .cpdone
  mov [edi],al
  inc edi
  inc esi
  dec ecx
  jz .cpdone
  jmp .copybare
.cpdone:
  mov byte [edi],0
  ret
.none:
  mov byte [gPath],0
  ret

IsStubArg:
  push edi esi ebx
  mov ebx,esi
  mov edi,esi
.iscan:
  mov al,[edi]
  test al,al
  je .isscandone
  cmp al,'"'
  je .isscandone
  cmp al,' '
  je .isscandone
  cmp al,9
  je .isscandone
  cmp al,'\'
  je .issep
  cmp al,'/'
  je .issep
  inc edi
  jmp .iscan
.issep:
  lea ebx,[edi+1]
  inc edi
  jmp .iscan
.isscandone:
  mov edi,ebx
  mov esi,sStub
.icmp:
  mov al,[edi]
  mov cl,[esi]
  cmp cl,0
  je .iterm
  cmp al,0
  je .inomatch
  cmp al,'A'
  jb .ilowok
  cmp al,'Z'
  ja .ilowok
  add al,32
.ilowok:
  cmp al,cl
  jne .inomatch
  inc edi
  inc esi
  jmp .icmp
.iterm:
  cmp al,0
  je .iyes
  cmp al,'"'
  je .iyes
  cmp al,' '
  je .iyes
  cmp al,9
  je .iyes
  jmp .ino
.inomatch:
  xor eax,eax
  jmp .iret
.iyes:
  mov eax,1
  jmp .iret
.ino:
  xor eax,eax
.iret:
  pop ebx esi edi
  ret

SkipOneArg:
  cmp byte [esi],'"'
  jne .sb
  inc esi
.sq:
  mov al,[esi]
  test al,al
  je .sdone
  inc esi
  cmp al,'"'
  jne .sq
  jmp .sdone
.sb:
  mov al,[esi]
  test al,al
  je .sdone
  cmp al,' '
  je .sdone
  cmp al,9
  je .sdone
  inc esi
  jmp .sb
.sdone:
  ret

PullInFile:
  cmp byte [gPath],0
  je .ldone
  invoke CreateFileA,gPath,GENERIC_READ,FILE_SHARE_READ,0,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0
  cmp eax,INVALID_HANDLE_VALUE
  je .ldone
  mov [hFile],eax
  invoke GetFileSize,[hFile],0
  cmp eax,0FFFFFFFFh
  je .lclose
  mov [gFileSize],eax
  test eax,eax
  jne .lmap
  invoke SendMessageA,[gEdit],WM_SETTEXT,0,gZero     ; empty file
  jmp .lclose
.lmap:
  invoke CreateFileMappingA,[hFile],0,PAGE_READONLY,0,0,0
  test eax,eax
  je .lclose
  mov [hMap],eax
  invoke MapViewOfFile,eax,FILE_MAP_READ,0,0,0
  test eax,eax
  je .lclosemap
  mov [gMapBase],eax
  mov dword [gMapOff],0
  lea edi,[estrm]
  mov ecx,sizeof.EDITSTREAM/4
  xor eax,eax
  rep stosd
  mov [estrm.pfnCallback],StreamCallback
  lea eax,[estrm]
  invoke SendMessageA,[gEdit],EM_STREAMIN,SF_TEXT,eax
  lea eax,[cfmt]
  invoke SendMessageA,[gEdit],EM_SETCHARFORMAT,SCF_ALL,eax
  invoke UnmapViewOfFile,[gMapBase]
.lclosemap:
  invoke CloseHandle,[hMap]
.lclose:
  invoke CloseHandle,[hFile]
.ldone:
  ret

; EM_STREAMIN callback: copy min(cb, remaining) bytes from the mapped view.
proc StreamCallback cookie,pbBuff,cb,pcb
  push ebx esi edi
  mov edx,[gMapOff]
  mov ebx,[gFileSize]
  sub ebx,edx                  ; ebx = bytes remaining
  jz .sd
  mov eax,[cb]
  cmp ebx,eax
  jle .tk
  mov ebx,eax                  ; ebx = min(remaining, cb)
.tk:
  mov eax,edx
  add eax,ebx
  mov [gMapOff],eax            ; advance offset
  mov esi,[gMapBase]
  add esi,edx
  mov edi,[pbBuff]
  mov ecx,ebx
  push ebx
  rep movsb
  pop ebx
  mov eax,[pcb]
  mov [eax],ebx                ; *pcb = bytes written
  xor eax,eax                  ; return 0 = OK
  jmp .sret
.sd:
  mov eax,[pcb]
  mov dword [eax],0            ; *pcb = 0 -> end of stream
  xor eax,eax
.sret:
  pop edi esi ebx
  ret
endp

PushOutFile:
  invoke SendMessageA,[gEdit],WM_GETTEXTLENGTH,0,0
  mov ebx,eax
  lea ecx,[ebx+1]
  invoke GlobalAlloc,GMEM_FIXED,ecx
  test eax,eax
  je .sdone
  mov [hMem],eax
  lea ecx,[ebx+1]
  invoke SendMessageA,[gEdit],WM_GETTEXT,ecx,[hMem]
  invoke CreateFileA,gPath,GENERIC_WRITE,0,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
  cmp eax,INVALID_HANDLE_VALUE
  je .sfree
  mov [hFile],eax
  invoke WriteFile,[hFile],[hMem],ebx,gRead,0
  invoke CloseHandle,[hFile]
  xor eax,eax
  mov [gDirty],eax
  call SetTitle
.sfree:
  invoke GlobalFree,[hMem]
.sdone:
  ret

OfferSave:
  cmp [gDirty],0
  je .cont
  invoke MessageBoxA,[gMain],sSaveAsk,sCap,MB_YESNOCANCEL or MB_ICONQUESTION
  cmp eax,IDCANCEL
  je .cancel
  cmp eax,IDNO
  je .cont
  cmp byte [gPath],0
  jne .save
  call BrowseSave
  test eax,eax
  je .cancel
.save:
  call PushOutFile
.cont:
  mov eax,1
  ret
.cancel:
  xor eax,eax
  ret

DoSave:
  cmp byte [gPath],0
  jne .sav
  call BrowseSave
  test eax,eax
  je .dsret
.sav:
  call PushOutFile
.dsret:
  ret

FreshDoc:
  mov byte [gPath],0
  invoke SendMessageA,[gEdit],WM_SETTEXT,0,gZero
  xor eax,eax
  mov [gDirty],eax
  mov [gNeedTally],1
  call SetTitle
  call UpdateStatus
  ret

BrowseOpen:
  lea edi,[ofn]
  mov ecx,sizeof.OPENFILENAMEA/4
  xor eax,eax
  rep stosd
  mov byte [gPath],0
  mov [ofn.lStructSize],sizeof.OPENFILENAMEA
  mov eax,[gMain]
  mov [ofn.hwndOwner],eax
  mov [ofn.lpstrFilter],sFilter
  mov [ofn.lpstrFile],gPath
  mov [ofn.nMaxFile],ARG_MAX
  mov [ofn.Flags],OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_HIDEREADONLY
  lea eax,[ofn]
  invoke GetOpenFileNameA,eax
  ret

BrowseSave:
  lea edi,[ofn]
  mov ecx,sizeof.OPENFILENAMEA/4
  xor eax,eax
  rep stosd
  mov [ofn.lStructSize],sizeof.OPENFILENAMEA
  mov eax,[gMain]
  mov [ofn.hwndOwner],eax
  mov [ofn.lpstrFilter],sFilter
  mov [ofn.lpstrFile],gPath
  mov [ofn.nMaxFile],ARG_MAX
  mov [ofn.Flags],OFN_PATHMUSTEXIST or OFN_HIDEREADONLY or OFN_OVERWRITEPROMPT
  lea eax,[ofn]
  invoke GetSaveFileNameA,eax
  ret

StampTime:
  lea eax,[sysTime]
  invoke GetLocalTime,eax
  lea eax,[sysTime]
  invoke GetDateFormatA,LOCALE_USER_DEFAULT,DATE_SHORTDATE,eax,0,gDate,32
  lea eax,[sysTime]
  invoke GetTimeFormatA,LOCALE_USER_DEFAULT,0,eax,0,gTime,32
  invoke SendMessageA,[gEdit],EM_REPLACESEL,TRUE,gDate
  invoke SendMessageA,[gEdit],EM_REPLACESEL,TRUE,gSpace
  invoke SendMessageA,[gEdit],EM_REPLACESEL,TRUE,gTime
  ret

FlipWrap:
  cmp [gWrap],0
  je .won
  mov dword [gWrap],0
  invoke SendMessageA,[gEdit],EM_SETTARGETDEVICE,0,-1
  call SyncMenuChecks
  ret
.won:
  mov dword [gWrap],1
  invoke SendMessageA,[gEdit],EM_SETTARGETDEVICE,0,0
  call SyncMenuChecks
  ret

ChooseFont:
  lea edi,[cf]
  mov ecx,sizeof.CHOOSEFONTW/4
  xor eax,eax
  rep stosd
  lea edi,[lf]
  mov ecx,sizeof.LOGFONTW/4
  xor eax,eax
  rep stosd
  mov [cf.lStructSize],sizeof.CHOOSEFONTW
  mov eax,[gMain]
  mov [cf.hwndOwner],eax
  lea eax,[lf]
  mov [cf.lpLogFont],eax
  mov [cf.Flags],CF_SCREENFONTS or CF_EFFECTS
  lea eax,[cf]
  invoke ChooseFontW,eax
  test eax,eax
  je .fcancel
  lea edi,[cfmt]
  mov ecx,sizeof.CHARFORMATW/4
  xor eax,eax
  rep stosd
  mov [cfmt.cbSize],sizeof.CHARFORMATW
  mov [cfmt.dwMask],CFM_FACE or CFM_SIZE or CFM_BOLD or CFM_ITALIC
  xor edx,edx
  cmp [lf.lfWeight],700
  jl .fnb
  or edx,CFE_BOLD
.fnb:
  cmp [lf.lfItalic],0
  je .fni
  or edx,CFE_ITALIC
.fni:
  mov [cfmt.dwEffects],edx
  mov eax,[cf.iPointSize]
  add eax,eax
  mov [cfmt.yHeight],eax
  lea esi,[lf.lfFaceName]
  lea edi,[cfmt.szFaceName]
  mov ecx,LF_FACESIZE
.fcp:
  mov ax,[esi]
  mov [edi],ax
  add esi,2
  add edi,2
  test ax,ax
  je .fapply
  dec ecx
  jnz .fcp
.fapply:
  lea eax,[cfmt]
  invoke SendMessageA,[gEdit],EM_SETCHARFORMAT,SCF_ALL,eax
.fcancel:
  ret

FindInit:
  lea edi,[fr]
  mov ecx,sizeof.FINDREPLACEA/4
  xor eax,eax
  rep stosd
  mov [fr.lStructSize],sizeof.FINDREPLACEA
  mov eax,[gMain]
  mov [fr.hwndOwner],eax
  mov [fr.lpstrFindWhat],gFindWhat
  mov [fr.wFindWhatLen],256
  mov [fr.lpstrReplaceWith],gReplWith
  mov [fr.wReplaceWithLen],256
  mov [fr.Flags],FR_DOWN
  ret

FindNext:
  lea eax,[cr]
  invoke SendMessageA,[gEdit],EM_EXGETSEL,0,eax
  mov eax,[cr.cpMax]
  mov [ft.fMin],eax
  mov dword [ft.fMax],-1
  mov dword [ft.fText],gFindWhat
  mov eax,[fr.Flags]
  and eax,FR_MATCHCASE or FR_WHOLEWORD
  or eax,FR_DOWN
  lea edx,[ft]
  invoke SendMessageA,[gEdit],EM_FINDTEXTEX,eax,edx
  cmp eax,-1
  je .fnmiss
  lea edx,[ft.tMin]
  invoke SendMessageA,[gEdit],EM_EXSETSEL,0,edx
  invoke SendMessageA,[gEdit],EM_SCROLLCARET,0,0
  mov eax,1
  ret
.fnmiss:
  xor eax,eax
  ret

ReplaceOne:
  invoke SendMessageA,[gEdit],EM_REPLACESEL,TRUE,gReplWith
  call FindNext
  ret

ReplaceAll:
  mov dword [cr.cpMin],0
  mov dword [cr.cpMax],0
  lea eax,[cr]
  invoke SendMessageA,[gEdit],EM_EXSETSEL,0,eax
.rloop:
  call FindNext
  test eax,eax
  jz .rdone
  invoke SendMessageA,[gEdit],EM_REPLACESEL,TRUE,gReplWith
  jmp .rloop
.rdone:
  ret

OnFindMsg:
  mov eax,[fr.Flags]
  test eax,FR_DIALOGTERM
  jz .nt
  mov dword [gFindDlg],0
  ret
.nt:
  test eax,FR_REPLACEALL
  jz .nra
  call ReplaceAll
  ret
.nra:
  test eax,FR_REPLACE
  jz .jf
  call ReplaceOne
  ret
.jf:
  call FindNext
  ret

PrintDoc:
  lea edi,[pd]
  mov ecx,sizeof.PRINTDLGA
  xor eax,eax
  rep stosb
  mov [pd.lStructSize],sizeof.PRINTDLGA
  mov eax,[gMain]
  mov [pd.hwndOwner],eax
  mov [pd.Flags],PD_RETURNDC or PD_NOPAGENUMS or PD_NOSELECTION
  lea eax,[pd]
  invoke PrintDlgA,eax
  test eax,eax
  je .pcancel
  mov eax,[pd.hDC]
  mov [hPrnDC],eax
  lea edi,[docInf]
  mov ecx,sizeof.DOCINFOA
  xor eax,eax
  rep stosb
  mov [docInf.cbSize],sizeof.DOCINFOA
  mov [docInf.lpszDocName],sDoc
  lea eax,[docInf]
  invoke StartDocA,[hPrnDC],eax
  lea edi,[pfmt]
  mov ecx,sizeof.FORMATRANGE
  xor eax,eax
  rep stosb
  mov eax,[hPrnDC]
  mov [pfmt.hdc],eax
  mov [pfmt.hdcTarget],eax
  invoke GetDeviceCaps,[hPrnDC],HORZRES
  mov esi,eax
  invoke GetDeviceCaps,[hPrnDC],LOGPIXELSX
  mov ecx,eax
  mov eax,esi
  imul eax,1440
  xor edx,edx
  div ecx
  mov [pfmt.rcR],eax
  mov [pfmt.pgR],eax
  invoke GetDeviceCaps,[hPrnDC],VERTRES
  mov esi,eax
  invoke GetDeviceCaps,[hPrnDC],LOGPIXELSY
  mov ecx,eax
  mov eax,esi
  imul eax,1440
  xor edx,edx
  div ecx
  mov [pfmt.rcB],eax
  mov [pfmt.pgB],eax
  invoke SendMessageA,[gEdit],WM_GETTEXTLENGTH,0,0
  mov [txtLen],eax
  mov [pfmt.rMin],0
  mov [pfmt.rMax],eax
.ppage:
  invoke StartPage,[hPrnDC]
  lea eax,[pfmt]
  invoke SendMessageA,[gEdit],EM_FORMATRANGE,TRUE,eax
  mov [pfmt.rMin],eax
  push eax
  invoke EndPage,[hPrnDC]
  pop eax
  cmp eax,[txtLen]
  jl .ppage
  invoke SendMessageA,[gEdit],EM_FORMATRANGE,FALSE,0
  invoke EndDoc,[hPrnDC]
  invoke DeleteDC,[hPrnDC]
.pcancel:
  ret

PaperSetup:
  lea edi,[psd]
  mov ecx,sizeof.PAGESETUPDLGA
  xor eax,eax
  rep stosb
  mov [psd.lStructSize],sizeof.PAGESETUPDLGA
  mov eax,[gMain]
  mov [psd.hwndOwner],eax
  lea eax,[psd]
  invoke PageSetupDlgA,eax
  ret

UpdateStatus:
  cmp [gStatOn],0
  je .usd
  invoke SendMessageA,[gEdit],WM_GETTEXTLENGTH,0,0
  mov [gChars],eax
  cmp [gNeedTally],0
  je .have
  call TallyWords
.have:
  lea eax,[cr]
  invoke SendMessageA,[gEdit],EM_EXGETSEL,0,eax
  mov eax,[cr.cpMax]
  invoke SendMessageA,[gEdit],EM_EXLINEFROMCHAR,eax,0
  mov esi,eax
  invoke SendMessageA,[gEdit],EM_LINEINDEX,esi,0
  mov edx,[cr.cpMax]
  sub edx,eax
  inc edx
  inc esi
  cinvoke wsprintfA,gStatLine,sLnCol,esi,edx,[gChars],[gWords],[gZoom]
  invoke SetWindowTextA,[gStat],gStatLine
.usd:
  ret

TallyWords:
  push ebp esi ebx
  mov [gNeedTally],0
  mov eax,[gChars]
  inc eax
  invoke GlobalAlloc,GMEM_FIXED,eax
  test eax,eax
  je .twr0
  mov ebp,eax
  mov ecx,[gChars]
  inc ecx
  invoke SendMessageA,[gEdit],WM_GETTEXT,ecx,ebp
  mov esi,ebp
  xor edx,edx
  mov ebx,1
.twlp:
  mov al,[esi]
  test al,al
  je .twdn
  cmp al,' '
  je .tws
  cmp al,9
  je .tws
  cmp al,10
  je .tws
  cmp al,13
  je .tws
  cmp ebx,0
  jne .twnw
  jmp .twnxt
.twnw:
  inc edx
  mov ebx,0
  jmp .twnxt
.tws:
  mov ebx,1
.twnxt:
  inc esi
  jmp .twlp
.twdn:
  mov [gWords],edx
  invoke GlobalFree,ebp
.twr0:
  pop ebx esi ebp
  ret

ApplyZoom:
  invoke SendMessageA,[gEdit],EM_SETZOOM,[gZoom],100
  invoke InvalidateRect,[gEdit],0,FALSE
  ret

ZoomIn:
  add dword [gZoom],45
  cmp dword [gZoom],630
  jle .zin
  mov dword [gZoom],630
.zin:
  call ApplyZoom
  call UpdateStatus
  ret

ZoomOut:
  sub dword [gZoom],45
  cmp dword [gZoom],10
  jge .zok
  mov dword [gZoom],10
.zok:
  call ApplyZoom
  call UpdateStatus
  ret

ZoomReset:
  mov dword [gZoom],100
  call ApplyZoom
  call UpdateStatus
  ret

; load saved Zoom + Dark from HKCU\Software\NoteGrit (REG_DWORD each);
; clamp zoom to [10..630], dark to 0/1. Missing/absent values leave defaults.
LoadAll:
  invoke RegCreateKeyExA,HKEY_CURRENT_USER,sRegKey,0,0,0,KEY_ALL_ACCESS,0,gReg,gDisp
  test eax,eax
  jne .ladone
  mov dword [gRegCb],4
  invoke RegQueryValueExA,[gReg],sRegZoom,0,gRegType,gZoom,gRegCb
  mov dword [gRegCb],4
  invoke RegQueryValueExA,[gReg],sRegDark,0,gRegType,gDark,gRegCb
  invoke RegCloseKey,[gReg]
  mov eax,[gZoom]
  cmp eax,10
  jge .lalo
  mov eax,100
  jmp .laset
.lalo:
  cmp eax,630
  jle .laset
  mov eax,630
.laset:
  mov [gZoom],eax
  mov eax,[gDark]
  test eax,eax
  jz .lad0
  mov dword [gDark],1
  jmp .ladone
.lad0:
  mov dword [gDark],0
.ladone:
  ret

; persist current Zoom + Dark to HKCU\Software\NoteGrit
SaveAll:
  invoke RegCreateKeyExA,HKEY_CURRENT_USER,sRegKey,0,0,0,KEY_ALL_ACCESS,0,gReg,gDisp
  test eax,eax
  jne .sadone
  invoke RegSetValueExA,[gReg],sRegZoom,0,REG_DWORD,gZoom,4
  invoke RegSetValueExA,[gReg],sRegDark,0,REG_DWORD,gDark,4
  invoke RegCloseKey,[gReg]
.sadone:
  ret

DoAccel:
  mov eax,[msg.wParam]
  cmp eax,VK_F3
  je .anext
  cmp eax,VK_F5
  je .atime
  invoke GetKeyState,VK_CONTROL
  test ah,80h
  jz .anone
  mov eax,[msg.wParam]
  cmp eax,'N'
  je .anew
  cmp eax,'O'
  je .aopen
  cmp eax,'S'
  je .asave
  cmp eax,'P'
  je .aprint
  cmp eax,'F'
  je .afind
  cmp eax,'H'
  je .areplace
  cmp eax,'G'
  je .agoto
  cmp eax,'A'
  je .asellall
  cmp eax,VK_OEM_PLUS
  je .azin
  cmp eax,VK_OEM_MINUS
  je .azout
  cmp eax,'0'
  je .az0
  jmp .anone
.asave:
  invoke GetKeyState,VK_SHIFT
  test ah,80h
  jnz .asaveas
  mov ecx,CID_SAVE
  jmp .asend
.asaveas:
  mov ecx,CID_SAVEAS
  jmp .asend
.anew:    mov ecx,CID_NEW
          jmp .asend
.aopen:   mov ecx,CID_OPEN
          jmp .asend
.aprint:  mov ecx,CID_PRINT
          jmp .asend
.afind:   mov ecx,CID_FIND
          jmp .asend
.areplace:mov ecx,CID_REPLACE
          jmp .asend
.agoto:   mov ecx,CID_GOTO
          jmp .asend
.asellall:mov ecx,CID_SELALL
          jmp .asend
.anext:   mov ecx,CID_FINDNEXT
          jmp .asend
.atime:   mov ecx,CID_TIME
          jmp .asend
.asend:
  invoke SendMessageA,[gMain],WM_COMMAND,ecx,0
  jmp .adone1
.azin:
  call ZoomIn
  jmp .adone1
.azout:
  call ZoomOut
  jmp .adone1
.az0:
  call ZoomReset
  jmp .adone1
.adone1:
  mov eax,1
  ret
.anone:
  xor eax,eax
  ret

Relayout:
  lea eax,[wrc]
  invoke GetClientRect,[gMain],eax
  mov ecx,[wrc.right]
  and ecx,0FFFFh
  mov eax,[wrc.bottom]
  shl eax,16
  or eax,ecx
  invoke SendMessageA,[gMain],WM_SIZE,0,eax
  ret

proc AddItem hMenu,cid,pText
  call ODFlag
  mov [gOD],eax
  invoke AppendMenuA,[hMenu],[gOD],[cid],[pText]
  ret
endp

proc AddGap hMenu
  invoke AppendMenuA,[hMenu],MF_SEPARATOR,0,0
  ret
endp

proc BuildMenus hWnd
  call ODFlag
  or eax,MF_POPUP
  mov [gPop],eax
  invoke CreateMenu
  mov edi,eax
  invoke CreatePopupMenu
  mov esi,eax
  stdcall AddItem,esi,CID_NEW,sMNew
  stdcall AddItem,esi,CID_OPEN,sMOpen
  stdcall AddItem,esi,CID_SAVE,sMSave
  stdcall AddItem,esi,CID_SAVEAS,sMSaveA
  stdcall AddGap,esi
  stdcall AddItem,esi,CID_PAGESET,sMPage
  stdcall AddItem,esi,CID_PRINT,sMPrint
  stdcall AddGap,esi
  stdcall AddItem,esi,CID_EXIT,sMExit
  invoke AppendMenuA,edi,[gPop],esi,sFile
  invoke CreatePopupMenu
  mov esi,eax
  stdcall AddItem,esi,CID_UNDO,sMUndo
  stdcall AddGap,esi
  stdcall AddItem,esi,CID_CUT,sMCut
  stdcall AddItem,esi,CID_COPY,sMCopy
  stdcall AddItem,esi,CID_PASTE,sMPaste
  stdcall AddItem,esi,CID_DELETE,sMDel
  stdcall AddGap,esi
  stdcall AddItem,esi,CID_FIND,sMFind
  stdcall AddItem,esi,CID_FINDNEXT,sMNext
  stdcall AddItem,esi,CID_REPLACE,sMRepl
  stdcall AddItem,esi,CID_GOTO,sMGoTo
  stdcall AddGap,esi
  stdcall AddItem,esi,CID_SELALL,sMSel
  stdcall AddItem,esi,CID_TIME,sMTime
  invoke AppendMenuA,edi,[gPop],esi,sEdit
  invoke CreatePopupMenu
  mov esi,eax
  stdcall AddItem,esi,CID_WRAP,sMWrap
  stdcall AddItem,esi,CID_FONT,sMFont
  invoke AppendMenuA,edi,[gPop],esi,sFmt
  invoke CreatePopupMenu
  mov esi,eax
  stdcall AddItem,esi,CID_STATUS,sMStat
  stdcall AddItem,esi,CID_DARK,sMDark
  stdcall AddGap,esi
  stdcall AddItem,esi,CID_ZOOMIN,sMZIn
  stdcall AddItem,esi,CID_ZOOMOUT,sMZOut
  stdcall AddItem,esi,CID_ZOOMRST,sMZRst
  invoke AppendMenuA,edi,[gPop],esi,sView
  invoke CreatePopupMenu
  mov esi,eax
  stdcall AddItem,esi,CID_ABOUT,sMAbout
  invoke AppendMenuA,edi,[gPop],esi,sHelp
  invoke SetMenu,[hWnd],edi
  ret
endp

proc RightClickMenu owner
  invoke CreatePopupMenu
  mov edi,eax
  call ODFlag
  mov [gOD],eax
  invoke AppendMenuA,edi,[gOD],CID_UNDO,sMUndo
  invoke AppendMenuA,edi,MF_SEPARATOR,0,0
  invoke AppendMenuA,edi,[gOD],CID_CUT,sMCut
  invoke AppendMenuA,edi,[gOD],CID_COPY,sMCopy
  invoke AppendMenuA,edi,[gOD],CID_PASTE,sMPaste
  invoke AppendMenuA,edi,[gOD],CID_DELETE,sMDel
  invoke AppendMenuA,edi,MF_SEPARATOR,0,0
  invoke AppendMenuA,edi,[gOD],CID_SELALL,sMSel
  invoke GetMessagePos
  movzx ecx,ax
  shr eax,16
  invoke TrackPopupMenu,edi,0,ecx,eax,0,[owner],0
  invoke DestroyMenu,edi
  ret
endp

proc GoDlgProc hDlg,uMsg,wParam,lParam
  cmp [uMsg],WM_INITDIALOG
  je .gtrue
  cmp [uMsg],WM_COMMAND
  jne .gfalse
  mov eax,[wParam]
  and eax,0FFFFh
  cmp eax,IDOK
  je .gok
  cmp eax,IDCANCEL
  jne .gfalse
  invoke EndDialog,[hDlg],0
  jmp .gtrue
.gok:
  invoke GetDlgItemInt,[hDlg],GOEDIT_ID,0,FALSE
  invoke EndDialog,[hDlg],eax
.gtrue:
  mov eax,1
  ret
.gfalse:
  xor eax,eax
  ret
endp

JumpDialog:
  invoke DialogBoxIndirectParamA,[gInst],GoDlg,[gMain],GoDlgProc,0
  test eax,eax
  je .jdone
  dec eax
  invoke SendMessageA,[gEdit],EM_LINEINDEX,eax,0
  cmp eax,-1
  je .jdone
  mov dword [cr.cpMin],eax
  mov dword [cr.cpMax],eax
  lea edx,[cr]
  invoke SendMessageA,[gEdit],EM_EXSETSEL,0,edx
  invoke SendMessageA,[gEdit],EM_SCROLLCARET,0,0
  invoke SetFocus,[gEdit]
.jdone:
  ret

proc AboutProc hDlg,uMsg,wParam,lParam
  cmp [uMsg],WM_INITDIALOG
  je .init
  cmp [uMsg],WM_CTLCOLORSTATIC
  je .color
  cmp [uMsg],WM_COMMAND
  je .cmd
  xor eax,eax
  ret
.init:
  cinvoke wsprintfA,sCapBuf,sCapFmt,sVer
  invoke SetWindowTextA,[hDlg],sCapBuf
  mov eax,1
  ret
.color:
  invoke GetDlgCtrlID,[lParam]
  cmp eax,LID_GH
  je .link
  cmp eax,LID_WEB
  je .link
  cmp eax,LID_FB
  je .link
  xor eax,eax
  ret
.link:
  invoke SetTextColor,[wParam],BLUE
  invoke SetBkMode,[wParam],TRANSPARENT
  invoke GetSysColorBrush,COLOR_BTNFACE
  ret
.cmd:
  mov eax,[wParam]
  and eax,0FFFFh
  cmp eax,IDOK
  je .end
  cmp eax,IDCANCEL
  je .end
  cmp eax,LID_GH
  je .gh
  cmp eax,LID_WEB
  je .web
  cmp eax,LID_FB
  je .fb
  xor eax,eax
  ret
.gh:
  invoke ShellExecuteA,[hDlg],sOpen,sUrlGh,0,0,SW_SHOWNORMAL
  jmp .c0
.web:
  invoke ShellExecuteA,[hDlg],sOpen,sUrlWeb,0,0,SW_SHOWNORMAL
  jmp .c0
.fb:
  invoke ShellExecuteA,[hDlg],sOpen,sUrlFb,0,0,SW_SHOWNORMAL
  jmp .c0
.end:
  invoke EndDialog,[hDlg],0
.c0:
  xor eax,eax
  ret
endp

proc WndProc hWnd,uMsg,wParam,lParam
  cmp [uMsg],WM_CREATE
  jne .ncrt
  ; gMain is normally set after CreateWindowEx returns (Main:), but WM_CREATE fires
  ; DURING it -- so StyleMenus/SyncMenuChecks (which use gMain) must have it now,
  ; else a restored dark mode leaves the menu bar light at boot.
  mov eax,[hWnd]
  mov [gMain],eax
  invoke CreateWindowExA,0,gEd,0,WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or ES_MULTILINE or ES_AUTOVSCROLL or WS_VSCROLL,0,0,0,0,[hWnd],0,[gInst],0
  mov [gEdit],eax
  invoke SetWindowLongA,[gEdit],GWL_WNDPROC,EditProc
  mov [gOldEditProc],eax
  invoke SendMessageA,[gEdit],EM_SETEVENTMASK,0,ENM_CHANGE or ENM_MOUSEEVENTS or ENM_SELCHANGE
  invoke SendMessageA,[gEdit],EM_EXLIMITTEXT,0,07FFFFFFEh
  lea edi,[cfmt]
  mov ecx,sizeof.CHARFORMATW/4
  xor eax,eax
  rep stosd
  mov [cfmt.cbSize],sizeof.CHARFORMATW
  mov [cfmt.dwMask],CFM_FACE
  lea esi,[sFace]
  lea edi,[cfmt.szFaceName]
  mov ecx,LF_FACESIZE
.fcpl:
  mov ax,[esi]
  mov [edi],ax
  add esi,2
  add edi,2
  test ax,ax
  je .fcdone
  dec ecx
  jnz .fcpl
.fcdone:
  lea eax,[cfmt]
  invoke SendMessageA,[gEdit],EM_SETCHARFORMAT,SCF_ALL,eax
  call LoadAll
  call ApplyZoom
  call ApplyDark
  invoke GetSystemMenu,[hWnd],FALSE
  invoke AppendMenuA,eax,MF_STRING,CID_SAVE,gSave
  stdcall BuildMenus,[hWnd]
  invoke CreateSolidBrush,DARK_BG
  mov [gBrDarkBg],eax
  invoke CreateSolidBrush,DARK_MENUHI
  mov [gBrDarkSel],eax
  stdcall StyleMenus
  call SyncMenuChecks
  invoke CreateWindowExA,WS_EX_STATICEDGE,sStatic,0,WS_CHILD or WS_VISIBLE,0,0,0,0,[hWnd],0,[gInst],0
  mov [gStat],eax
  call UpdateStatus
  xor eax,eax
  ret
.ncrt:
  cmp [uMsg],WM_MEASUREITEM
  jne .nmi
  stdcall OnMeasure,[lParam]
  ret
.nmi:
  cmp [uMsg],WM_DRAWITEM
  jne .ndi
  stdcall OnDraw,[lParam]
  ret
.ndi:
  mov eax,[gFindMsg]
  cmp [uMsg],eax
  jne .nfm
  call OnFindMsg
  xor eax,eax
  ret
.nfm:
  cmp [uMsg],WM_SYSCOMMAND
  jne .nsc
  mov eax,[wParam]
  and eax,0FFF0h
  cmp eax,CID_SAVE
  jne .nsc
  call DoSave
  xor eax,eax
  ret
.nsc:
  cmp [uMsg],WM_COMMAND
  jne .ncmd
  mov eax,[wParam]
  shr eax,16
  cmp ax,EN_CHANGE
  je .dirty
  mov eax,[wParam]
  and eax,0FFFFh
  cmp eax,CID_NEW
  je .cnew
  cmp eax,CID_OPEN
  je .copen
  cmp eax,CID_SAVE
  je .csave
  cmp eax,CID_SAVEAS
  je .csaveas
  cmp eax,CID_PRINT
  je .cprint
  cmp eax,CID_PAGESET
  je .cpage
  cmp eax,CID_EXIT
  je .cexit
  cmp eax,CID_UNDO
  je .cundo
  cmp eax,CID_CUT
  je .ccut
  cmp eax,CID_COPY
  je .ccopy
  cmp eax,CID_PASTE
  je .cpaste
  cmp eax,CID_DELETE
  je .cdel
  cmp eax,CID_SELALL
  je .csel
  cmp eax,CID_TIME
  je .ctime
  cmp eax,CID_FIND
  je .cfind
  cmp eax,CID_FINDNEXT
  je .cnext
  cmp eax,CID_REPLACE
  je .crepl
  cmp eax,CID_GOTO
  je .cgoto
  cmp eax,CID_WRAP
  je .cwrap
  cmp eax,CID_FONT
  je .cfont
  cmp eax,CID_STATUS
  je .cstat
  IF FEAT_DARKMODE
  cmp eax,CID_DARK
  je .cdark
  END IF
  cmp eax,CID_ZOOMIN
  je .czin
  cmp eax,CID_ZOOMOUT
  je .czout
  cmp eax,CID_ZOOMRST
  je .czrst
  cmp eax,CID_ABOUT
  je .cabout
  jmp .cdone
.cnew:
  call OfferSave
  test eax,eax
  je .cdone
  call FreshDoc
  jmp .cret0
.copen:
  call OfferSave
  test eax,eax
  je .cdone
  call BrowseOpen
  test eax,eax
  je .cdone
  call PullInFile
  xor eax,eax
  mov [gDirty],eax
  mov [gNeedTally],1
  call SetTitle
  call UpdateStatus
  jmp .cret0
.csave:
  call DoSave
  jmp .cret0
.csaveas:
  call BrowseSave
  test eax,eax
  je .cdone
  call PushOutFile
  jmp .cret0
.cprint:
  call PrintDoc
  jmp .cret0
.cpage:
  call PaperSetup
  jmp .cret0
.cexit:
  call OfferSave
  test eax,eax
  je .cdone
  invoke DestroyWindow,[hWnd]
  jmp .cret0
.cundo:
  invoke SendMessageA,[gEdit],WM_UNDO,0,0
  jmp .cret0
.ccut:
  invoke SendMessageA,[gEdit],WM_CUT,0,0
  jmp .cret0
.ccopy:
  invoke SendMessageA,[gEdit],WM_COPY,0,0
  jmp .cret0
.cpaste:
  invoke SendMessageA,[gEdit],WM_PASTE,0,0
  jmp .cret0
.cdel:
  invoke SendMessageA,[gEdit],WM_CLEAR,0,0
  jmp .cret0
.csel:
  invoke SetFocus,[gEdit]
  invoke SendMessageA,[gEdit],EM_SETSEL,0,-1
  jmp .cret0
.ctime:
  invoke SetFocus,[gEdit]
  call StampTime
  jmp .cret0
.cfind:
  call FindInit
  lea eax,[fr]
  invoke FindTextA,eax
  mov [gFindDlg],eax
  jmp .cret0
.cnext:
  call FindNext
  jmp .cret0
.crepl:
  call FindInit
  lea eax,[fr]
  invoke ReplaceTextA,eax
  mov [gFindDlg],eax
  jmp .cret0
.cgoto:
  call JumpDialog
  jmp .cret0
.cwrap:
  call FlipWrap
  jmp .cret0
.cfont:
  call ChooseFont
  jmp .cret0
.cstat:
  xor eax,eax
  cmp [gStatOn],eax
  jne .stoff
  mov dword [gStatOn],1
  invoke ShowWindow,[gStat],SW_SHOW
  jmp .stlay
.stoff:
  mov dword [gStatOn],0
  invoke ShowWindow,[gStat],SW_HIDE
.stlay:
  call Relayout
  call UpdateStatus
  call SyncMenuChecks
  jmp .cret0
IF FEAT_DARKMODE
.cdark:
  call ToggleDark
  jmp .cret0
END IF
.czin:
  call ZoomIn
  jmp .cret0
.czout:
  call ZoomOut
  jmp .cret0
.czrst:
  call ZoomReset
  jmp .cret0
.cabout:
  invoke DialogBoxIndirectParamA,[gInst],AboutDlg,[hWnd],AboutProc,0
  jmp .cret0
.cret0:
  xor eax,eax
  ret
.dirty:
  cmp [gDirty],0
  jne .cdone
  mov dword [gDirty],1
  mov dword [gNeedTally],1
  call SetTitle
.cdone:
  xor eax,eax
  ret
.ncmd:
  cmp [uMsg],WM_NOTIFY
  jne .nnotify
  mov edx,[lParam]
  mov eax,[edx+8]
  cmp eax,EN_SELCHANGE
  jne .nsel
  call UpdateStatus
  jmp .nret0
.nsel:
  cmp eax,EN_MSGFILTER
  jne .nret0
  cmp dword [edx+12],0205h
  jne .nret0
  stdcall RightClickMenu,[hWnd]
  mov eax,1
  ret
.nret0:
  xor eax,eax
  ret
.nnotify:
  cmp [uMsg],WM_SIZE
  jne .nsize
  mov edx,[lParam]
  movzx esi,dx
  shr edx,16
  mov edi,edx
  cmp [gStatOn],0
  je .sedit
  sub edi,STAT_H
  invoke SetWindowPos,[gStat],0,0,edi,esi,STAT_H,SWP_NOZORDER
.sedit:
  invoke SetWindowPos,[gEdit],0,0,0,esi,edi,SWP_NOZORDER
  xor eax,eax
  ret
.nsize:
  cmp [uMsg],WM_DESTROY
  jne .ndestroy
  call SaveAll
  invoke PostQuitMessage,0
  xor eax,eax
  ret
.ndestroy:
  invoke DefWindowProcA,[hWnd],[uMsg],[wParam],[lParam]
  ret
endp

; apply editor bg/text colour for current gDark (no menu rebuild). Boot + toggle use it.
ApplyDark:
  lea edi,[cfmt]
  mov ecx,sizeof.CHARFORMATW/4
  xor eax,eax
  rep stosd
  mov [cfmt.cbSize],sizeof.CHARFORMATW
  mov [cfmt.dwMask],CFM_COLOR
  cmp [gDark],0
  je .adoff
  invoke SendMessageA,[gEdit],EM_SETBKGNDCOLOR,0,DARK_BG
  mov dword [cfmt.crTextColor],DARK_FG
  jmp .adapply
.adoff:
  invoke SendMessageA,[gEdit],EM_SETBKGNDCOLOR,1,0
  mov dword [cfmt.dwEffects],CFE_AUTOCOLOR
.adapply:
  lea eax,[cfmt]
  invoke SendMessageA,[gEdit],EM_SETCHARFORMAT,SCF_ALL,eax
  ret

ToggleDark:
  mov eax,[gDark]
  xor eax,1
  mov [gDark],eax
  call ApplyDark
  ; rebuild the menu so it switches native (light) <-> owner-draw (dark)
  invoke GetMenu,[gMain]
  push eax
  stdcall BuildMenus,[gMain]
  call SyncMenuChecks
  pop eax
  invoke DestroyMenu,eax
  stdcall StyleMenus
  ret

proc StyleMenus
  lea edi,[gmi]
  mov ecx,sizeof.MENUINFO/4
  xor eax,eax
  rep stosd
  mov [gmi.cbSize],sizeof.MENUINFO
  mov [gmi.fMask],MIM_BACKGROUND or MIM_APPLYTOSUBMENUS
  cmp [gDark],0
  je .sml
  mov eax,[gBrDarkBg]
  jmp .sms
.sml:
  invoke GetSysColorBrush,COLOR_MENU
.sms:
  mov [gmi.hbrBack],eax
  invoke GetMenu,[gMain]
  invoke SetMenuInfo,eax,gmi
  invoke DrawMenuBar,[gMain]
  ret
endp

; eax = MF_OWNERDRAW if dark mode else MF_STRING(0). Drives conditional owner-draw:
; light mode -> native menus (exact system spacing + native check marks), dark -> styled.
ODFlag:
  xor eax,eax
  cmp [gDark],0
  je .x
  mov eax,MF_OWNERDRAW
.x:
  ret

; Re-apply Word Wrap / Status Bar / Dark Mode check marks (native menus show them;
; owner-draw dark menus carry the state but don't render the glyph yet).
SyncMenuChecks:
  push ebx
  invoke GetMenu,[gMain]
  mov ebx,eax
  mov edx,MF_BYCOMMAND
  cmp [gWrap],0
  je .w
  or edx,MF_CHECKED
.w:
  invoke CheckMenuItem,ebx,CID_WRAP,edx
  mov edx,MF_BYCOMMAND
  cmp [gStatOn],0
  je .s
  or edx,MF_CHECKED
.s:
  invoke CheckMenuItem,ebx,CID_STATUS,edx
  mov edx,MF_BYCOMMAND
  cmp [gDark],0
  je .d
  or edx,MF_CHECKED
.d:
  invoke CheckMenuItem,ebx,CID_DARK,edx
  pop ebx
  ret

proc OnMeasure lpmi
  push ebx esi edi
  mov edx,[lpmi]
  mov esi,[edx+20]            ; itemData = text ptr
  test esi,esi
  jne .mgo
  mov dword [edx+12],12       ; itemWidth
  mov dword [edx+16],18       ; itemHeight
  jmp .mret
.mgo:
  mov edi,esi
  mov ecx,-1
  xor al,al
  repne scasb                 ; strlen(esi)
  not ecx
  dec ecx
  mov edi,ecx                 ; edi = length
  invoke GetDC,[gMain]
  mov ebx,eax
  invoke GetStockObject,DEFAULT_GUI_FONT
  invoke SelectObject,ebx,eax
  invoke GetTextExtentPoint32A,ebx,esi,edi,gts
  invoke ReleaseDC,[gMain],ebx
  mov edx,[lpmi]
  mov eax,[gts.cy]
  add eax,4
  mov [edx+16],eax            ; itemHeight = cy+4
  mov eax,[gts.cx]
  add eax,8
  mov [edx+12],eax            ; itemWidth  = cx+8
.mret:
  pop edi esi ebx
  mov eax,1
  ret
endp

proc OnDraw lpd
  push ebx esi edi
  mov edx,[lpd]
  mov esi,[edx+44]            ; itemData = text ptr
  test esi,esi
  je .dret
  mov ebx,[edx+24]            ; hDC
  mov eax,[edx+16]            ; itemState
  test eax,ODS_SELECTED
  jz .bg
  cmp [gDark],0
  jne .bgsd
  invoke GetSysColorBrush,COLOR_HIGHLIGHT
  jmp .bgs
.bgsd:
  mov eax,[gBrDarkSel]
  jmp .bgs
.bg:
  cmp [gDark],0
  jne .bgd
  invoke GetSysColorBrush,COLOR_MENU
  jmp .bgs
.bgd:
  mov eax,[gBrDarkBg]
.bgs:
  mov edi,eax                 ; brush
  mov edx,[lpd]
  lea eax,[edx+28]            ; &rcItem
  invoke FillRect,ebx,eax,edi
  mov edx,[lpd]
  mov eax,[edx+16]
  test eax,ODS_SELECTED
  jz .tc
  cmp [gDark],0
  jne .tcsd
  invoke GetSysColor,COLOR_HIGHLIGHTTEXT
  invoke SetTextColor,ebx,eax
  jmp .tcs
.tcsd:
  invoke SetTextColor,ebx,DARK_FG
  jmp .tcs
.tc:
  cmp [gDark],0
  jne .tcd
  invoke GetSysColor,COLOR_MENUTEXT
  invoke SetTextColor,ebx,eax
  jmp .tcs
.tcd:
  invoke SetTextColor,ebx,DARK_FG
.tcs:
  invoke SetBkMode,ebx,TRANSPARENT
  mov edx,[lpd]
  mov eax,[edx+28]
  mov [gdrc.left],eax
  mov eax,[edx+32]
  mov [gdrc.top],eax
  mov eax,[edx+36]
  mov [gdrc.right],eax
  mov eax,[edx+40]
  mov [gdrc.bottom],eax
  add dword [gdrc.left],6
  invoke GetStockObject,DEFAULT_GUI_FONT
  invoke SelectObject,ebx,eax
  invoke DrawTextA,ebx,esi,-1,gdrc,DT_VCENTER or DT_SINGLELINE
.dret:
  pop edi esi ebx
  mov eax,1
  ret
endp

; subclassed RichEdit WndProc: Ctrl+wheel zooms (browser-style); plain wheel scrolls.
proc EditProc uses ebx esi edi,hWnd,uMsg,wParam,lParam
  cmp [uMsg],WM_MOUSEWHEEL
  jne .edef
  invoke GetKeyState,VK_CONTROL
  test ah,80h
  jz .edef
  mov eax,[wParam]
  sar eax,16
  cmp eax,0
  jge .ezin
  call ZoomOut
  jmp .edone
.ezin:
  call ZoomIn
.edone:
  xor eax,eax
  ret
.edef:
  invoke CallWindowProcA,[gOldEditProc],[hWnd],[uMsg],[wParam],[lParam]
  ret
endp

data import
  library kernel32,'KERNEL32.DLL',\
          user32,'USER32.DLL',\
          advapi32,'ADVAPI32.DLL',\
          comdlg32,'COMDLG32.DLL',\
          gdi32,'GDI32.DLL',\
          shell32,'SHELL32.DLL'
  import kernel32,\
    GetModuleHandleA,'GetModuleHandleA',\
    LoadLibraryA,'LoadLibraryA',\
    GetCommandLineA,'GetCommandLineA',\
    CreateFileA,'CreateFileA',\
    GetFileSize,'GetFileSize',\
    ReadFile,'ReadFile',\
    WriteFile,'WriteFile',\
    CloseHandle,'CloseHandle',\
    CreateFileMappingA,'CreateFileMappingA',\
    MapViewOfFile,'MapViewOfFile',\
    UnmapViewOfFile,'UnmapViewOfFile',\
    GlobalAlloc,'GlobalAlloc',\
    GlobalFree,'GlobalFree',\
    GetLocalTime,'GetLocalTime',\
    GetDateFormatA,'GetDateFormatA',\
    GetTimeFormatA,'GetTimeFormatA',\
    ExitProcess,'ExitProcess'
  import advapi32,\
    RegCreateKeyExA,'RegCreateKeyExA',\
    RegSetValueExA,'RegSetValueExA',\
    RegQueryValueExA,'RegQueryValueExA',\
    RegCloseKey,'RegCloseKey'
  import user32,\
    RegisterClassA,'RegisterClassA',\
    RegisterWindowMessageA,'RegisterWindowMessageA',\
    CreateWindowExA,'CreateWindowExA',\
    GetMessageA,'GetMessageA',\
    TranslateMessage,'TranslateMessage',\
    DispatchMessageA,'DispatchMessageA',\
    IsDialogMessageA,'IsDialogMessageA',\
    PostQuitMessage,'PostQuitMessage',\
    DefWindowProcA,'DefWindowProcA',\
    SendMessageA,'SendMessageA',\
    SetWindowPos,'SetWindowPos',\
    SetWindowTextA,'SetWindowTextA',\
    GetClientRect,'GetClientRect',\
    ShowWindow,'ShowWindow',\
    GetSystemMenu,'GetSystemMenu',\
    AppendMenuA,'AppendMenuA',\
    CreateMenu,'CreateMenu',\
    CreatePopupMenu,'CreatePopupMenu',\
    SetMenu,'SetMenu',\
    DestroyWindow,'DestroyWindow',\
    DestroyMenu,'DestroyMenu',\
    LoadIconA,'LoadIconA',\
    MessageBoxA,'MessageBoxA',\
    TrackPopupMenu,'TrackPopupMenu',\
    GetMessagePos,'GetMessagePos',\
    GetKeyState,'GetKeyState',\
    CheckMenuItem,'CheckMenuItem',\
    GetMenu,'GetMenu',\
    GetDlgItemInt,'GetDlgItemInt',\
    GetDlgCtrlID,'GetDlgCtrlID',\
    EndDialog,'EndDialog',\
    DialogBoxIndirectParamA,'DialogBoxIndirectParamA',\
    SetFocus,'SetFocus',\
    GetSysColorBrush,'GetSysColorBrush',\
    GetSysColor,'GetSysColor',\
    DrawTextA,'DrawTextA',\
    FillRect,'FillRect',\
    GetDC,'GetDC',\
    ReleaseDC,'ReleaseDC',\
    SetMenuInfo,'SetMenuInfo',\
    DrawMenuBar,'DrawMenuBar',\
    SetWindowLongA,'SetWindowLongA',\
    CallWindowProcA,'CallWindowProcA',\
    InvalidateRect,'InvalidateRect',\
    wsprintfA,'wsprintfA'
  import comdlg32,\
    GetOpenFileNameA,'GetOpenFileNameA',\
    GetSaveFileNameA,'GetSaveFileNameA',\
    ChooseFontW,'ChooseFontW',\
    FindTextA,'FindTextA',\
    ReplaceTextA,'ReplaceTextA',\
    PrintDlgA,'PrintDlgA',\
    PageSetupDlgA,'PageSetupDlgA'
  import gdi32,\
    GetDeviceCaps,'GetDeviceCaps',\
    StartDocA,'StartDocA',\
    StartPage,'StartPage',\
    EndPage,'EndPage',\
    EndDoc,'EndDoc',\
    DeleteDC,'DeleteDC',\
    SetTextColor,'SetTextColor',\
    SetBkMode,'SetBkMode',\
    GetStockObject,'GetStockObject',\
    SelectObject,'SelectObject',\
    GetTextExtentPoint32A,'GetTextExtentPoint32A',\
    CreateSolidBrush,'CreateSolidBrush'
  import shell32,\
    ShellExecuteA,'ShellExecuteA'
end data

; resources: single-entry notegrit.ico embedded via the FASM `icon` macro, which reads
; the image size/offset from the .ico header and writes correct RT_ICON resource entries
; (a hand-built entry gave SizeofResource=0 -> LoadIcon returned NULL -> default icon).
section '.rsrc' resource data readable
  directory RT_ICON,icons,\
            RT_GROUP_ICON,group_icons
  resource icons,1,LANG_NEUTRAL,icon1
  resource group_icons,IDR_ICON,LANG_NEUTRAL,gic
  icon gic, icon1, '..\notegrit.ico'
