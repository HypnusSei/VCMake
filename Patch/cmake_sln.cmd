@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"
set "CMakeRoot=%3"

:: �޸� MD ����Ϊ MT
echo �޸� MD ����Ϊ MT
call %CMakeRoot%\Tools\fsr '%BuildPath%','*.vcxproj','MultiThreadedDLL','MultiThreaded',1,0,'UTF8'
