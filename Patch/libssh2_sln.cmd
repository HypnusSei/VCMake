@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"

set "File1=%BuildPath%\src\libssh2.vcxproj"
set "File2=%BuildPath%\src\libssh2.vcxproj.filters"
set "strRC=ResourceCompile Include"

:: 删除包含特定字符串的行
powershell -Command "$data = foreach($line in gc %File1%){ if($line -notlike '*%strRC%*') {$line}} $data | Out-File %File1%"
