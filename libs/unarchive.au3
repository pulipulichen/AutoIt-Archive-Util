Func unarchive($openSingleFile, $codePage = False)
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

   ;Local $sFileName = stripExt(GetFileNameNoExt($CmdLine[1]))
   Local $sFileName = GetFileNameNoExt($CmdLine[1])

   ;If FileExists($sFileName) = False Then
	 ; DirCreate($sFileName)
   ;EndIf

   ; ----------------------------

   Local $path7z = @ScriptDir & '\7-zip\7z.exe'
   Local $cmd = '"' & $path7z & '" x "' & $file & '" -aoa -o"' & $sFileName & '" -mcu=on'
    
   If $codePage = True Then
    Local $codePageNumber = InputBox("Code Page", "Please select a code page ID (charset): " & @CRLF & "BIG5=950 GBK=936 JP=932 KOREA=949 RU=866 UTF-8=65001" & @CRLF& "Full code page list: https://bit.ly/3w5dDCn", "932")

    $cmd = $cmd & ' -mcp=' & $codePageNumber
   EndIf

   ;MsgBox($MB_SYSTEMMODAL, @WorkingDir, $cmd)
   ;Exit

   RunWait($cmd, '', @SW_MINIMIZE)

   FileRecycle($file)

   ; ------------------------------


   ;Local $sFileName = stripExt(GetFileNameNoExt($CmdLine[1]))
   ;Local $sFileName = stripExt(GetFileNameNoExt($CmdLine[1]))
   ;MsgBox($MB_SYSTEMMODAL, 'unarchiveUnique()', $CmdLine[1])

   ;MsgBox($MB_SYSTEMMODAL, 'unarchiveUnique()', @WorkingDir & @CRLF & $sFileName & @CRLF & $CmdLine[1])

   Local $singleFile = uniqueDir($sFileName)

   ;MsgBox($MB_SYSTEMMODAL, 'unarchiveUnique()', $singleFile)

   If $openSingleFile = True And $singleFile <> False Then
	  ShellExecute('"' & $singleFile & '"')
   EndIf

   FileChangeDir($workingDir)
EndFunc
