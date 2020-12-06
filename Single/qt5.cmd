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

:: ���뾲̬��
set LibraryType=static

:: ��ԭ����
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: ��� QT5 ��Ŀ¼
call %VCMakeRootPath%Single\qt5c.cmd %VCMakeRootPath%Source\%SourceCodeName%

:: QT5 ��װĿ¼
set QT5InstallPath=%dbyoungSDKPath%\QT5\%LibraryType%

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\qtbase\%SourceCodeName%.patch"
   CD /D "%VCMakeRootPath%Source\%SourceCodeName%\qtbase"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\qtbase\%SourceCodeName%.patch"
 )

:: Դ����Ŀ¼
CD /D %VCMakeRootPath%Source\%SourceCodeName%"

:: ���� <webengine �޷�����Ϊ MT ��̬�⣬����Ҫȥ����>
call configure -confirm-license -opensource -mp -release -%LibraryType% -prefix "%QT5InstallPath%" -opengl desktop -nomake examples  -nomake tests -skip qtwebengine
call jom
call jom install

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ��ԭ����
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: ��� QT5 ��Ŀ¼
call %VCMakeRootPath%Single\qt5c.cmd %VCMakeRootPath%Source\%SourceCodeName%

:: ���붯̬��
set LibraryType=shared

:: ������ static ��̬��Ŀ¼
CD /D "%dbyoungSDKPath%\QT5"
rename static static_bak

:: QT5 ��װĿ¼
set QT5InstallPath=%dbyoungSDKPath%\QT5\%LibraryType%

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\qtbase\%SourceCodeName%.patch"
   CD /D "%VCMakeRootPath%Source\%SourceCodeName%\qtbase"
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\qtbase\%SourceCodeName%.patch"
 )

:: Դ����Ŀ¼
CD /D %VCMakeRootPath%Source\%SourceCodeName%"

:: ���� <webengine �޷�����Ϊ MT ��̬�⣬����Ҫȥ����>
call configure -confirm-license -opensource -mp -release -%LibraryType% -prefix "%QT5InstallPath%" -opengl desktop -nomake examples  -nomake tests -skip qtwebengine
call jom
call jom install

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: �������֮�󣬻ָ���̬��Ŀ¼
CD /D "%dbyoungSDKPath%\QT5"
rename static_bak static

:bEnd
