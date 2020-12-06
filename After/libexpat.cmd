@echo off

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceProjName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7

:: 安装 PC 文件
set "InstallPCPath=%InstallSDKPath:\=/%"

if not exist %InstallSDKPath%\lib\pkgconfig (
  cd /d %InstallSDKPath%\lib
  md pkgconfig
)

@echo libdir=%InstallPCPath%/lib>%InstallSDKPath%\lib\pkgconfig\expat.pc
@echo includedir=%InstallPCPath%/include>>%InstallSDKPath%\lib\pkgconfig\expat.pc
@echo Name: expat>>%InstallSDKPath%\lib\pkgconfig\expat.pc
@echo Version: 2.2.10>>%InstallSDKPath%\lib\pkgconfig\expat.pc
@echo Description: expat XML parser>>%InstallSDKPath%\lib\pkgconfig\expat.pc
@echo URL: http://www.libexpat.org>>%InstallSDKPath%\lib\pkgconfig\expat.pc
@echo Libs: -L${libdir} -lexpat>>%InstallSDKPath%\lib\pkgconfig\expat.pc
@echo Cflags: -I${includedir}>>%InstallSDKPath%\lib\pkgconfig\expat.pc
