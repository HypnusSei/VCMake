@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "SetupPath=%2"
set "CMakeRoot=%3"

call %CMakeRoot%Tools\fsr '%BuildPath%','*.vcxproj','fontconfig.lib;','%BuildPath%\Release\dirent.lib;%BuildPath%\Release\fontconfig-static.lib;%SetupPath%\lib\libexpat.lib;%SetupPath%\lib\zlib.lib;%SetupPath%\lib\liblzma.lib;%SetupPath%\lib\libpng16.lib;%SetupPath%\lib\freetype.lib;%SetupPath%\lib\bz2.lib;',1,0,'UTF8'
