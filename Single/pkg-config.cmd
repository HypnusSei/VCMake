@echo off
SETLOCAL EnableDelayedExpansion
Color A

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceCodeName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7
set VCProjectNameX=%8
set "PKG_CONFIG_PATH=%dbyoungSDKPath%\lib\pkgconfig"

:: 源代码目录
set "SourceFullPath=%VCMakeRootPath%Source\%SourceCodeName%"

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

cd /D %SourceFullPath%

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

copy config.h.win32.in config.h
copy %VCMakeRootPath%Single\pkg-config.h %dbyoungSDKPath%\include\msvc_recommended_pragmas.h

:: VC 编译
nmake /f Makefile.vc CFG=release

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 安装
copy /Y  "Release\%BuildPlatform_%\pkg-config.exe" "%dbyoungSDKPath%\bin\pkg-config.exe"

:: 源代码还原
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
