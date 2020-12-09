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
set "flacSRC=%~d0\Source\%SourceCodeName%"

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include;%dbyoungSDKPath%\include\pixman-1;%dbyoungSDKPath%\include\freetype2;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: ��ѹ
7z x %VCMakeRootPath%Single\%SourceCodeName%.7z -o"%flacSRC%" -y

if %BuildHostX8664%==x64 (
  copy /Y "%dbyoungSDKPath%\lib\libogg_static.lib" "%flacSRC%\objs\%BuildHostX8664%\Release\lib\libogg_static.lib"
) else (
  copy /Y "%dbyoungSDKPath%\lib\libogg_static.lib" "%flacSRC%\objs\Release\lib\libogg_static.lib"
)

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %flacSRC%\flac.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%flacSRC%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%flacSRC%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ���롣�ɴ� VS ���̣�����ɹ������������
  pause
)

:: ��װ�ļ�
set "InstallPCPath=%dbyoungSDKPath:\=/%"
if not exist "%dbyoungSDKPath%\include\flac" (
md "%dbyoungSDKPath%\include\flac")
if not exist "%dbyoungSDKPath%\include\flac++" (
md "%dbyoungSDKPath%\include\flac++")

if %BuildHostX8664%==x64 (
  copy /Y "%flacSRC%\objs\x64\Release\lib\libFLAC_static.lib"     "%dbyoungSDKPath%\lib\libFLAC_static.lib"
  copy /Y "%flacSRC%\objs\x64\Release\lib\libFLAC_static.lib"     "%dbyoungSDKPath%\lib\libFLAC.lib"
  copy /Y "%flacSRC%\objs\x64\Release\lib\libFLAC++_static.lib"   "%dbyoungSDKPath%\lib\libFLAC++_static.lib"
  copy /Y "%flacSRC%\objs\x64\Release\lib\libFLAC++_static.lib"   "%dbyoungSDKPath%\lib\libFLAC++.lib"
) else (
  copy /Y "%flacSRC%\objs\Release\lib\libFLAC_static.lib"     "%dbyoungSDKPath%\lib\libFLAC_static.lib"
  copy /Y "%flacSRC%\objs\Release\lib\libFLAC_static.lib"     "%dbyoungSDKPath%\lib\libFLAC.lib"
  copy /Y "%flacSRC%\objs\Release\lib\libFLAC++_static.lib"   "%dbyoungSDKPath%\lib\libFLAC++_static.lib"
  copy /Y "%flacSRC%\objs\Release\lib\libFLAC++_static.lib"   "%dbyoungSDKPath%\lib\libFLAC++.lib"
)

copy /Y "%flacSRC%\include\flac\all.h"            "%dbyoungSDKPath%\include\flac\all.h"
copy /Y "%flacSRC%\include\flac\assert.h"         "%dbyoungSDKPath%\include\flac\assert.h"
copy /Y "%flacSRC%\include\flac\callback.h"       "%dbyoungSDKPath%\include\flac\callback.h"
copy /Y "%flacSRC%\include\flac\export.h"         "%dbyoungSDKPath%\include\flac\export.h"
copy /Y "%flacSRC%\include\flac\format.h"        "%dbyoungSDKPath%\include\flac\format.h"
copy /Y "%flacSRC%\include\flac\metadata.h"       "%dbyoungSDKPath%\include\flac\metadata.h"
copy /Y "%flacSRC%\include\flac\ordinals.h"       "%dbyoungSDKPath%\include\flac\ordinals.h"
copy /Y "%flacSRC%\include\flac\stream_decoder.h" "%dbyoungSDKPath%\include\flac\stream_decoder.h"
copy /Y "%flacSRC%\include\flac\stream_encoder.h" "%dbyoungSDKPath%\include\flac\stream_encoder.h"

copy /Y "%flacSRC%\include\FLAC++\all.h"          "%dbyoungSDKPath%\include\FLAC++\all.h"
copy /Y "%flacSRC%\include\FLAC++\decoder.h"      "%dbyoungSDKPath%\include\FLAC++\decoder.h"
copy /Y "%flacSRC%\include\FLAC++\encoder.h"      "%dbyoungSDKPath%\include\FLAC++\encoder.h"
copy /Y "%flacSRC%\include\FLAC++\export.h"       "%dbyoungSDKPath%\include\FLAC++\export.h"
copy /Y "%flacSRC%\include\FLAC++\metadata.h"     "%dbyoungSDKPath%\include\FLAC++\metadata.h"

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\flac.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\flac.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\flac.pc
@echo Name: FLAC>>%dbyoungSDKPath%\lib\pkgconfig\flac.pc
@echo Description: Free Lossless Audio Codec Library>>%dbyoungSDKPath%\lib\pkgconfig\flac.pc
@echo Version: 1.3.2>>%dbyoungSDKPath%\lib\pkgconfig\flac.pc
@echo Requires.private: ogg>>%dbyoungSDKPath%\lib\pkgconfig\flac.pc
@echo Libs: -L${libdir} -lflac -logg >>%dbyoungSDKPath%\lib\pkgconfig\flac.pc
@echo Libs.private: -lflac -logg>>%dbyoungSDKPath%\lib\pkgconfig\flac.pc
@echo Cflags:-I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\flac.pc

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc
@echo Name: FLAC++>>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc
@echo Description: Free Lossless Audio Codec Library (C++ API)>>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc
@echo Version: 1.3.2>>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc
@echo Requires.private: ogg flac>>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc
@echo Libs: -L${libdir} -lFLAC++ -logg >>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc
@echo Libs.private: -lFLAC++ -logg>>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc
@echo Cflags:-I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\flac++.pc

:: ɾ����ʱ�ļ� 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.xz"  del "%VCMakeRootPath%%SourceCodeName%.tar.xz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"
