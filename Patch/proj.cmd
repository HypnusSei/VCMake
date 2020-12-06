@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"
set "CMakeRoot=%3"

call %CMakeRoot%\Tools\fsr '%BuildPath%','*.vcxproj','zlib.lib;liblzma.lib;','zlib.lib;liblzma.lib;Crypt32.lib;',1,0,'UTF8'
