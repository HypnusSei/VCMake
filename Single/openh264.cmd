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
set BuildOpenH264Path=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: meson ����
meson --prefix=%InstallSDKPath% -Dbuildtype=release -Ddefault_library=static -Ddebug=false -Db_vscrt=mt %SourceFullPath% %BuildOpenH264Path%
cd /D %BuildOpenH264Path%
ninja
ninja install

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ��װ֮�� 
del  /Q "%InstallSDKPath%\lib\openh264.lib"
copy /Y "%BuildOpenH264Path%\libopenh264.a" "%InstallSDKPath%\lib\libopenh264.lib"
copy /Y "%BuildOpenH264Path%\libopenh264.a" "%InstallSDKPath%\lib\openh264.lib"
del  /Q "%InstallSDKPath%\bin\openh264-6.dll"

:: Դ���뻹ԭ
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
