@echo off

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceCodeName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7
set "BuildFontconfigPath=%VCMakeRootPath%VSBuild\%SourceProjName%\%BuildHostX8664%"

set "InstallPCPath=%InstallSDKPath:\=/%"

echo 安装文件
copy /Y "%BuildFontconfigPath%\Release\*.exe" "%InstallSDKPath%\bin\"

copy /Y "%BuildFontconfigPath%\Release\fontconfig-static.lib" "%InstallSDKPath%\lib\fontconfig-static.lib"
copy /Y "%InstallSDKPath%\lib\fontconfig-static.lib" "%InstallSDKPath%\lib\fontconfig.lib"

cd /D "%InstallSDKPath%\include"
if not exist "%InstallSDKPath%\include\fontconfig" (
  md fontconfig
)

copy /Y "%VCMakeRootPath%\source\%SourceCodeName%\fontconfig\fcfreetype.h" "%InstallSDKPath%\include\fontconfig\fcfreetype.h"
copy /Y "%VCMakeRootPath%\source\%SourceCodeName%\fontconfig\fcprivate.h"  "%InstallSDKPath%\include\fontconfig\fcprivate.h"
copy /Y "%VCMakeRootPath%\source\%SourceCodeName%\fontconfig\fontconfig.h" "%InstallSDKPath%\include\fontconfig\fontconfig.h"

@echo libdir=%InstallPCPath%/lib>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo includedir=%InstallPCPath%/include>>%InstallSDKPath%\lib\pkgconfig\zlib.pc
@echo Name: Fontconfig>%InstallSDKPath%\lib\pkgconfig\fontconfig.pc
@echo Description: Font configuration and customization library>>%InstallSDKPath%\lib\pkgconfig\fontconfig.pc
@echo Version: 2.13.92>>%InstallSDKPath%\lib\pkgconfig\fontconfig.pc
@echo Requires:  freetype2 >= 21.0.15>>%InstallSDKPath%\lib\pkgconfig\fontconfig.pc
@echo Requires.private:  expat>>%InstallSDKPath%\lib\pkgconfig\fontconfig.pc
@echo Libs: -L${libdir} -lfontconfig>>%InstallSDKPath%\lib\pkgconfig\fontconfig.pc
@echo Libs.private: -L${libdir} -liconv>>%InstallSDKPath%\lib\pkgconfig\fontconfig.pc
@echo Cflags: -I${includedir} -I${includedir}>>%InstallSDKPath%\lib\pkgconfig\fontconfig.pc 
