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
set BuildLapackPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: 设置 CMake 编译参数
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: Intel Parallel Studio 2020 开发组件 (包含 ifort 编译器)
set "IntelCompilePath=H:\Green\Language\Intel\PSXE2020\compilers_and_libraries_2020.4.311\windows"
if not exist %IntelCompilePath% (
  echo Intel Parallel Studio 2020 编译器不存在，无法编译 lapack
  pause
  goto bEnd 
)

if %BuildLanguageX% == "Visual Studio 15 2017" (
  set Lang=vs2017
  ) else (
  set Lang=vs2019
)

if %BuildHostX8664%==x86 (
  call %IntelCompilePath%\bin\ipsxe-comp-vars.bat ia32 %Lang%
  set "Intelifort1=%IntelCompilePath%\bin\intel64_ia32\ifort.exe"
  set "Intelclang1=%IntelCompilePath%\bin\intel64_ia32\icl.exe"
  goto bCompile
) else (
  call %IntelCompilePath%\bin\ipsxe-comp-vars.bat intel64 %Lang%
  set "Intelifort1=%IntelCompilePath%\bin\intel64\ifort.exe"
  set "Intelclang1=%IntelCompilePath%\bin\intel64\icl.exe"
)

:bCompile
set "Intelifort=%Intelifort1:\=/%"
set "Intelclang=%Intelclang1:\=/%"

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%dbyoungSDKPath%\include\libxml2;%dbyoungSDKPath%\include;%dbyoungSDKPath%\include\TBB;%dbyoungSDKPath%\include\harfbuzz;%dbyoungSDKPath%\QT5\static\include;%dbyoungSDKPath%\include\glib-2.0;%dbyoungSDKPath%\lib\glib-2.0\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%dbyoungSDKPath%\QT5\static\lib;%LIB%"
set "UseEnv=True"

:: 编译 lapack
CMake %Bpara% -G "Ninja" -DCMAKE_CXX_COMPILER=%Intelclang% -DCMAKE_C_COMPILER=%Intelclang% -DCMAKE_Fortran_COMPILER=%Intelifort% -DBLAS++=ON -DCBLAS=ON -DLAPACK++=ON -DLAPACKE=ON -DUSE_OPTIMIZED_BLAS=OFF -DUSE_OPTIMIZED_LAPACK=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -B %BuildLapackPath% %~d0\Source\%SourceCodeName%
CMake %BuildLapackPath%
 
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildLapackPath%" --config Release --target install
	
:: 检查 CMake 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 安装之后，是否有自定义的动作
 if exist "%VCMakeRootPath%After\%SourceCodeName%.cmd" (
 call "%VCMakeRootPath%After\%SourceCodeName%.cmd"  %VCMakeRootPath% %dbyoungSDKPath% %InstallSDKPath% %SourceProjName% %BuildPlatform_% %BuildLanguageX% %BuildHostX8664%
)

:bEnd
