
#include <MsgBoxConstants.au3>

Func lock($archiveFormat)
   Local $lockFile = @ScriptDir & '\lock.tmp'

   Local $content = ""
   If $CmdLine[0] > 0 Then
    $content = $CmdLine[1]
   EndIf

   If FileExists($lockFile) Then
    $result = MsgBox ( $MB_OKCANCEL, "Another archive is processing", "Do you want to process file directly? " & @CRLF & "File: " & $content , 3 )
	  ;Sleep(3000)
    ;MsgBox ( $MB_SYSTEMMODAL, "Another archive is processing", $result , 3 )
    If $result = 1 Then
      FileDelete($lockFile)
    EndIf
    Return archiveMethodEntry($archiveFormat)
   EndIf

   FileWrite($lockFile, "Archive is going now. Please wait." & @CRLF & $content)
EndFunc

Func unlock()
   Local $lockFile = @ScriptDir & '\lock.tmp'
   If FileExists($lockFile) Then
   	  FileDelete($lockFile)
   EndIf
EndFunc