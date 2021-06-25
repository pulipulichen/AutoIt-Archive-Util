#include <Array.au3>

Func addEachArchive($archiveFormat)

   ; ----------------------------------

   ;Local $path7z = @ScriptDir & '\7-zip\7z.exe'
   ; ------------------------------------

   ;Local $fileList = ""
   Local $archiveFilename
   If $CmdLine[0] = 1 And StringInStr(FileGetAttrib($CmdLine[1]), "D") Then

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
		 ;MsgBox($MB_SYSTEMMODAL, "", $subFileList[$i])

		 If FileExists($subFileList[$i]) Then
			Local $f = $subFileList[$i]
			$archiveFilename = GetFileName($CmdLine[1])
			addEachArchiveExec($archiveFormat, $archiveFilename, $f)
		 EndIf
	  Next

	  ;MsgBox($MB_SYSTEMMODAL, "fileList", $fileList)
   Else
	  ;MsgBox($MB_SYSTEMMODAL, "not dir", @WorkingDir)
	  For $i = 1 To $CmdLine[0]
		 ;MsgBox($MB_SYSTEMMODAL, FileExists(GetFileName($CmdLine[$i])), GetFileName($CmdLine[$i]))
		 If FileExists($CmdLine[$i]) Then
			Local $f = $CmdLine[$i]
			$archiveFilename = GetFileName($CmdLine[$i])
			addEachArchiveExec($archiveFormat, $archiveFilename, $f)
		 EndIf
	  Next

   EndIf

   unlock()

EndFunc

Func addEachArchiveExec($archiveFormat, $archiveFilename, $filePath)

   ; ----------------------------------

   Local $path7z = @ScriptDir & '\7-zip\7z.exe'

   FileChangeDir(GetDir($filePath))
   Local $workingDir = @WorkingDir

   ; ------------------------------------

   ;MsgBox($MB_SYSTEMMODAL, "", $workingDir)

   If $CmdLine[0] = 1 And StringInStr(FileGetAttrib($filePath), "D") Then
	  uniqueDir(GetFileName($filePath))
   EndIf

   ; ----------------------------------
   ; 建立列表

   ;MsgBox($MB_SYSTEMMODAL, "", StringInStr(FileGetAttrib($CmdLine[1]), "D"))
   Local $fileList = $filePath

   ; ------------------------------------

   Local $cmd = '"' & $path7z & '" a -t' & $archiveFormat & ' -mcu=on -mx=9 "' & $archiveFilename & '.' & $archiveFormat & '" "' & $fileList & '"'

   If $archiveFormat = "7z" Then
	  $cmd = '"' & $path7z & '" a -t' & $archiveFormat & ' -mx=9 "' & $archiveFilename & '.' & $archiveFormat & '" "' & $fileList & '"'
   EndIf

   ;MsgBox($MB_SYSTEMMODAL, @WorkingDir, @WorkingDir & @CRLF & @CRLF & $cmd)
   ;Exit

   ;Sleep(10000)

   If StringLen($fileList) > 0 Then
	  RunWait($cmd, '', @SW_MINIMIZE)
   EndIf

   ; ------------------------------------

   FileChangeDir($workingDir)
   If FileExists($fileList) Then
	  FileRecycle($fileList)
   EndIf

EndFunc