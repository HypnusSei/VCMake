@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"
set "CMakeRoot=%3"

:: �ַ��������滻
set "libprojName01=%BuildPath%\modules\highgui\opencv_highgui.vcxproj"
set "strOld01=NO_STRICT;"
set "strNew01=;"
if exist %libprojName01% (powershell -Command "(gc %libprojName01%) -replace '%strOld01%', '%strNew01%' | Out-File %libprojName01%")

:: �ַ��������滻
call %CMakeRoot%Tools\fsr '%BuildPath%','*.vcxproj','MultiThreadedDLL','MultiThreaded',1,0,'UTF8',1
