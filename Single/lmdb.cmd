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
set "liblmdbSRC=%~d0\Source\%SourceCodeName%"
set "BuildlmdbPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%"

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: 解压
7z x %VCMakeRootPath%Single\%SourceCodeName%.7z -o"%liblmdbSRC%\libraries\liblmdb" -y

:: 设置 CMake 编译参数
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: 编译
cmake %sPara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildlmdbPath% -G %BuildLanguageX% -A %BuildPlatform_% %liblmdbSRC%\libraries\liblmdb
cmake %BuildlmdbPath%

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %BuildlmdbPath%\lmdb.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildlmdbPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildlmdbPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildlmdbPath%" --config Release --target install

:: 源代码还原
echo  编译 %SourceCodeName% 完成，清理临时文件
title 编译 %SourceCodeName% 完成，清理临时文件
cd /d %~d0\Source\%SourceCodeName%
git clean -d  -fx -f
git checkout .

:bEnd

