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

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: ��ѹ
7z x %VCMakeRootPath%Single\%SourceCodeName%.7z -o"%liblmdbSRC%\libraries\liblmdb" -y

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ����
cmake %sPara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildlmdbPath% -G %BuildLanguageX% -A %BuildPlatform_% %liblmdbSRC%\libraries\liblmdb
cmake %BuildlmdbPath%

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildlmdbPath%\lmdb.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildlmdbPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildlmdbPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildlmdbPath%" --config Release --target install

:: Դ���뻹ԭ
echo  ���� %SourceCodeName% ��ɣ�������ʱ�ļ�
title ���� %SourceCodeName% ��ɣ�������ʱ�ļ�
cd /d %~d0\Source\%SourceCodeName%
git clean -d  -fx -f
git checkout .

:bEnd

