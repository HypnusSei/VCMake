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
set "libtheoraSRC=%~d0\Source\%SourceCodeName%"

:: MSBuild 头文件、库文件搜索路径
set "INCLUDE=%dbyoungSDKPath%\include;%dbyoungSDKPath%\include\pixman-1;%dbyoungSDKPath%\include\freetype2;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%LIB%"
set "UseEnv=True"

:: 解压
7z x %VCMakeRootPath%Single\%SourceCodeName%.7z -o"%libtheoraSRC%\Win32" -y

if %BuildLanguageX% == "Visual Studio 15 2017" (
  set Lang=vs2017
  ) else (
  set Lang=vs2019
)

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %libtheoraSRC%\Win32\%Lang%\libtheora_static.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release_SSE2;Platform=%BuildPlatform_%^
 /flp1:LogFile=%libtheoraSRC%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%libtheoraSRC%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译。可打开 VS 工程，编译成功后按任意键继续
  pause
)
  
:: 安装文件
set "InstallPCPath=%dbyoungSDKPath:\=/%"
if not exist "%dbyoungSDKPath%\include\theora" (
  md "%dbyoungSDKPath%\include\theora"
)
copy /Y "%libtheoraSRC%\Win32\%Lang%\%BuildPlatform_%\Release_SSE2\libtheora_static.lib"     "%dbyoungSDKPath%\lib\libtheora_static.lib"
copy /Y "%libtheoraSRC%\Win32\%Lang%\%BuildPlatform_%\Release_SSE2\libtheora_static.lib"     "%dbyoungSDKPath%\lib\libtheora.lib"
copy /Y "%libtheoraSRC%\Win32\%Lang%\%BuildPlatform_%\Release_SSE2\libtheora_static.lib"     "%dbyoungSDKPath%\lib\libtheoradec.lib"
copy /Y "%libtheoraSRC%\Win32\%Lang%\%BuildPlatform_%\Release_SSE2\libtheora_static.lib"     "%dbyoungSDKPath%\lib\libtheoraenc.lib"
copy /Y "%libtheoraSRC%\include\theora\codec.h"          "%dbyoungSDKPath%\include\theora\codec.h"
copy /Y "%libtheoraSRC%\include\theora\theora.h"         "%dbyoungSDKPath%\include\theora\theora.h"
copy /Y "%libtheoraSRC%\include\theora\theoraenc.h"      "%dbyoungSDKPath%\include\theora\theoraenc.h"
copy /Y "%libtheoraSRC%\include\theora\theoradec.h"     "%dbyoungSDKPath%\include\theora\theoradec.h"

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\theora.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\theora.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\theora.pc
@echo Name: theora>>%dbyoungSDKPath%\lib\pkgconfig\theora.pc
@echo Description: Theora video codec>>%dbyoungSDKPath%\lib\pkgconfig\theora.pc
@echo Version: 1.1.1>>%dbyoungSDKPath%\lib\pkgconfig\theora.pc
@echo Requires.private: ogg>>%dbyoungSDKPath%\lib\pkgconfig\theora.pc
@echo Libs: -L${libdir} -ltheora -logg >>%dbyoungSDKPath%\lib\pkgconfig\theora.pc
@echo Libs.private: -ltheora -logg>>%dbyoungSDKPath%\lib\pkgconfig\theora.pc
@echo Cflags:-I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\theora.pc

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Name: theoraenc>>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Description: Theora video codec (encoder)>>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Version: 1.1.1>>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Requires.private: ogg>>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Libs: -L${libdir} -ltheoraenc -logg >>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Libs.private: -ltheora -logg>>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc
@echo Cflags:-I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\theoraenc.pc

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc
@echo Name: theoradec>>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc
@echo Description: Theora video codec (decoder)>>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc
@echo Version: 1.1.1>>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc
@echo Requires.private: ogg>>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc
@echo Libs: -L${libdir} -ltheoradec -logg >>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc
@echo Libs.private: -ltheoradec -logg>>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc
@echo Cflags:-I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\theoradec.pc

:: 删除临时文件 
if exist "%VCMakeRootPath%%SourceCodeName%.tar.bz2" del "%VCMakeRootPath%%SourceCodeName%.tar.bz2"
if exist "%VCMakeRootPath%%SourceCodeName%.tar.gz"  del "%VCMakeRootPath%%SourceCodeName%.tar.gz"
if exist "%VCMakeRootPath%%SourceCodeName%.tar"     del "%VCMakeRootPath%%SourceCodeName%.tar"
if exist "%VCMakeRootPath%%SourceCodeName%.zip"     del "%VCMakeRootPath%%SourceCodeName%.zip"

:bEnd
