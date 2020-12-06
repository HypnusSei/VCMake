@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"

set "libprojName=%BuildPath%\tools\c-index-test\c-index-test.vcxproj"
set "strOld=libxml2.lib;"
set "strNew=libxml2s.lib;%SetupPath%\lib\liblzma.lib;%SetupPath%\lib\libiconv.lib;%SetupPath%\lib\libcharset.lib;%SetupPath%\lib\zlib.lib;ws2_32.lib;"

:: ×Ö·û´®ËÑË÷Ìæ»»
powershell -Command "(gc %libprojName%) -replace '%strOld%', '%strNew%' | Out-File %libprojName%"
