@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"

:: ×Ö·û´®ËÑË÷Ìæ»»
set "libprojName01=%BuildPath%\modules\highgui\opencv_highgui.vcxproj"
set "strOld01=NO_STRICT;"
set "strNew01=;"
if exist %libprojName01% (powershell -Command "(gc %libprojName01%) -replace '%strOld01%', '%strNew01%' | Out-File %libprojName01%")
