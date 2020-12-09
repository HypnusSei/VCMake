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

:: ���� OpenBlas
CMake -G "Ninja" -DCMAKE_CXX_COMPILER=clang-cl -DCMAKE_C_COMPILER=clang-cl -DCMAKE_Fortran_COMPILER=flang -DBUILD_WITHOUT_LAPACK=no -DBUILD_SHARED_LIBS=OFF -DNOFORTRAN=0 -DDYNAMIC_ARCH=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -B %BuildOpenBlasPath% %~d0\Source\%SourceCodeName%
CMake %BuildOpenBlasPath%
 
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildOpenBlasPath%" --config Release --target install
	
:: ��� CMake �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:bEnd
