#include <File.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>

;Local $archiveFormat = 'zip'
;Local $archiveFormat = '7z'

; ----------------------------------

Func addArchive($archiveFormat)

  If $CmdLine[0] = 1 And (StringRight($CmdLine[1], 4) = '.zip' Or StringRight($CmdLine[1], 4) = '.rar' Or StringRight($CmdLine[1], 3) = '.7z') Then
     Return unarchive()
  EndIf

   ; ----------------------------------
   Local $path7z = @ScriptDir & '\7-zip\7z.exe'

   ;MsgBox($MB_SYSTEMMODAL, "", $fileList)

   ;MsgBox($MB_SYSTEMMODAL, "", $path7z)

   ; ----------------------------------

   Local $archiveFilename
   Local $workingDir = @WorkingDir

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

   If $CmdLine[0] = 1 Then
	  uniqueDir($CmdLine[1])
   EndIf

   ; ----------------------------------
   ; 建立列表
   Local $fileList = ""
   If $CmdLine[0] = 1 And StringInStr(FileGetAttrib($CmdLine[1]), "D") Then
	  Local $trimLength = StringLen($CmdLine[1]) + 1
	  $archiveFilename = '../' & $archiveFilename


	  Local $subFileList = _FileListToArray($CmdLine[1])
	  FileChangeDir($CmdLine[1])
	  ;MsgBox($MB_SYSTEMMODAL, "", $CmdLine[1])
	  For $i = 1 To $subFileList[0]
		 ;MsgBox($MB_SYSTEMMODAL, "", $CmdLine[1])
		 If FileExists($subFileList[$i]) Then
			Local $f = $subFileList[$i]
			$fileList = $fileList & ' "' & $f & '"'
		 EndIf
	  Next
   Else

	  For $i = 1 To $CmdLine[0]
		 If FileExists($CmdLine[$i]) Then
			$fileList = $fileList & ' "' & $CmdLine[$i] & '"'
		 EndIf
	  Next
   EndIf

   ; ------------------------------------

   Local $cmd = $path7z & '  a -t' & $archiveFormat & ' -mx=9 ' & $archiveFilename & '.' & $archiveFormat & $fileList

   ;MsgBox($MB_SYSTEMMODAL, "", $cmd)
   ;Exit

   RunWait($cmd)

   ; ------------------------------------

   FileChangeDir($workingDir)
   For $i = 1 To $CmdLine[0]
	  FileRecycle($CmdLine[$i])
   Next
EndFunc

; ------------------------------------

Func unarchive()
   Local $file = $CmdLine[1]
   ;MsgBox($MB_SYSTEMMODAL, "", $file)
   If FileExists($file) = False Then
	  Exit
   EndIf

   ; ----------------------------

   Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
   Local $aPathSplit = _PathSplit($CmdLine[1], $sDrive, $sDir, $sFileName, $sExtension)

   If FileExists($sFileName) = False Then
	  DirCreate($sFileName)
   EndIf

   ; ----------------------------

   Local $path7z = @ScriptDir & '\7-zip\7z.exe'
   Local $cmd = $path7z & ' x ' & $file & ' -o' & $sFileName
   ;MsgBox($MB_SYSTEMMODAL, "", $cmd)
   ;Exit
   RunWait($cmd)

   ; ------------------------------
   FileRecycle($file)

   ; ------------------------------
   uniqueDir($sFileName)

EndFunc

Func uniqueDir($sFileName)
   If StringInStr(FileGetAttrib($sFileName), "D") = False Then
	  Return
   EndIf

   Local $fileList = _FileListToArray($sFileName)
   If $fileList[0] = 1 And $fileList[1] = $sFileName Then
	  MsgBox($MB_SYSTEMMODAL, "", $fileList[1])

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
			MsgBox($MB_SYSTEMMODAL, "file", $source)
			FileMove($source, $sFileName, 1)
		 EndIf
	  Next
	  FileRecycle($sFileName & '/' & $sFileName)
	  uniqueDir($sFileName)
   EndIf
EndFunc

; ------------------------------------
