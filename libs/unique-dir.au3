Func uniqueDir($sFileName)
   If isDir($sFileName) = False Then
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
