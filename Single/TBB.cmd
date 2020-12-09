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
set "PKG_CONFIG_PATH=%dbyoungSDKPath%\lib\pkgconfig"

:: Դ����Ŀ¼
set "SourceFullPath=%~d0\Source\%SourceCodeName%"

if %BuildLanguageX% == "Visual Studio 15 2017" (
  set Lang=vs2017
  ) else (
  set Lang=vs2019
)

:: ��ѹ
7z x %VCMakeRootPath%Single\TBB.7z -o"%SourceFullPath%\build" -y

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %SourceFullPath%\build\%Lang%\makefile.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release-MT;Platform=%BuildPlatform_%^
 /flp1:LogFile=%SourceFullPath%\build\%Lang%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%SourceFullPath%\build\%Lang%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
 echo ������ִ���ֹͣ���롣�ɴ� VS ���̣�����ɹ������������
 pause
)

:: ��װ�ļ�
set "InstallPCPath=%dbyoungSDKPath:\=/%"
if not exist "%dbyoungSDKPath%\include\TBB" (
md "%dbyoungSDKPath%\include\TBB"
)
copy  /Y "%SourceFullPath%\build\%Lang%\%BuildPlatform_%\Release-MT\TBB.lib" "%dbyoungSDKPath%\lib\TBB.lib"
copy  /Y "%SourceFullPath%\build\%Lang%\%BuildPlatform_%\TBB\Release-MT\TBB.pdb" "%dbyoungSDKPath%\lib\TBB.pdb"
copy  /Y "%SourceFullPath%\build\%Lang%\%BuildPlatform_%\Release-MT\tbbmalloc.lib" "%dbyoungSDKPath%\lib\tbbmalloc.lib"
copy  /Y "%SourceFullPath%\build\%Lang%\%BuildPlatform_%\Release-MT\tbbmalloc_proxy.lib" "%dbyoungSDKPath%\lib\tbbmalloc_proxy.lib"
xcopy /Y /E "%SourceFullPath%\include\*.*" "%dbyoungSDKPath%\include\TBB\"

:: Դ���뻹ԭ
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .
