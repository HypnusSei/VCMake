@echo off
setlocal EnableDelayedExpansion

set VCMakeRootPath=%1
set BuildLanguageX=%2
set BuildPlatform1=%3
set BuildPlatform2=%4
set dbyoungSDKPath=%5
set InstallSDKPath=%6
set IfUseLangNinja=%7

:: ���û�������
set "IntelMFX_INC=%dbyoungSDKPath%\include"
set "IntelMFX_LIB=%dbyoungSDKPath%\lib"
set "PYTHON2_EXECUTABLE=%VCMakeRootPath%Tools\Python\2.7.16\%BuildPlatform2%\python.exe"
set "TBB_ENV_INCLUDE=%dbyoungSDKPath%\include\TBB"
set "TBB_ENV_LIB=%dbyoungSDKPath%\lib\TBB.lib"
set "LLVM_INSTALL_DIR=%dbyoungSDKPath%"
set "LLVM_DIR=%dbyoungSDKPath%\lib\cmake\llvm"
set "Clang_DIR=%dbyoungSDKPath%\lib\cmake\clang"
set "SCOOP=%VCMakeRootPath%Tools\x64\scoop\apps"
set "Python3Path=%VCMakeRootPath%Tools\python\3.8.2\%BuildPlatform2%"

:: ���� pkgconfig Ŀ¼ 
set "TMP_CONFIG_PATH=%dbyoungSDKPath%\lib\pkgconfig;%dbyoungSDKPath%\QT5\static\lib\cmake"
set "PKG_CONFIG_PATH=%TMP_CONFIG_PATH:\=/%"

:: ����������
call %VCMakeRootPath%Script\vck.cmd %VCMakeRootPath% %dbyoungSDKPath%

:: ����ϵͳ����·�������ߡ��������ⶼ��������·���У�Ҳ���Է���ϵͳ����·���У�����÷����ļ��У���Ϊ WINDOWS ϵͳ��ϵͳ����·�����ַ����������ƣ�
set "sFile=%VCMakeRootPath%Script\p%BuildPlatform2%.txt"
set "sPath="
for /f "tokens=*" %%I in (%sFile%) do (set "sPath=!sPath!;%%I")
set "Path=%VCMakeRootPath%\Tools\Perl\perl\bin;%SCOOP%\7zip\current;%SCOOP%\git\current\bin;%SCOOP%\sliksvn\current\bin;%SCOOP%\curl\current\bin;%VCMakeRootPath%Tools;%Python3Path%;%Python3Path%\libs;%Python3Path%\Scripts;%dbyoungSDKPath%\bin;%dbyoungSDKPath%\QT5\static\lib;%dbyoungSDKPath%\QT5\static\lib\cmake;%dbyoungSDKPath%\QT5\static\lib\cmake\Qt5Widgets;%sPath%;%Path%"

if %IfUseLangNinja%==0 (
  :: �������� VS2017 / VS2019
  if %BuildLanguageX% == VS2017 (
    set CMakeLang="Visual Studio 15 2017"
    set "VSWHERE="%SCOOP%\vswhere\current\vswhere.exe" -property installationPath -requires Microsoft.Component.MSBuild Microsoft.VisualStudio.Component.VC.ATLMFC Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -version [15.0,16.0^)"
    for /f "delims=" %%A IN ('!VSWHERE!') DO call "%%A\Common7\Tools\vsdevcmd.bat" -no_logo -arch=%BuildPlatform2%
  ) else (
    set CMakeLang="Visual Studio 16 2019"
    set "VSWHERE="%SCOOP%\vswhere\current\vswhere.exe" -property installationPath -requires Microsoft.Component.MSBuild Microsoft.VisualStudio.Component.VC.ATLMFC Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -version [16.0,17.0^)"
    for /f "delims=" %%A IN ('!VSWHERE!') DO call "%%A\Common7\Tools\vsdevcmd.bat" -no_logo -arch=%BuildPlatform2%
  ) 
) else (
  set "Path=%SCOOP%\cmake\current\bin;%VCMakeRootPath%Tools;%Python3Path%;%Python3Path%\libs;%Python3Path%\Scripts;%Path%"
  set CMakeLang=Ninja
)

:: MSBuild ͷ�ļ������ļ�����·��
set "INCLUDE=%dbyoungSDKPath%\include\openblas;%dbyoungSDKPath%\include\libxml2;%dbyoungSDKPath%\include;%dbyoungSDKPath%\include\freetype2;%dbyoungSDKPath%\include\TBB;%dbyoungSDKPath%\include\harfbuzz;%dbyoungSDKPath%\QT5\static\include;%dbyoungSDKPath%\include\glib-2.0;%dbyoungSDKPath%\lib\glib-2.0\include;%IntelMFX_INC%;%INCLUDE%"
set "LIB=%dbyoungSDKPath%\lib;%dbyoungSDKPath%\QT5\static\lib;%IntelMFX_LIB%;%LIB%"
set "UseEnv=True"

:: ����Դ��
"%VCMakeRootPath%vca.cmd" %VCMakeRootPath% %CMakeLang% %BuildPlatform1% %BuildPlatform2% %dbyoungSDKPath% %InstallSDKPath%
