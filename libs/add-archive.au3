#include <Array.au3>

Func addArchive($archiveFormat)

   ; ----------------------------------

   Local $path7z = @ScriptDir & '\7-zip\7z.exe'

   ;MsgBox($MB_SYSTEMMODAL, "", $fileList)

   ;MsgBox($MB_SYSTEMMODAL, "", $path7z)

   ; ----------------------------------

   If $CmdLine[0] = 1 And isDir($CmdLine[1]) Then
	  ; 這裡也要清理
	  FileChangeDir(GetDir($CmdLine[1]))
   ElseIf $CmdLine[0] > 0 Then
	  FileChangeDir(GetDir($CmdLine[1]))
   EndIf
   Local $workingDir = @WorkingDir

   ; ----------------------------------

   Local $archiveFilename

   ; 如果檔案只有一個，那就以該檔案為名字
   ; 如果檔案有很多個，那就取上層目錄為檔案名字
   If $CmdLine[0] = 0 Then
	  ;MsgBox($MB_SYSTEMMODAL, "", "no file")
	  Exit
   ElseIf $CmdLine[0] = 1 Then
	  ;Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	  ;Local $aPathSplit = _PathSplit($CmdLine[1], $sDrive, $sDir, $sFileName, $sExtension)
	  ;MsgBox($MB_SYSTEMMODAL, "", $sFileName)
	  If StringInStr(FileGetAttrib($CmdLine[1]), "D") Then
		 $archiveFilename = GetFileNameNoExt($CmdLine[1])
	  Else
		 $archiveFilename = GetFileName($CmdLine[1])
	  EndIf
   Else
	  ;MsgBox($MB_SYSTEMMODAL, "", "many files")
	  ;Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	  ;Local $aPathSplit = _PathSplit($CmdLine[1], $sDrive, $sDir, $sFileName, $sExtension)
	  ;$sDir = StringTrimRight($sDir, 1)
	  ;MsgBox($MB_SYSTEMMODAL, "", $sDir)
	  $archiveFilename = GetDir($CmdLine[1])

    ; 檢查這個資料夾裡面，除了指定的檔案之外，還有沒有其他的資料
    local $hasOtherFiles = False
    Local $subFileList = _FileListToArray($archiveFilename)
    For $i = 1 To $subFileList[0]
      Local $search = $archiveFilename & '\' & $subFileList[$i]

      ;MsgBox($MB_SYSTEMMODAL, _ArraySearch($subFileList, $search), $search)
      If _ArraySearch($CmdLine, $search) = -1 Then
        $hasOtherFiles = True
        ;MsgBox($MB_SYSTEMMODAL, "", $search)
        ExitLoop
      EndIf
    Next
    If $hasOtherFiles = True Then
      $archiveFilename = $archiveFilename & '\' & GetFileName($archiveFilename)
    EndIf
   EndIf

   ;MsgBox($MB_SYSTEMMODAL, "", $archiveFilename)
   ;Exit

   ; ------------------------------------

   ;MsgBox($MB_SYSTEMMODAL, "", $workingDir)

   If $CmdLine[0] = 1 And StringInStr(FileGetAttrib($CmdLine[1]), "D") Then
	  uniqueDir(GetFileName($CmdLine[1]))
   EndIf

   ; ----------------------------------
   ; 建立列表

   ;MsgBox($MB_SYSTEMMODAL, "", StringInStr(FileGetAttrib($CmdLine[1]), "D"))

   Local $fileList = ""
   If $CmdLine[0] = 1 And StringInStr(FileGetAttrib($CmdLine[1]), "D") Then
	  Local $trimLength = StringLen($CmdLine[1]) + 1
	  $archiveFilename = '../' & $archiveFilename

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
			$fileList = $fileList & ' "' & $f & '"'
		 EndIf
	  Next

	  ;MsgBox($MB_SYSTEMMODAL, "fileList", $fileList)
   Else
	  ;MsgBox($MB_SYSTEMMODAL, "not dir", @WorkingDir)
	  For $i = 1 To $CmdLine[0]
		 ;MsgBox($MB_SYSTEMMODAL, FileExists(GetFileName($CmdLine[$i])), GetFileName($CmdLine[$i]))
		 If FileExists(GetFileName($CmdLine[$i])) Then
			$fileList = $fileList & ' "' & GetFileName($CmdLine[$i]) & '"'
		 EndIf
	  Next

   EndIf

   ; ------------------------------------

   Local $cmd = '"' & $path7z & '" a -t' & $archiveFormat & ' -mcu=on -mx=9 "' & $archiveFilename & '.' & $archiveFormat & '"' & $fileList

   If $archiveFormat = "7z" Then
	  $cmd = '"' & $path7z & '" a -t' & $archiveFormat & ' -mx=9 "' & $archiveFilename & '.' & $archiveFormat & '"' & $fileList
   EndIf

   ;MsgBox($MB_SYSTEMMODAL, @WorkingDir, @WorkingDir & @CRLF & @CRLF & $cmd)
   ;MsgBox($MB_SYSTEMMODAL, "", $CmdLine[1])
   ;Exit

   ;Sleep(10000)

   If StringLen($fileList) > 0 Then
	  RunWait($cmd, '', @SW_MINIMIZE)
   EndIf

   ; ------------------------------------

   FileChangeDir($workingDir)
   For $i = 1 To $CmdLine[0]
	  Local $file = $CmdLine[$i]
	  ;MsgBox($MB_SYSTEMMODAL, "FileRecycle", @WorkingDir & @CRLF & @CRLF & $file & @CRLF & @CRLF & FileExists($file))
	  If FileExists($file) Then
		 FileRecycle($file)
	  EndIf
   Next

   unlock()

EndFunc