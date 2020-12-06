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
set "SourceFullPath=%VCMakeRootPath%Source\%SourceCodeName%"

:: ����Ŀ¼
set BuildFribidiPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: meson ����
meson --prefix=%dbyoungSDKPath% -Dbuildtype=release -Ddefault_library=static -Ddebug=false -Db_vscrt=mt -Ddocs=false %SourceFullPath% %BuildFribidiPath%
cd /D %BuildFribidiPath%
ninja
ninja install

:: ��װ֮�� 
cd /D "%dbyoungSDKPath%\lib"
rename libfribidi.a libfribidi.lib

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: Դ���뻹ԭ
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
