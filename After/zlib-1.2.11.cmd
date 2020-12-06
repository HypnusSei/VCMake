@echo off

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceProjName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7

del  /Q "%InstallSDKPath%\lib\zlib.lib"
copy /Y "%InstallSDKPath%\lib\zlibstatic.lib" "%InstallSDKPath%\lib\zlib.lib"
copy /Y "%InstallSDKPath%\lib\zlibstatic.lib" "%InstallSDKPath%\lib\z.lib"
del  /Q "%InstallSDKPath%\bin\zlib.dll"

:: 安装 PC 文件
set "InstallPCPath=%InstallSDKPath:\=/%"

if not exist %InstallSDKPath%\lib\pkgconfig (
  cd /d %InstallSDKPath%\lib
  md pkgconfig
)

@echo prefix=%InstallPCPath%>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo exec_prefix=%InstallPCPath%>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo libdir=%InstallPCPath%/lib>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo sharedlibdir=%InstallPCPath%/lib>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo includedir=%InstallPCPath%/include>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Name: zlib>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Description: zlib compression library>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Version: 1.2.11>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Requires:>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Libs: -L${libdir} -L${sharedlibdir} -lzlib>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Cflags: -I${includedir}>>%InstallSDKPath%\lib\pkgconfig\zlib.pc

