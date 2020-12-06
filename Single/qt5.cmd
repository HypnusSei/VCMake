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

:: 编译静态库
set LibraryType=static

:: 还原代码
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: 清除 QT5 子目录
call %VCMakeRootPath%Single\qt5c.cmd %VCMakeRootPath%Source\%SourceCodeName%

:: QT5 安装目录
set QT5InstallPath=%dbyoungSDKPath%\QT5\%LibraryType%

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\qtbase\%SourceCodeName%.patch"
   CD /D "%VCMakeRootPath%Source\%SourceCodeName%\qtbase"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\qtbase\%SourceCodeName%.patch"
 )

:: 源代码目录
CD /D %VCMakeRootPath%Source\%SourceCodeName%"

:: 编译 <webengine 无法编译为 MT 静态库，所以要去除掉>
call configure -confirm-license -opensource -mp -release -%LibraryType% -prefix "%QT5InstallPath%" -opengl desktop -nomake examples  -nomake tests -skip qtwebengine
call jom
call jom install

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 还原代码
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: 清除 QT5 子目录
call %VCMakeRootPath%Single\qt5c.cmd %VCMakeRootPath%Source\%SourceCodeName%

:: 编译动态库
set LibraryType=shared

:: 重命名 static 静态库目录
CD /D "%dbyoungSDKPath%\QT5"
rename static static_bak

:: QT5 安装目录
set QT5InstallPath=%dbyoungSDKPath%\QT5\%LibraryType%

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\qtbase\%SourceCodeName%.patch"
   CD /D "%VCMakeRootPath%Source\%SourceCodeName%\qtbase"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\qtbase\%SourceCodeName%.patch"
 )

:: 源代码目录
CD /D %VCMakeRootPath%Source\%SourceCodeName%"

:: 编译 <webengine 无法编译为 MT 静态库，所以要去除掉>
call configure -confirm-license -opensource -mp -release -%LibraryType% -prefix "%QT5InstallPath%" -opengl desktop -nomake examples  -nomake tests -skip qtwebengine
call jom
call jom install

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 编译完成之后，恢复静态库目录
CD /D "%dbyoungSDKPath%\QT5"
rename static_bak static

:bEnd
