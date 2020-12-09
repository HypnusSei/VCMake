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

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%SourceFullPath%\%SourceCodeName%.patch"
   cd /D "%SourceFullPath%"
   git apply "%SourceCodeName%.patch"
   del "%SourceFullPath%\%SourceCodeName%.patch"
 )

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

if %BuildLanguageX% == "Visual Studio 15 2017" (
  set Lang=vs2017
  ) else (
  set Lang=vs2019
)
  
:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %SourceFullPath%\amf\public\proj\%Lang%\AmfMediaCommon.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%SourceFullPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%SourceFullPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译。可打开 VS 工程，编译成功后按任意键继续
  pause
)

:: 安装文件
set "InstallPCPath=%dbyoungSDKPath:\=/%"
if not exist "%dbyoungSDKPath%\include\AMF" (
md "%dbyoungSDKPath%\include\AMF"
)

if %BuildPlatform_% == Win32 (
  set wp=x32
  ) else (
 set wp=x64
)
 
xcopy /Y /E "%SourceFullPath%\amf\public\include\*.*" "%dbyoungSDKPath%\include\AMF\"
copy  /Y "%SourceFullPath%\amf\BIN\%Lang%%wp%Release\AmfMediaCommon.lib" "%dbyoungSDKPath%\lib\AmfMediaCommon.lib"

:: 源代码还原
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
