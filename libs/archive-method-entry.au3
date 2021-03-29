#include <File.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>
#include "lock-helper.au3"
#include "file-helper.au3"
#include "add-archive.au3"
#include "unarchive.au3"
#include "unique-dir.au3"

;Local $archiveFormat = 'zip'
;Local $archiveFormat = '7z'

; ----------------------------------

Func archiveMethodEntry($archiveFormat, $codePage = False)
   If $CmdLine = 0 Then
	  Exit
   EndIf

   ;$CmdLine[1] = StringMid($CmdLine[1], 1, StringLen($CmdLine[1]) - 4)
   ;MsgBox($MB_SYSTEMMODAL, "1", $CmdLine[0])
   ;Exit

   ; ----------------------------------
   ; 從這裡開始做一個lock

   lock($archiveFormat)

   ; ----------------------------------

   If $CmdLine[0] = 1 Then
    ;MsgBox($MB_SYSTEMMODAL, "2", $CmdLine[1])
	  If StringRight($CmdLine[1], 4) = '.rar' Or ($archiveFormat = '7z' And StringRight($CmdLine[1], 4) = '.zip') Or ($archiveFormat = 'zip' And StringRight($CmdLine[1], 3) = '.7z') Then
		 unarchive(False)
     ; 這裡就要清理完
		 ;Exit
     If $archiveFormat = 'zip' Then
        $CmdLine[1] = StringMid($CmdLine[1], 1, StringLen($CmdLine[1]) - 3)
     Else
        $CmdLine[1] = StringMid($CmdLine[1], 1, StringLen($CmdLine[1]) - 4)
     EndIf

		 ;MsgBox($MB_SYSTEMMODAL, @WorkingDir, $CmdLine[1])
		 ;Exit
		 addArchive($archiveFormat)
		 unlock()
		 Return
    ElseIf (StringRight($CmdLine[1], 4) = '.zip' Or StringRight($CmdLine[1], 3) = '.7z') Then

		 unarchive(True, $codePage)
		 unlock()
		 Return
	  Else
		 addArchive($archiveFormat)
	  EndIf
   Else
	  addArchive($archiveFormat)
   EndIf
EndFunc
