#include <File.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>


Func lock()
   Local $lockFile = @ScriptDir & '\lock.tmp'
   If FileExists($lockFile) Then
	  Sleep(3000)
	  Return addArchive($archiveFormat)
   EndIf

   Local $content = ""
   If $CmdLine[0] > 0 Then
    $content = $CmdLine[1]
   EndIf

   FileWrite($lockFile, "Archive is going now. Please wait." & @CRLF & $content)
EndFunc

Func unlock()
   Local $lockFile = @ScriptDir & '\lock.tmp'
   If FileExists($lockFile) Then
   	  FileDelete($lockFile)
   EndIf
EndFunc