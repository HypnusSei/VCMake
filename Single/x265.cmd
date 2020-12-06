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
set Buildx265PathX=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: 设置 CMake 编译参数
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: 编译 x265
cmake %sPara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %Buildx265PathX% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\source
cmake %Buildx265PathX%

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %Buildx265PathX%\x265.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%Buildx265PathX%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%Buildx265PathX%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)
  
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
	CMake --build "%Buildx265PathX%" --config Release --target install
	
:: 检查 CMake 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 安装 
copy /Y %dbyoungSDKPath%\lib\x265-static.lib %dbyoungSDKPath%\lib\x265.lib

:bEnd
