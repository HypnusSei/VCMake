@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "liblzmavcxprojName=%BuildPath%\liblzma.vcxproj"
set "strMD=<RuntimeLibrary>MultiThreadedDLL</RuntimeLibrary>"
set "strMT=<RuntimeLibrary>MultiThreaded</RuntimeLibrary>"

:: ×Ö·û´®ËÑË÷Ìæ»»
powershell -Command "(gc %liblzmavcxprojName%) -replace '%strMD%', '%strMT%' | Out-File %liblzmavcxprojName%"