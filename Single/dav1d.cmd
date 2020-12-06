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
set Builddav1dPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: meson ����
meson --prefix=%InstallSDKPath% -Dbuildtype=release -Ddefault_library=static -Ddebug=false -Db_vscrt=mt -Denable_avx512=false %SourceFullPath% %Builddav1dPath%
cd /D %Builddav1dPath%
ninja
ninja install

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ��װ֮�� 
copy /Y %dbyoungSDKPath%\lib\libdav1d.a %dbyoungSDKPath%\lib\libdav1d.lib

:: Դ���뻹ԭ
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
