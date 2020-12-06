@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"
set "CMakeRoot=%3"

:: 修改 MD 编译为 MT
echo 修改 MD 编译为 MT
call %CMakeRoot%\Tools\fsr '%BuildPath%','*.vcxproj','MultiThreadedDLL','MultiThreaded',1,0,'UTF8'
