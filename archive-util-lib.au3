#include <File.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>

;Local $archiveFormat = 'zip'
;Local $archiveFormat = '7z'

; ----------------------------------

Func archiveMethod($archiveFormat)
   If $CmdLine = 0 Then
	  Exit
   EndIf

   ;$CmdLine[1] = StringMid($CmdLine[1], 1, StringLen($CmdLine[1]) - 4)
   ;MsgBox($MB_SYSTEMMODAL, "", $CmdLine[1])
   ;Exit

   ; ----------------------------------
   ; 從這裡開始做一個lock

   Local $lockFile = @ScriptDir & '\lock.tmp'
   If FileExists($lockFile) Then
	  Sleep(3000)
	  Return addArchive($archiveFormat)
   EndIf

   ;FileWrite($lockFile, "Archive is going now. Please wait." & @CRLF & $CmdLine[1])

   ; ----------------------------------

   If $CmdLine[0] = 1 Then
	  If (StringRight($CmdLine[1], 4) = '.zip' Or StringRight($CmdLine[1], 3) = '.7z') Then
		 unarchive()
		 unarchiveUnique()
		 unlock()
		 Return
	  ElseIf StringRight($CmdLine[1], 4) = '.rar'  Then
		 unarchive()
		 ;Exit
		 $CmdLine[1] = StringMid($CmdLine[1], 1, StringLen($CmdLine[1]) - 4)
		 ;MsgBox($MB_SYSTEMMODAL, @WorkingDir, $CmdLine[1])
		 ;Exit
		 addArchive($archiveFormat)
		 unlock()
		 Return
	  Else
		 addArchive($archiveFormat)
	  EndIf
   Else
	  addArchive($archiveFormat)
   EndIf
EndFunc

; ----------------------------------

Func addArchive($archiveFormat)

   ; ----------------------------------

   Local $path7z = @ScriptDir & '\7-zip\7z.exe'

   ;MsgBox($MB_SYSTEMMODAL, "", $fileList)

   MsgBox($MB_SYSTEMMODAL, "", $path7z)

   ; ----------------------------------

   If $CmdLine[0] > 0 Then
	  FileChangeDir(GetDir($CmdLine[1]))
   EndIf
   Local $workingDir = @WorkingDir

   ; ----------------------------------

   Local $archiveFilename

   ; 如果檔案只有一個，那就以該檔案為名字
   ; 如果檔案有很多個，那就取上層目錄為檔案名字
   If $CmdLine[0] = 0 Then
	  ;MsgBox($MB_SYSTEMMODAL, "", "no file")
	  Exit
   ElseIf $CmdLine[0] = 1 Then
	  ;Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	  ;Local $aPathSplit = _PathSplit($CmdLine[1], $sDrive, $sDir, $sFileName, $sExtension)
	  ;MsgBox($MB_SYSTEMMODAL, "", $sFileName)
	  If StringInStr(FileGetAttrib($CmdLine[1]), "D") Then
		 $archiveFilename = GetFileNameNoExt($CmdLine[1])
	  Else
		 $archiveFilename = GetFileName($CmdLine[1])
	  EndIf
   Else
	  ;MsgBox($MB_SYSTEMMODAL, "", "many files")
	  ;Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	  ;Local $aPathSplit = _PathSplit($CmdLine[1], $sDrive, $sDir, $sFileName, $sExtension)
	  ;$sDir = StringTrimRight($sDir, 1)
	  ;MsgBox($MB_SYSTEMMODAL, "", $sDir)
	  $archiveFilename = GetDir($CmdLine[1])
   EndIf

   ; ------------------------------------

   ;MsgBox($MB_SYSTEMMODAL, "", $workingDir)

   If $CmdLine[0] = 1 And StringInStr(FileGetAttrib($CmdLine[1]), "D") Then
	  uniqueDir(GetFileName($CmdLine[1]))
   EndIf

   ; ----------------------------------
   ; 建立列表

   ;MsgBox($MB_SYSTEMMODAL, "", StringInStr(FileGetAttrib($CmdLine[1]), "D"))

   Local $fileList = ""
   If $CmdLine[0] = 1 And StringInStr(FileGetAttrib($CmdLine[1]), "D") Then
	  Local $trimLength = StringLen($CmdLine[1]) + 1
	  $archiveFilename = '../' & $archiveFilename

	  Local $subFileList = _FileListToArray($CmdLine[1])
	  FileChangeDir($CmdLine[1])
	  ;MsgBox($MB_SYSTEMMODAL, "", $CmdLine[1])
	  ;MsgBox($MB_SYSTEMMODAL, "", @WorkingDir)
	  If $subFileList[0] = 0 Then
		 MsgBox($MB_SYSTEMMODAL, @WorkingDir, "$subFileList[0] = 0")
		 unlock()
		 Exit
	  EndIf

	  For $i = 1 To $subFileList[0]
		 ;MsgBox($MB_SYSTEMMODAL, "", $CmdLine[1])
		 MsgBox($MB_SYSTEMMODAL, "", $subFileList[$i])

		 If FileExists($subFileList[$i]) Then
			Local $f = $subFileList[$i]
			$fileList = $fileList & ' "' & $f & '"'
		 EndIf
	  Next

	  MsgBox($MB_SYSTEMMODAL, "fileList", $fileList)
   Else
	  MsgBox($MB_SYSTEMMODAL, "not dir", @WorkingDir)
	  For $i = 1 To $CmdLine[0]
		 ;MsgBox($MB_SYSTEMMODAL, FileExists(GetFileName($CmdLine[$i])), GetFileName($CmdLine[$i]))
		 If FileExists(GetFileName($CmdLine[$i])) Then
			$fileList = $fileList & ' "' & GetFileName($CmdLine[$i]) & '"'
		 EndIf
	  Next

   EndIf

   ; ------------------------------------

   Local $cmd = '"' & $path7z & '" a -t' & $archiveFormat & ' -mx=9 "' & $archiveFilename & '.' & $archiveFormat & '"' & $fileList

   MsgBox($MB_SYSTEMMODAL, @WorkingDir, $cmd)
   ;MsgBox($MB_SYSTEMMODAL, "", $CmdLine[1])
   ;Exit

   ;Sleep(10000)

   If StringLen($fileList) > 0 Then
	  RunWait($cmd, '', @SW_MINIMIZE)
   EndIf

   ; ------------------------------------

   FileChangeDir($workingDir)
   For $i = 1 To $CmdLine[0]
	  Local $file = GetFileName($CmdLine[$i])
	  FileRecycle($file)
   Next

   unlock()

