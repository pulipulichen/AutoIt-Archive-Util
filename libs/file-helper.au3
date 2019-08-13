#include <File.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>


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

Func isDir($path)
  Return StringInStr(FileGetAttrib($sFilePath), "D") = True
EndFunc