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

:: ����Ŀ¼
set BuildcairoPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: Դ����Ŀ¼
set "SourceFullPath=%VCMakeRootPath%Source\%SourceCodeName%"

:: ��ѹ
7z x %VCMakeRootPath%Single\cairo.7z -o"%BuildcairoPath%" -y
copy /Y "%BuildcairoPath%\src\cairo-features.h" "%SourceFullPath%\src\cairo-features.h" 

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include;%dbyoungSDKPath%\include\pixman-1;%dbyoungSDKPath%\include\freetype2;%SourceFullPath%\src;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildcairoPath%\cairo.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildHostX8664%^
 /flp1:LogFile=%BuildcairoPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildcairoPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
)

:: ��װ�ļ�
set "InstallPCPath=%dbyoungSDKPath:\=/%"
if not exist "%dbyoungSDKPath%\include\cairo" (
md "%dbyoungSDKPath%\include\cairo"
)
copy /Y "%BuildcairoPath%\%BuildHostX8664%\Release\cairo.lib" "%dbyoungSDKPath%\lib\cairo.lib"
copy /Y "%SourceFullPath%\src\cairo-deprecated.h" "%dbyoungSDKPath%\include\cairo\cairo-deprecated.h"
copy /Y "%SourceFullPath%\src\cairo-features.h" "%dbyoungSDKPath%\include\cairo\cairo-features.h"
copy /Y "%SourceFullPath%\src\cairo-ft.h" "%dbyoungSDKPath%\include\cairo\cairo-ft.h"
copy /Y "%SourceFullPath%\src\cairo-pdf.h" "%dbyoungSDKPath%\include\cairo\cairo-pdf.h"
copy /Y "%SourceFullPath%\src\cairo-ps.h" "%dbyoungSDKPath%\include\cairo\cairo-ps.h"
copy /Y "%SourceFullPath%\src\cairo-script.h" "%dbyoungSDKPath%\include\cairo\cairo-script.h"
copy /Y "%SourceFullPath%\src\cairo-svg.h" "%dbyoungSDKPath%\include\cairo\cairo-svg.h"
copy /Y "%SourceFullPath%\src\cairo-tee.h" "%dbyoungSDKPath%\include\cairo\cairo-tee.h"
copy /Y "%SourceFullPath%\src\cairo-win32.h"   "%dbyoungSDKPath%\include\cairo\cairo-win32.h"
copy /Y "%SourceFullPath%\src\cairo.h"         "%dbyoungSDKPath%\include\cairo\cairo.h"
copy /Y "%SourceFullPath%\cairo-version.h" "%dbyoungSDKPath%\include\cairo\cairo-version.h"
@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\cairo.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\cairo.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\cairo.pc
@echo Name: cairo>>%dbyoungSDKPath%\lib\pkgconfig\cairo.pc
@echo Description: Multi-platform 2D graphics library>>%dbyoungSDKPath%\lib\pkgconfig\cairo.pc
@echo Version: 0.40.0>>%dbyoungSDKPath%\lib\pkgconfig\cairo.pc
@echo Libs: -L${libdir} -lcairo -lzlib -lfreetype -lfontconfig -llibpng16 >>%dbyoungSDKPath%\lib\pkgconfig\cairo.pc
@echo Libs.private: -lcairo -lzlib -lfreetype -lfontconfig -llibpng16>>%dbyoungSDKPath%\lib\pkgconfig\cairo.pc
@echo Cflags:-I${includedir}/cairo>>%dbyoungSDKPath%\lib\pkgconfig\cairo.pc

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo exec_prefix=${prefix}>>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Name: cairo-win32>>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Description: Microsoft Windows surface backend for cairo graphics library>>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Version: 1.16.0>>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Requires: cairo >>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Libs:  -L${libdir} -lcairo>>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc
@echo Cflags: -I${includedir}/cairo >>%dbyoungSDKPath%\lib\pkgconfig\cairo-win32.pc

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
 echo ������ִ���ֹͣ����
 goto bEnd
)

:: Դ���뻹ԭ
cd /D "%SourceFullPath%"
git clean -d  -fx -f
git checkout .

:bEnd
