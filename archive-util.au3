#include <File.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>
#pragma compile(Icon, 'archive.ico')

; ----------------------------------
Local $path7z = @ScriptDir & '\7-zip\7z.exe'

; ----------------------------------
; 建立列表
Local $fileList = ""
For $i = 1 To $CmdLine[0]
   $fileList = $fileList & ' "' & $CmdLine[$i] & '"'
Next
;MsgBox($MB_SYSTEMMODAL, "", $fileList)

; ----------------------------------

Func addArchive()

   ;MsgBox($MB_SYSTEMMODAL, "", $path7z)

   ; ----------------------------------

   Local $archiveFilename

   ; 如果檔案只有一個，那就以該檔案為名字
   ; 如果檔案有很多個，那就取上層目錄為檔案名字
   If $CmdLine[0] = 0 Then
	  ;MsgBox($MB_SYSTEMMODAL, "", "no file")
	  Exit
   ElseIf $CmdLine[0] = 1 Then
	  Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	  Local $aPathSplit = _PathSplit($CmdLine[1], $sDrive, $sDir, $sFileName, $sExtension)
	  ;MsgBox($MB_SYSTEMMODAL, "", $sFileName)
	  $archiveFilename = $sFileName
   Else
	  ;MsgBox($MB_SYSTEMMODAL, "", "many files")
	  Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	  Local $aPathSplit = _PathSplit($CmdLine[1], $sDrive, $sDir, $sFileName, $sExtension)
	  $sDir = StringTrimRight($sDir, 1)
	  ;MsgBox($MB_SYSTEMMODAL, "", $sDir)
	  $archiveFilename = $sDir
   EndIf

   ; ------------------------------------

   Local $cmd = $path7z & '  a -tzip ' & $archiveFilename & '.zip' & $fileList
   ;MsgBox($MB_SYSTEMMODAL, "", $cmd)
   RunWait($cmd)

   ; ------------------------------------

   For $i = 1 To $CmdLine[0]
	  FileRecycle($CmdLine[$i])
   Next
EndFunc

; ------------------------------------

Func unarchive()
   Local $file = $CmdLine[1]
   MsgBox($MB_SYSTEMMODAL, "", $file)
EndFunc

; ------------------------------------


If $CmdLine[0] = 1 And (StringRight($CmdLine[1], 4) = '.zip') Then
   unarchive()
Else
   addArchive()
EndIf
