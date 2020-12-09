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
set BuildOpenBlasPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

call %VCMakeRootPath%\Tools\mconda3\Scripts\activate.bat %VCMakeRootPath%\Tools\mconda3

set "LIB=%CONDA_PREFIX%\Library\lib;%LIB%"
set "CPATH=%CONDA_PREFIX%\Library\include;%CPATH%"

:: 编译 OpenBlas
CMake -G "Ninja" -DCMAKE_CXX_COMPILER=clang-cl -DCMAKE_C_COMPILER=clang-cl -DCMAKE_Fortran_COMPILER=flang -DBUILD_WITHOUT_LAPACK=no -DBUILD_SHARED_LIBS=OFF -DNOFORTRAN=0 -DDYNAMIC_ARCH=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -B %BuildOpenBlasPath% %~d0\Source\%SourceCodeName%
CMake %BuildOpenBlasPath%
 
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildOpenBlasPath%" --config Release --target install
	
:: 检查 CMake 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:bEnd
