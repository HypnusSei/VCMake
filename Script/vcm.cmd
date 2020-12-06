@echo off
SETLOCAL EnableDelayedExpansion
cls

set "VCMakeRootPath=%1"
set "SourceCodeName=%2"
set "BuildLanguageX=%3"
set "BuildPlatformX=%4"
set "BuildHostX8664=%5"
set "dbyoungSDKPath=%6"
set "InstallSDKPath=%7"
set "VCProjectNameX=%8"
set "VCBuildTmpPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%"
set "SourceFullPath=%VCMakeRootPath%Source\%SourceCodeName%"
set "mfxlibInc=%dbyoungSDKPath%\include"
set "mfxlibLib=%dbyoungSDKPath%\lib"

:: 是否使用 GPU 
set "USEGPU="
if %BuildHostX8664%==x86 (
 set "USEGPU=-DCPU_ONLY=ON -DWITH_CUDA=OFF -DVTK_USE_CUDA=OFF"
) else (
 set "USEGPU=-DCPU_ONLY=OFF -DWITH_CUDA=ON -DVTK_USE_CUDA=ON"
)

:: 删除编译临时目录
if exist %VCBuildTmpPath% (
  echo 删除编译临时目录 %VCBuildTmpPath%
  RD /S /Q "%VCBuildTmpPath%"
)

:: 如果存在独立编译，就使用独立编译；编译 CMake 不支持的项目；如：boost, QT 等
if exist "%VCMakeRootPath%Single\%SourceCodeName%.cmd" (
   echo 使用独立编译
   call "%VCMakeRootPath%Single\%SourceCodeName%.cmd" %VCMakeRootPath% %dbyoungSDKPath% %InstallSDKPath% %SourceCodeName% %BuildPlatformX% %BuildLanguageX% %BuildHostX8664% %VCProjectNameX%
   goto bEnd
)

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   echo 打补丁
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   cd "%VCMakeRootPath%Source\%SourceCodeName%"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
)

:: 设置 CMake 编译参数
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: 查找 patch 目录下是否有同项目名称的 txt 文本，如果有则复制过来，并重命名为 CMakelists.txt
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.txt" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.txt" "%VCMakeRootPath%Source\%SourceCodeName%\CMakelists.txt" 
)

:: 检查是否有 CMakeLists.txt 文件；如果没有，退出编译
if not exist "%VCMakeRootPath%Source\%SourceCodeName%\CMakelists.txt" (
   echo 没有 CMakelists.txt 文件，不支持编译
   pause
   goto bEnd
) 

:: 开始 CMake 编译
echo 开始 CMake 编译
CMake  %Bpara% %USEGPU% -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B "%VCBuildTmpPath%" -G %BuildLanguageX% -A %BuildPlatformX% %VCMakeRootPath%Source\%SourceCodeName%
CMake "%VCBuildTmpPath%"

:: 检查 CMake 编译是否有错误
if %errorlevel% NEQ 0 (
  echo 编译出现错误，停止编译
  echo 如果命令行编译失败，用 CMAKE-GUI 打开，编译成功后，再按任意键继续
  pause
)

:: VC 编译之前，检查是否有工程文件需要修改的补丁，有则给工程文件打补丁 (xz 工程有问题，不能编译 MT 类型)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo 修正工程中，请稍候......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %VCBuildTmpPath% %dbyoungSDKPath% %VCMakeRootPath%
)

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
echo 开始 VC 多进程编译
MSBuild.exe %VCBuildTmpPath%\%VCProjectNameX% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
  /target:Build /property:Configuration=Release;Platform=%BuildPlatformX%^
  /flp1:LogFile=%VCBuildTmpPath%\zerror.log;errorsonly;Verbosity=diagnostic^
  /flp2:LogFile=%VCBuildTmpPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %errorlevel% NEQ 0 (
  echo 编译出现错误，停止编译
  echo 如果命令行编译失败，用 CMAKE-GUI 打开，编译成功后，再按任意键继续
  call %VCBuildTmpPath%\%VCProjectNameX%
  pause
)

:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
echo 开始 CMake 编译和安装
CMake --build "%VCBuildTmpPath%" --config Release --target install

:: 安装之后，是否有自定义的动作
if exist "%VCMakeRootPath%After\%SourceCodeName%.cmd" (
  call "%VCMakeRootPath%After\%SourceCodeName%.cmd"  %VCMakeRootPath% %dbyoungSDKPath% %InstallSDKPath% %SourceCodeName% %BuildPlatformX% %BuildLanguageX% %BuildHostX8664%
)

:: 检查 CMake 编译是否有错误
if %errorlevel% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 源代码还原
echo 编译 %SourceCodeName% 完成，清理临时文件
title 编译 %SourceCodeName% 完成，清理临时文件
echo ------------------------------------------------------------------------------------------------------------------------
if exist "%SourceFullPath%\.git\" (
  cd /D "%SourceFullPath%"
  git clean -d  -fx -f 
  git checkout .
)

:: 删除临时文件 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.xz"  del "%VCMakeRootPath%%SourceCodeName%.tar.xz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"

:bEnd
