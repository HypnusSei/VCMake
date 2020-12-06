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
set BuildharfbuzzPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: meson ����
if exist %BuildharfbuzzPath% (
  rd /S /Q %BuildharfbuzzPath%
)

meson --prefix=%InstallSDKPath% -Dbuildtype=release -Ddefault_library=static -Ddebug=false -Db_vscrt=mt -Dlibpng=disabled %SourceFullPath% %BuildharfbuzzPath%
cd /D %BuildharfbuzzPath%
ninja
ninja install

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ��װ֮�� 
copy /Y "%InstallSDKPath%\lib\libharfbuzz.a" "%InstallSDKPath%\lib\libharfbuzz.lib"
copy /Y "%InstallSDKPath%\lib\libharfbuzz-subset.a" "%InstallSDKPath%\lib\libharfbuzz-subset.lib"
copy /Y "%InstallSDKPath%\lib\libharfbuzz.a" "%InstallSDKPath%\lib\harfbuzz.lib"
copy /Y "%InstallSDKPath%\lib\libharfbuzz-subset.a" "%InstallSDKPath%\lib\harfbuzz-subset.lib"

:: Դ���뻹ԭ
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
