@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"

set "libprojName01=%BuildPath%\xmlcatalog.vcxproj"
set "libprojName02=%BuildPath%\xmllint.vcxproj"
set "strOld=libiconv.lib;"
set "strNew=libiconv.lib;%SetupPath%\lib\libcharset.lib;"

:: ×Ö·û´®ËÑË÷Ìæ»»
powershell -Command "(gc %libprojName01%) -replace '%strOld%', '%strNew%' | Out-File %libprojName01%"
powershell -Command "(gc %libprojName02%) -replace '%strOld%', '%strNew%' | Out-File %libprojName02%"

:: É¾³ý°üº¬ÌØ¶¨×Ö·û´®µÄÐÐ
set "FileName=%BuildPath%\LibXml2.vcxproj"
set "sDelLine=libxml2.rc"
powershell -Command "$data = foreach($line in gc %FileName%){ if($line -notlike '*%sDelLine%*') {$line}} $data | Out-File %FileName%"
