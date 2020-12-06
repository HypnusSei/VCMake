@echo off
setlocal EnableDelayedExpansion

set "BuildPath=%1"
set "VSSDKPath=%2"

set "strOld1=\\Snappy.Library\\lib\\native\\retail\\amd64\\snappy.lib"
set "strNew1=%VSSDKPath%\lib\snappy.lib"

set "strOld2=\\LZ4.Library\\lib\\native\\retail\\amd64\\lz4.lib"
set "strNew2=%VSSDKPath%\lib\lz4.lib"

set "strOld3=\\ZLIB.Library\\lib\\native\\retail\\amd64\\zlib.lib"
set "strNew3=%VSSDKPath%\lib\zlib.lib"

set "strOld4=\\ZSTD.Library\\lib\\native\\retail\\amd64\\libzstd_static.lib"
set "strNew4=%VSSDKPath%\lib\zstd.lib"

set "strOld5=\\Snappy.Library\\build\\native\\inc\\inc"
set "strNew5=%VSSDKPath%\include"

set "strOld6=\\LZ4.Library\\build\\native\\inc\\inc"
set "strNew6=%VSSDKPath%\include"

set "strOld7=\\ZLIB.Library\\build\\native\\inc\\inc"
set "strNew7=%VSSDKPath%\include"

set "strOld8=\\ZSTD.Library\\build\\native\\inc"
set "strNew8=%VSSDKPath%\include"

CD /D %BuildPath%

:: ×Ö·û´®ËÑË÷Ìæ»»
for /f %%i in ('dir /b /s /a:-d *.vcxproj') do (
  powershell -Command "(gc %%i) -replace '%strOld1%', '%strNew1%' | Out-File %%i"
  powershell -Command "(gc %%i) -replace '%strOld2%', '%strNew2%' | Out-File %%i"
  powershell -Command "(gc %%i) -replace '%strOld3%', '%strNew3%' | Out-File %%i"
  powershell -Command "(gc %%i) -replace '%strOld4%', '%strNew4%' | Out-File %%i"
  powershell -Command "(gc %%i) -replace '%strOld5%', '%strNew5%' | Out-File %%i"
  powershell -Command "(gc %%i) -replace '%strOld6%', '%strNew6%' | Out-File %%i"
  powershell -Command "(gc %%i) -replace '%strOld7%', '%strNew7%' | Out-File %%i"
  powershell -Command "(gc %%i) -replace '%strOld8%', '%strNew8%' | Out-File %%i"
)