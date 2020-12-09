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

if %BuildLanguageX% == "Visual Studio 15 2017" (
  set Lang=vs2017
  ) else (
  set Lang=vs2019
)

:: 解压
7z x %VCMakeRootPath%Single\TBB.7z -o"%SourceFullPath%\build" -y

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %SourceFullPath%\build\%Lang%\makefile.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release-MT;Platform=%BuildPlatform_%^
 /flp1:LogFile=%SourceFullPath%\build\%Lang%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%SourceFullPath%\build\%Lang%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
 echo 编译出现错误，停止编译。可打开 VS 工程，编译成功后按任意键继续
 pause
)

:: 安装文件
set "InstallPCPath=%dbyoungSDKPath:\=/%"
if not exist "%dbyoungSDKPath%\include\TBB" (
md "%dbyoungSDKPath%\include\TBB"
)
copy  /Y "%SourceFullPath%\build\%Lang%\%BuildPlatform_%\Release-MT\TBB.lib" "%dbyoungSDKPath%\lib\TBB.lib"
copy  /Y "%SourceFullPath%\build\%Lang%\%BuildPlatform_%\TBB\Release-MT\TBB.pdb" "%dbyoungSDKPath%\lib\TBB.pdb"
copy  /Y "%SourceFullPath%\build\%Lang%\%BuildPlatform_%\Release-MT\tbbmalloc.lib" "%dbyoungSDKPath%\lib\tbbmalloc.lib"
copy  /Y "%SourceFullPath%\build\%Lang%\%BuildPlatform_%\Release-MT\tbbmalloc_proxy.lib" "%dbyoungSDKPath%\lib\tbbmalloc_proxy.lib"
xcopy /Y /E "%SourceFullPath%\include\*.*" "%dbyoungSDKPath%\include\TBB\"

:: 源代码还原
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .
