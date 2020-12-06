@echo off
set "dbyoungSDKPath=H:\Github\VCMake\VSSDK\x64"
set "InstallSDKPath=%dbyoungSDKPath%"
set "VCMakeRootPath=H:\Github\VCMake\"
set "SourceCodeName=lapack"
set "BuildLapackPath=H:\Github\VCMake\VSBuild\lapack\x64"
set "IntelCompilePath=H:\Green\Language\Intel\PSXE2020\compilers_and_libraries_2020.4.311\windows"
set "Intelifort1=%IntelCompilePath%\bin\intel64\ifort.exe"
set "Intelclang1=%IntelCompilePath%\bin\intel64\icl.exe"
set "Intelifort=%Intelifort1:\=/%"
set "Intelclang=%Intelclang1:\=/%"

call %IntelCompilePath%\bin\ipsxe-comp-vars.bat intel64 vs2019

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include\libxml2;%dbyoungSDKPath%\include;%dbyoungSDKPath%\include\TBB;%dbyoungSDKPath%\include\harfbuzz;%dbyoungSDKPath%\QT5\static\include;%dbyoungSDKPath%\include\glib-2.0;%dbyoungSDKPath%\lib\glib-2.0\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%dbyoungSDKPath%\QT5\static\lib;%LIB%"
set "UseEnv=True"

:: ���� lapack
CMake -G "Ninja" -DCMAKE_CXX_COMPILER=%Intelclang% -DCMAKE_C_COMPILER=%Intelclang% -DCMAKE_Fortran_COMPILER=%Intelifort% -DBLAS++=ON -DCBLAS=ON -DLAPACK++=ON -DLAPACKE=ON -DUSE_OPTIMIZED_BLAS=OFF -DUSE_OPTIMIZED_LAPACK=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -B %BuildLapackPath% %VCMakeRootPath%Source\%SourceCodeName%
CMake %BuildLapackPath%
 
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildLapackPath%" --config Release --target install
