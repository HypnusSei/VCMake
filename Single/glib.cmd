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
set "SourceFullPath=%~d0\Source\%SourceCodeName%"

:: 编译目录
set BuildGlibPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%SourceFullPath%\%SourceCodeName%.patch"
   CD /D %SourceFullPath%
   git apply "%SourceCodeName%.patch"
   del "%SourceFullPath%\%SourceCodeName%.patch"
 )

:: meson 编译
meson --prefix=%InstallSDKPath% -Dbuildtype=release -Ddefault_library=static -Ddebug=false -Db_vscrt=mt -Diconv=external %SourceFullPath% %BuildGlibPath%
cd /D %BuildGlibPath%
ninja
ninja install

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 安装之后 
copy /Y "%dbyoungSDKPath%\lib\libglib-2.0.a" "%dbyoungSDKPath%\lib\libglib-2.0.lib"
copy /Y "%dbyoungSDKPath%\lib\libgobject-2.0.a" "%dbyoungSDKPath%\lib\libgobject-2.0.lib"
copy /Y "%dbyoungSDKPath%\lib\libgthread-2.0.a" "%dbyoungSDKPath%\lib\libgthread-2.0.lib"
copy /Y "%dbyoungSDKPath%\lib\libgmodule-2.0.a" "%dbyoungSDKPath%\lib\libgmodule-2.0.lib"
copy /Y "%dbyoungSDKPath%\lib\libgio-2.0.a" "%dbyoungSDKPath%\lib\libgio-2.0.lib"
del  /Q "%dbyoungSDKPath%\lib\intl.a"
del  /Q "%dbyoungSDKPath%\lib\intl.lib"
copy /Y "%dbyoungSDKPath%\lib\libintl.a" "%dbyoungSDKPath%\lib\libintl.lib"
copy /Y "%dbyoungSDKPath%\lib\libintl.a" "%dbyoungSDKPath%\lib\intl.lib"
copy /Y "%dbyoungSDKPath%\lib\libffi.a" "%dbyoungSDKPath%\lib\libffi.lib"

:: 源代码还原
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
