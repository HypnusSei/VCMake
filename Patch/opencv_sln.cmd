@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"

:: ×Ö·û´®ËÑË÷Ìæ»»
set "libprojName01=%BuildPath%\modules\highgui\opencv_highgui.vcxproj"
set "strOld01=NO_STRICT;"
set "strNew01=;"
powershell -Command "(gc %libprojName01%) -replace '%strOld01%', '%strNew01%' | Out-File %libprojName01%"

rem :: ×Ö·û´®ËÑË÷Ìæ»»
rem set "libprojName02=%BuildPath%\modules\python2\opencv_python2.vcxproj"
rem set "strOld02=H:\\VCMake\\VSSDK\\x64\\lib\\TBB.lib;"
rem set "strNew02=;"
rem powershell -Command "(gc %libprojName02%) -replace '%strOld02%', '%strNew02%' | Out-File %libprojName02%"

rem :: ×Ö·û´®ËÑË÷Ìæ»»
rem set "libprojName03=%BuildPath%\modules\python3\opencv_python3.vcxproj"
rem set "strOld03=H:\\VCMake\\VSSDK\\x64\\lib\\TBB.lib;"
rem set "strNew03=;"
rem powershell -Command "(gc %libprojName03%) -replace '%strOld03%', '%strNew03%' | Out-File %libprojName03%"
