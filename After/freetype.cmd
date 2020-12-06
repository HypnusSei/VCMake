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

@echo libdir=%InstallPCPath%/lib>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo includedir=%InstallPCPath%/include>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo Name: FreeType 2>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo URL: https://freetype.org>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo Description: A free, high-quality, and portable font engine.>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo Version: 23.4.17>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo Requires:>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo Requires.private: zlib, bzip2, libpng, harfbuzz >= 1.8.0, libbrotlidec>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo Libs: -L${libdir} -lfreetype -lzlib -llzma -lbzip2 -llibpng -lharfbuzz -llibbrotlidec>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo Libs.private:  -lfreetype -lzlib -llzma -lbzip2 -llibpng -lharfbuzz -llibbrotlidec>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
@echo Cflags: -I${includedir}/freetype2>>%InstallSDKPath%\lib\pkgconfig\freetype2.pc
