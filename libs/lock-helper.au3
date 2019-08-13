Func lock()
   Local $lockFile = @ScriptDir & '\lock.tmp'
   If FileExists($lockFile) Then
	  Sleep(3000)
	  Return archiveMethodEntry($archiveFormat)
   EndIf

   Local $content = ""
   If $CmdLine[0] > 0 Then
    $content = $CmdLine[1]
   EndIf

   ;FileWrite($lockFile, "Archive is going now. Please wait." & @CRLF & $content)
EndFunc

Func unlock()
   Local $lockFile = @ScriptDir & '\lock.tmp'
   If FileExists($lockFile) Then
   	  FileDelete($lockFile)
   EndIf
EndFunc