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
set BuildExpatPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ���� libexpat
cmake %sPara% -DCMAKE_INSTALL_PREFIX=%dbyoungSDKPath% -Thost=%BuildHostX8664% -B %BuildExpatPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\expat
cmake %BuildExpatPath%

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildExpatPath%\expat.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildExpatPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildExpatPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)
  
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildExpatPath%" --config Release --target install

:: ��� CMake �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

Copy /Y "%dbyoungSDKPath%\lib\libexpatMT.lib" "%dbyoungSDKPath%\lib\libexpat.lib"
  
  
:bEnd
