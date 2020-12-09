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

:: 编译 X86/X64
set HostX64=0
set ProgmHostX8664=%ProgramFiles(x86)%
if %BuildHostX8664%==x64 (
  set HostX64=1
  set ProgmHostX8664=%ProgramFiles%
)

:: 源代码还原
CD /D %~d0\Source\%SourceCodeName%
git clean -d  -fx -f
git checkout .

:: 检查是否有 patch 补丁文件
echo 打 patch 补丁
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %~d0\Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

copy /Y "%InstallSDKPath%\lib\ossl_static.pdb" "%~d0\Source\%SourceCodeName%\gdal\ossl_static.pdb"

:: 编译参数设定
set bpmFile=%~d0\Source\%SourceCodeName%\gdal\%SourceCodeName%.opt
set JavaVer=1.8.0_211

@echo MSVC_VER=1910 >%bpmFile%
@echo CPU_COUNT=16 >>%bpmFile%
@echo WIN64=%HostX64% >>%bpmFile%
@echo DLLBUILD=0 >>%bpmFile%
@echo DEBUG=0 >>%bpmFile%
@echo ANALYZE=0 >>%bpmFile%
@echo WITH_PDB=0 >>%bpmFile%
@echo BINDINGS=java python>>%bpmFile%
@echo HAVE_NUMPY=1 >>%bpmFile%
@echo ANT_HOME=%VCMakeRootPath%Tools\apache-ant-1.9.7>>%bpmFile%
@echo CURL_CFLAGS=-DCURL_STATICLIB>>%bpmFile%
@echo CURL_INC=-I%dbyoungSDKPath%\include\curl>>%bpmFile%
@echo CURL_LIB=%dbyoungSDKPath%\lib\libcurl.lib %dbyoungSDKPath%\lib\libssl.lib %dbyoungSDKPath%\lib\libcrypto.lib %dbyoungSDKPath%\lib\nghttp2.lib %dbyoungSDKPath%\lib\cares.lib %dbyoungSDKPath%\lib\libssh2.lib %dbyoungSDKPath%\lib\brotlidec.lib %dbyoungSDKPath%\lib\brotlicommon.lib bcrypt.lib crypt32.lib Advapi32.lib wldap32.lib dwmapi.lib Shell32.lib>>%bpmFile%
@echo GDAL_HOME=%dbyoungSDKPath%>>%bpmFile%
@echo JAVA_HOME=%ProgmHostX8664%\Java\jdk%JavaVer%>>%bpmFile%
@echo PROJ_INCLUDE=-I%dbyoungSDKPath%\include\proj>>%bpmFile%
@echo PROJ_LIBRARY=%dbyoungSDKPath%\lib\proj.lib>>%bpmFile%
@echo PYDIR=%VCMakeRootPath%Tools\Python\2.7.16\%BuildHostX8664%>>%bpmFile%
@echo SQLITE_INC=-I%dbyoungSDKPath%\include>>%bpmFile%
@echo SQLITE_LIB=%dbyoungSDKPath%\lib\sqlite3.lib>>%bpmFile%
@echo SWIG=%VCMakeRootPath%Tools\swigwin\swig.exe>>%bpmFile%
@echo OPENJPEG_CFLAGS=-I%dbyoungSDKPath%\include\openjpeg-2.3>>%bpmFile%
@echo OPENJPEG_LIB=%dbyoungSDKPath%\lib\openjp2.lib>>%bpmFile%
@echo LZMA_CFLAGS=-I%dbyoungSDKPath%\include -DLZMA_API_STATIC>>%bpmFile%
@echo LZMA_LIBS=%dbyoungSDKPath%\lib\liblzma.lib>>%bpmFile%
@echo ZSTD_CFLAGS=-I%dbyoungSDKPath%\include>>%bpmFile%
@echo ZSTD_LIBS=%dbyoungSDKPath%\lib\zstd.lib>>%bpmFile%
@echo WEBP_ENABLED=YES>>%bpmFile%
@echo WEBP_CFLAGS=-I%dbyoungSDKPath%\include>>%bpmFile%
@echo WEBP_LIBS=%dbyoungSDKPath%\lib\webp.lib>>%bpmFile%
@echo LIBXML2_INC=-I%dbyoungSDKPath%\include\libxml2>>%bpmFile%
@echo LIBXML2_LIB=%dbyoungSDKPath%\lib\libxml2.lib ole32.lib>>%bpmFile%
@echo HDF5_PLUGIN=NO>>%bpmFile%
@echo HDF5_H5_IS_DLL=NO>>%bpmFile%
@echo HDF5_DIR=-I%dbyoungSDKPath%\include>>%bpmFile%
@echo HDF5_LIB=%dbyoungSDKPath%\lib\libhdf5.lib %dbyoungSDKPath%\lib\libhdf5_cpp.lib %dbyoungSDKPath%\lib\libhdf5_hl.lib>>%bpmFile%
@echo ICONV_CONST=>>%bpmFile%
@echo LIBICONV_INCLUDE=-I%dbyoungSDKPath%\include>>%bpmFile%
@echo LIBICONV_LIBRARY=%dbyoungSDKPath%\lib\libiconv.lib %dbyoungSDKPath%\lib\libcharset.lib>>%bpmFile%
@echo LIBICONV_CFLAGS=-DICONV_CONST=>>%bpmFile%

:: 开始编译
echo 开始编译 %SourceCodeName%
title 开始编译 %SourceCodeName%
CD /D %~d0\Source\%SourceCodeName%\gdal
nmake -f makefile.vc EXT_NMAKE_OPT=%SourceCodeName%.opt install
nmake -f makefile.vc EXT_NMAKE_OPT=%SourceCodeName%.opt devinstall

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 源代码还原
CD /D "%~d0\Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .
