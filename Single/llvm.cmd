@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceCodeName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7
set VCProjectNameX=%8
set BuildLLVMPathX=%VCMakeRootPath%VSBuild\llvm\%BuildHostX8664%
set BuildCLANGPath=%VCMakeRootPath%VSBuild\clang\%BuildHostX8664%

:: 设置 CMake 编译参数
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %VCMakeRootPath%Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: 编译 llvm
echo 开始 CMake 编译
cmake %Bpara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildLLVMPathX% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\llvm
cmake %BuildLLVMPathX%

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %BuildLLVMPathX%\llvm.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildLLVMPathX%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildLLVMPathX%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  :: 再编译一次
  MSBuild.exe %BuildLLVMPathX%\llvm.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
   /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
   /flp1:LogFile=%BuildLLVMPathX%\zerror.log;errorsonly;Verbosity=diagnostic^
   /flp2:LogFile=%BuildLLVMPathX%\zwarns.log;warningsonly;Verbosity=diagnostic

  if %ERRORLEVEL% NEQ 0 (
    echo 如果出现堆栈溢出错误，请用 VS 打开，编译安装。成功后按任意键继续
    pause
  )
)
  
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildLLVMPathX%" --config Release --target install
	
:: 检查 CMake 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 如果出现堆栈溢出错误，请用 VS 打开，编译安装。成功后按任意键继续
  pause
)

echo ---------------------------------------------------------------------------------------------------------
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe

:: 删除编译临时目录
if exist %BuildCLANGPath% (
  echo 删除编译临时目录 %BuildCLANGPath%
  RD /S /Q "%BuildCLANGPath%"
)

:: 编译 clang
echo 编译 llvm - clang
title 编译 llvm - clang
cmake %Bpara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildCLANGPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\clang
cmake %BuildCLANGPath%

echo 如果命令行编译失败，用 CMAKE-GUI 打开，编译成功后，再按任意键继续
pause

:: VC 编译之前，检查是否有工程文件需要修改的补丁，有则给工程文件打补丁 (xz 工程有问题，不能编译 MT 类型)
if exist "%VCMakeRootPath%Patch\clang_sln.cmd" (
  echo 修正工程中，请稍候......
  call "%VCMakeRootPath%Patch\clang_sln.cmd" %BuildCLANGPath% %dbyoungSDKPath% %InstallSDKPath%
)

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %BuildCLANGPath%\clang.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildCLANGPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildCLANGPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  :: 再编译一次
  MSBuild.exe %BuildCLANGPath%\clang.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
   /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
   /flp1:LogFile=%BuildCLANGPath%\zerror.log;errorsonly;Verbosity=diagnostic^
   /flp2:LogFile=%BuildCLANGPath%\zwarns.log;warningsonly;Verbosity=diagnostic

  if %ERRORLEVEL% NEQ 0 (
    echo 如果出现堆栈溢出错误，请用 VS 打开，编译安装。成功后按任意键继续
    pause
  )
)
  
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildCLANGPath%" --config Release --target install
	
:: 检查 CMake 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 如果出现堆栈溢出错误，请用 VS 打开，编译安装。成功后按任意键继续
  pause
)

:: 源代码还原
cd /d "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:bEnd
