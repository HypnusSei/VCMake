@echo off
setlocal EnableDelayedExpansion

set VCMakeRootPath=%1
set InstallSDKPath=%2
set NoPlatformPath=%InstallSDKPath:~0,-4%
set bPC=1

if not exist "%NoPlatformPath%\x86\lib\libmfx.lib" (
  cls
  title 安装 Intel Media Software Development Kit 
  7z x %VCMakeRootPath%Tools\ThirdLib\mfx.7z -o"%NoPlatformPath%" -y
) 

if not exist "%NoPlatformPath%\x86\lib\openblas.lib" (
  cls
  title 安装 OpenBLAS SDK
  7z x %VCMakeRootPath%Tools\ThirdLib\openblas.7z -o"%NoPlatformPath%" -y
  set bPC=0
)

if not exist "%NoPlatformPath%\x86\bin\ffmpeg.exe" (
  cls
  title 安装 FFMPEG SDK
  7z x %VCMakeRootPath%Tools\ThirdLib\ffmpeg.7z -o"%NoPlatformPath%" -y
  set bPC=0
)

:: 修改 PC 文件
if %bPC%==0 (
   title 修改 PC 文件路径
   goto MPC
 )

goto bEnd

:MPC

:: x86
CD /D "%NoPlatformPath%\x86\lib\pkgconfig"
set "strOld1=_xPath_"
set "strRep1=%NoPlatformPath%\x86"
set "strNew1=%strRep1:\=/%"
for /f %%i in ('dir /b /a:-d *.pc') do (
  powershell -Command "(gc %%i) -replace '%strOld1%', '%strNew1%' | Out-File %%i"
)

:: x64
CD /D "%NoPlatformPath%\x64\lib\pkgconfig"
set "strOld2=_xPath_"
set "strRep2=%NoPlatformPath%\x64"
set "strNew2=%strRep2:\=/%"
for /f %%i in ('dir /b /a:-d *.pc') do (
  powershell -Command "(gc %%i) -replace '%strOld2%', '%strNew2%' | Out-File %%i"
)


:bEnd

