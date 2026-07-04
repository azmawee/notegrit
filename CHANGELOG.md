# Changelog

All notable changes to NoteGrit are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.01] - 2026-07-05

Second release. Same source, same binary size, but with two reliability fixes that make
the editor handle large files without running out of memory.

### Added

- The PE header now sets `IMAGE_DLLCHARACTERISTICS_LARGE_ADDRESS_AWARE`. The 32-bit
  process can use up to 4 GB of virtual address space on 64-bit Windows instead of the
  default 2 GB ceiling, which is what lets the editor hold much larger text buffers.

### Changed

- The save path now writes via `EM_STREAMOUT` instead of `WM_GETTEXT` + `GlobalAlloc`.
  This streams the editor text straight to the file in chunks and removes the full-buffer
  allocation that used to fail on large documents.

### Removed

- The previous save path allocated a single buffer the size of the entire document. That
  is gone, replaced by the streaming write above.

## [1.00] - 2026-07-05

First public release. A tiny plain-text editor for Windows 10/11, written in FASM x86
assembly, shipped as a single ~16 KB executable plus a ~17 KB assembly installer.

### Added

- Single-file editor `notegrit.exe` (~16 KB) with no runtime, no .NET, no Electron.
- Classic Notepad-style layout: menu bar, status bar, multi-line editor area.
- **File menu**: New, Open, Save, Save As, Page Setup, Print, Exit.
- **Edit menu**: Undo, Cut, Copy, Paste, Delete, Find, Find Next, Replace, Go To,
  Select All, Time/Date.
- **Format menu**: Word Wrap (toggle, persists), Font (system Font dialog).
- **View menu**: Status Bar (toggle), Dark Mode (toggle, persists), Zoom In/Out/Reset.
- **Help menu**: About dialog with project links.
- Smooth zoom via `Ctrl` + mouse wheel, `Ctrl`+`+` / `Ctrl`+`-` / `Ctrl`+`0`,
  with the live zoom % shown in the status bar. Zoom level is remembered.
- Dark Mode that themes the editor, menu bar, and status bar together, and stays dark
  after close and reopen. Theme preference is remembered.
- Live status bar: line and column, character count, word count, zoom %.
- Large-file loading via chunked `ReadFile` streaming (low peak memory).
- Drag-and-drop file open.
- Command-line file open (`notegrit.exe path\to\file.txt`).
- Portable mode: copy `notegrit.exe` to any folder or USB stick, no install, no registry
  entries, no admin rights.
- Installer `Win_x86_64_Installer.exe` (~17 KB, also FASM assembly) with a setup dialog
  and three options:
  - Add an **"Edit with NoteGrit"** right-click menu for all files.
  - Set NoteGrit as the recommended `.txt` editor (Open With, Default Apps).
  - **Portable** extract-only mode (no registry entries, no uninstaller).
- Win+R support via `App Paths` registration (`notegrit` runs the editor).
- Apps & Features entry with full uninstaller (removes files, App Paths, Open With
  registrations, right-click verb).
- Per-user settings (Dark Mode, Zoom) stored under `HKCU\Software\NoteGrit`, never in
  `Program Files`.

### Security

- Editor requires no admin rights and only ever touches the file you open.
- Installer writes only standard, documented Windows registry keys (App Paths, Open With,
  Apps & Features, an optional `.txt` ProgID and right-click verb), all fully reversible
  via uninstall.
- v1.00 ships **unsigned**. A SignPath Foundation application is pending approval; signed
  release builds will follow from the next release.

### Known Issues

- The tiny size plus minimal import table can trigger AV heuristic false positives
  (`TR/Crypt.XPACK.Gen` style detections) on F-Secure, Avira, and other vendors using the
  Bitdefender engine. See the README's *About antivirus* section for submission links.
- Windows 10/11 blocks silent default-app changes via UserChoice hash protection, so the
  installer registers NoteGrit to *appear* in Open With / Default Apps rather than
  forcing the default.