EndFunc

; ------------------------------------

Func unlock()
   Local $lockFile = @ScriptDir & '\lock.tmp'
   If FileExists($lockFile) Then
   	  FileDelete($lockFile)
   EndIf
EndFunc

Func GetDir($sFilePath)
   If Not IsString($sFilePath) Then
	 Return SetError(1, 0, -1)
   EndIf

   Local $FileDir = StringRegExpReplace($sFilePath, "\\[^\\]*$", "")

   Return $FileDir
EndFunc

Func GetFileName($sFilePath)
   If Not IsString($sFilePath) Then
	 Return SetError(1, 0, -1)
   EndIf

   Local $FileName = StringRegExpReplace($sFilePath, "^.*\\", "")

   Return $FileName
EndFunc

Func GetFileNameNoExt($sFilePath)
 If Not IsString($sFilePath) Then
	 Return SetError(1, 0, -1)
 EndIf

 Local $FileName = StringRegExpReplace($sFilePath, "^.*\\", "")
 If StringInStr(FileGetAttrib($sFilePath), "D") = False And StringInStr($FileName, '.') Then
   $FileName = StripExt($FileName)
 EndIf

 Return $FileName
EndFunc

Func StripExt($FileName)
   If StringInStr($FileName, '.') Then
	  $pos = StringInStr ($FileName, '.', 2, -1)
	  $FileName = StringTrimRight($FileName, StringLen($FileName) - $pos + 1)
   EndIf
   Return $FileName
EndFunc

; ------------------------------------

