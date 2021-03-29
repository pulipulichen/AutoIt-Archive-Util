#include <File.au3>
#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>
#include "libs/archive-method-entry.au3"
#pragma compile(Icon, 'icons/zip-charset.ico')

archiveMethodEntry('zip', True)

;MsgBox($MB_SYSTEMMODAL, "", GetFileNameNoExt("D:\xampp\htdocs\autoit_projects\AutoIt-Archive-Util\.AA A.zip"))

;FileMove("D:\xampp\htdocs\autoit_projects\AutoIt-Archive-Util\AA A.txt\AA A.txt", @WorkingDir)

;FileChangeDir("D:\xampp\htdocs\projects-autoit\AutoIt-Archive-Util\test")
;FileMove("BB B\BB B.txt", "D:\xampp\htdocs\projects-autoit\AutoIt-Archive-Util\test")