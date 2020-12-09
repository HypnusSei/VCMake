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

:: ����Ŀ¼
set BuildGlibPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%SourceFullPath%\%SourceCodeName%.patch"
   CD /D %SourceFullPath%
   git apply "%SourceCodeName%.patch"
   del "%SourceFullPath%\%SourceCodeName%.patch"
 )

:: meson ����
meson --prefix=%InstallSDKPath% -Dbuildtype=release -Ddefault_library=static -Ddebug=false -Db_vscrt=mt -Diconv=external %SourceFullPath% %BuildGlibPath%
cd /D %BuildGlibPath%
ninja
ninja install

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ��װ֮�� 
copy /Y "%dbyoungSDKPath%\lib\libglib-2.0.a" "%dbyoungSDKPath%\lib\libglib-2.0.lib"
copy /Y "%dbyoungSDKPath%\lib\libgobject-2.0.a" "%dbyoungSDKPath%\lib\libgobject-2.0.lib"
copy /Y "%dbyoungSDKPath%\lib\libgthread-2.0.a" "%dbyoungSDKPath%\lib\libgthread-2.0.lib"
copy /Y "%dbyoungSDKPath%\lib\libgmodule-2.0.a" "%dbyoungSDKPath%\lib\libgmodule-2.0.lib"
copy /Y "%dbyoungSDKPath%\lib\libgio-2.0.a" "%dbyoungSDKPath%\lib\libgio-2.0.lib"
del  /Q "%dbyoungSDKPath%\lib\intl.a"
del  /Q "%dbyoungSDKPath%\lib\intl.lib"
copy /Y "%dbyoungSDKPath%\lib\libintl.a" "%dbyoungSDKPath%\lib\libintl.lib"
copy /Y "%dbyoungSDKPath%\lib\libintl.a" "%dbyoungSDKPath%\lib\intl.lib"
copy /Y "%dbyoungSDKPath%\lib\libffi.a" "%dbyoungSDKPath%\lib\libffi.lib"

:: Դ���뻹ԭ
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