Func unarchive()
   If $CmdLine = 0 Then
	  Exit
   EndIf


   Local $file = $CmdLine[1]
   ;MsgBox($MB_SYSTEMMODAL, "", $file)
   If FileExists($file) = False Then
	  Exit
   EndIf

   ; ----------------------------

   Local $workingDir = @WorkingDir

   If $CmdLine[0] > 0 Then
	  $file = GetFileName($CmdLine[1])
	  ;MsgBox($MB_SYSTEMMODAL, @WorkingDir, $file)
	  FileChangeDir(GetDir($CmdLine[1]))
   EndIf

   ; ----------------------------

   ;Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
   ;Local $aPathSplit = _PathSplit($CmdLine[1], $sDrive, $sDir, $sFileName, $sExtension)
   Local $sFileName = GetFileNameNoExt($CmdLine[1])

   If FileExists($sFileName) = False Then
	  DirCreate($sFileName)
   EndIf

   ; ----------------------------

   Local $path7z = @ScriptDir & '\7-zip\7z.exe'
   Local $cmd = '"' & $path7z & '" x "' & $file & '" -o"' & $sFileName & '"'

   ;MsgBox($MB_SYSTEMMODAL, @WorkingDir, $cmd)
   ;Exit

   RunWait($cmd, '', @SW_MINIMIZE)

   ; ------------------------------
   FileRecycle($file)

   FileChangeDir($workingDir)
EndFunc

Func unarchiveUnique($sFileName)
   Local $sFileName = stripExt(GetFileNameNoExt($CmdLine[1]))
   Local $singleFile = uniqueDir($sFileName)

   If $singleFile <> False Then
	  ;Local $openCmd = @comspec & ' /c start "' & $singleFile & '"'
	  ;MsgBox($MB_SYSTEMMODAL, $singleFile, $openCmd)
	  ;Run($openCmd)
	  ShellExecute('"' & $singleFile & '"')
   EndIf
EndFunc

; --------------------------------

Func uniqueDir($sFileName)
   If StringInStr(FileGetAttrib($sFileName), "D") = False Then
	  Return False
   EndIf

   ;MsgBox($MB_SYSTEMMODAL, "uniqueDir", @WorkingDir)
   ;MsgBox($MB_SYSTEMMODAL, "uniqueDir", $sFileName)
   Local $fileList = _FileListToArray($sFileName)
   ;MsgBox($MB_SYSTEMMODAL, "uniqueDir", $fileList[1])
   If $fileList = False Then
	  unlock()
	  Exit
   ElseIf $fileList[0] > 1 Then
	  ;MsgBox($MB_SYSTEMMODAL, "uniqueDir", $fileList)
	  ;MsgBox($MB_SYSTEMMODAL, "uniqueDir", $fileList)
	  Return False
   ElseIf StringInStr(FileGetAttrib($sFileName & '/' & $fileList[1]), "D") And $fileList[1] = $sFileName Then
	  ;MsgBox($MB_SYSTEMMODAL, "dir", $fileList[1])

	  Local $subFileList = _FileListToArray($sFileName & '/' & $sFileName)
	  For $i = 1 To $subFileList[0]
		 ;MsgBox($MB_SYSTEMMODAL, $sFileName & '/' & $sFileName & " i", $i)
		 Local $source = $sFileName & '/' & $sFileName & '/' & $subFileList[$i]
		 ;MsgBox($MB_SYSTEMMODAL, "", $source)
		 If StringInStr(FileGetAttrib($source), "D") Then
			;MsgBox($MB_SYSTEMMODAL, "dir 1", $source)
			;DirMove($source, $sFileName & '/' & $subFileList[$i])
			Local $target = $sFileName
			If $target <> $subFileList[$i] Then
			   $target = $sFileName & '/' & $subFileList[$i]
			EndIf
			;MsgBox($MB_SYSTEMMODAL, "dir 2", $target)
			;DirMove($source, $target, 1)
			If DirCopy($source,$target,1) Then DirRemove($source,1)
		 Else
			;MsgBox($MB_SYSTEMMODAL, "file", $source)
			FileMove($source, $sFileName, 1)
		 EndIf
	  Next
	  FileRecycle($sFileName & '/' & $sFileName)
	  Return uniqueDir($sFileName)
   ElseIf StringInStr(FileGetAttrib($sFileName & '/' & $fileList[1]), "D") = False Then
	  ; 單一檔案
	  Local $source = $sFileName & '/' & $fileList[1]
	  Local $dist = @WorkingDir
	  ;MsgBox($MB_SYSTEMMODAL, "single file", $source)
	  FileMove($source, $dist)
	  DirRemove($sFileName)

	  Return $dist & "\" & $fileList[1]
   EndIf
EndFunc

; ------------------------------------
