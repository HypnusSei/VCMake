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

:: �Ƿ�ʹ�� GPU 
set "USEGPU="
if %BuildHostX8664%==x86 (
 set "USEGPU=-DCPU_ONLY=ON -DWITH_CUDA=OFF -DVTK_USE_CUDA=OFF"
) else (
 set "USEGPU=-DCPU_ONLY=OFF -DWITH_CUDA=ON -DVTK_USE_CUDA=ON"
)

:: ɾ��������ʱĿ¼
if exist %VCBuildTmpPath% (
  echo ɾ��������ʱĿ¼ %VCBuildTmpPath%
  RD /S /Q "%VCBuildTmpPath%"
)

:: ������ڶ������룬��ʹ�ö������룻���� CMake ��֧�ֵ���Ŀ���磺boost, QT ��
if exist "%VCMakeRootPath%Single\%SourceCodeName%.cmd" (
   echo ʹ�ö�������
   call "%VCMakeRootPath%Single\%SourceCodeName%.cmd" %VCMakeRootPath% %dbyoungSDKPath% %InstallSDKPath% %SourceCodeName% %BuildPlatformX% %BuildLanguageX% %BuildHostX8664% %VCProjectNameX%
   goto bEnd
)

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   echo �򲹶�
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   cd "%VCMakeRootPath%Source\%SourceCodeName%"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
)

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ���� patch Ŀ¼���Ƿ���ͬ��Ŀ���Ƶ� txt �ı�����������ƹ�������������Ϊ CMakelists.txt
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.txt" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.txt" "%VCMakeRootPath%Source\%SourceCodeName%\CMakelists.txt" 
)

:: ����Ƿ��� CMakeLists.txt �ļ������û�У��˳�����
if not exist "%VCMakeRootPath%Source\%SourceCodeName%\CMakelists.txt" (
   echo û�� CMakelists.txt �ļ�����֧�ֱ���
   pause
   goto bEnd
) 

:: ��ʼ CMake ����
echo ��ʼ CMake ����
CMake  %Bpara% %USEGPU% -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B "%VCBuildTmpPath%" -G %BuildLanguageX% -A %BuildPlatformX% %VCMakeRootPath%Source\%SourceCodeName%
CMake "%VCBuildTmpPath%"

:: ��� CMake �����Ƿ��д���
if %errorlevel% NEQ 0 (
  echo ������ִ���ֹͣ����
  echo ��������б���ʧ�ܣ��� CMAKE-GUI �򿪣�����ɹ����ٰ����������
  pause
)

:: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo ���������У����Ժ�......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %VCBuildTmpPath% %dbyoungSDKPath% %VCMakeRootPath%
)

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
echo ��ʼ VC ����̱���
MSBuild.exe %VCBuildTmpPath%\%VCProjectNameX% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
  /target:Build /property:Configuration=Release;Platform=%BuildPlatformX%^
  /flp1:LogFile=%VCBuildTmpPath%\zerror.log;errorsonly;Verbosity=diagnostic^
  /flp2:LogFile=%VCBuildTmpPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %errorlevel% NEQ 0 (
  echo ������ִ���ֹͣ����
  echo ��������б���ʧ�ܣ��� CMAKE-GUI �򿪣�����ɹ����ٰ����������
  call %VCBuildTmpPath%\%VCProjectNameX%
  pause
)

:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
echo ��ʼ CMake ����Ͱ�װ
CMake --build "%VCBuildTmpPath%" --config Release --target install

:: ��װ֮���Ƿ����Զ���Ķ���
if exist "%VCMakeRootPath%After\%SourceCodeName%.cmd" (
  call "%VCMakeRootPath%After\%SourceCodeName%.cmd"  %VCMakeRootPath% %dbyoungSDKPath% %InstallSDKPath% %SourceCodeName% %BuildPlatformX% %BuildLanguageX% %BuildHostX8664%
)

:: ��� CMake �����Ƿ��д���
if %errorlevel% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: Դ���뻹ԭ
echo ���� %SourceCodeName% ��ɣ�������ʱ�ļ�
title ���� %SourceCodeName% ��ɣ�������ʱ�ļ�
echo ------------------------------------------------------------------------------------------------------------------------
if exist "%SourceFullPath%\.git\" (
  cd /D "%SourceFullPath%"
  git clean -d  -fx -f 
  git checkout .
)

:: ɾ����ʱ�ļ� 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.xz"  del "%VCMakeRootPath%%SourceCodeName%.tar.xz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"

:bEnd
