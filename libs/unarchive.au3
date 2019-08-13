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