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
set BuildZenlibPathX=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ���� zenlib
cmake %sPara% -DSIZE_T_IS_NOT_LONG=ON -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildZenlibPathX% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\Project\CMake
cmake %BuildZenlibPathX%

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
	MSBuild.exe %BuildZenlibPathX%\zenlib.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildZenlibPathX%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildZenlibPathX%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
	CMake --build "%BuildZenlibPathX%" --config Release --target install
	
:: ��� CMake �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: Դ���뻹ԭ
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:bEnd
