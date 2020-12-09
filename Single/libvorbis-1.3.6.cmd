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

:: 源代码目录
set "libvorbisSRC=%~d0\Source\%SourceCodeName%"

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%dbyoungSDKPath%\include;%dbyoungSDKPath%\include\pixman-1;%dbyoungSDKPath%\include\freetype2;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

if %BuildLanguageX% == "Visual Studio 15 2017" (
  set Lang=vs2017
  ) else (
  set Lang=vs2019
)

:: 解压
7z x %VCMakeRootPath%Single\%SourceCodeName%.7z -o"%libvorbisSRC%\Win32" -y

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %libvorbisSRC%\Win32\%Lang%\vorbis_static.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%libvorbisSRC%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%libvorbisSRC%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译。可打开 VS 工程，编译成功后按任意键继续
  pause
)

:: 安装文件
set "InstallPCPath=%dbyoungSDKPath:\=/%"
if not exist "%dbyoungSDKPath%\include\vorbis" (
md "%dbyoungSDKPath%\include\vorbis"
)
copy /Y "%libvorbisSRC%\Win32\%Lang%\%BuildPlatform_%\Release\libvorbis_static.lib"     "%dbyoungSDKPath%\lib\libvorbis_static.lib"
copy /Y "%libvorbisSRC%\Win32\%Lang%\%BuildPlatform_%\Release\libvorbis_static.lib"     "%dbyoungSDKPath%\lib\libvorbis.lib"
copy /Y "%libvorbisSRC%\Win32\%Lang%\%BuildPlatform_%\Release\libvorbisfile_static.lib" "%dbyoungSDKPath%\lib\libvorbisfile_static.lib"
copy /Y "%libvorbisSRC%\Win32\%Lang%\%BuildPlatform_%\Release\libvorbisfile_static.lib" "%dbyoungSDKPath%\lib\libvorbisfile.lib"
copy /Y "%libvorbisSRC%\Win32\%Lang%\%BuildPlatform_%\Release\vorbisdec_static.exe"     "%dbyoungSDKPath%\bin\vorbisdec.exe"
copy /Y "%libvorbisSRC%\Win32\%Lang%\%BuildPlatform_%\Release\vorbisenc_static.exe"     "%dbyoungSDKPath%\bin\vorbisenc.exe"
copy /Y "%libvorbisSRC%\include\vorbis\codec.h"          "%dbyoungSDKPath%\include\vorbis\codec.h"
copy /Y "%libvorbisSRC%\include\vorbis\vorbisenc.h"      "%dbyoungSDKPath%\include\vorbis\vorbisenc.h"
copy /Y "%libvorbisSRC%\include\vorbis\vorbisfile.h"     "%dbyoungSDKPath%\include\vorbis\vorbisfile.h"

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc
@echo Name: vorbis>>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc
@echo Description: vorbis is the primary Ogg Vorbis library>>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc
@echo Version: 1.3.6>>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc
@echo Requires.private: ogg>>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc
@echo Libs: -L${libdir} -lvorbis -logg >>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc
@echo Libs.private: -lvorbis -logg>>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc
@echo Cflags:-I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\vorbis.pc

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Name: vorbisenc>>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Description: vorbisenc is a library that provides a convenient API for setting up an encoding environment using libvorbis>>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Version: 1.3.6>>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Requires.private: ogg vorbis>>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Libs: -L${libdir} -lvorbis -logg >>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Libs.private: -lvorbis -logg>>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc
@echo Cflags:-I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\vorbisenc.pc

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Name: vorbisfile>>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Description: vorbisfile is a library that provides a convenient high-level API for decoding and basic manipulation of all Vorbis I audio streams>>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Version: 1.3.6>>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Requires.private: ogg vorbis>>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Libs: -L${libdir} -lvorbisfile -lvorbis -logg >>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Libs.private: -lvorbisfile -lvorbis -logg>>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc
@echo Cflags:-I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\vorbisfile.pc

:: 删除临时文件 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"
