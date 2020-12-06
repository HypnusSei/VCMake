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
set VCBuildTmpPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

if %BuildHostX8664% == x64 (
  set PlatformModel=64
) else (
  set PlatformModel=32
)

if %BuildLanguageX% == "Visual Studio 15 2017" (
  set LangToolset=msvc-14.1
) else (
  set LangToolset=msvc-14.2
)

:: ±‡“Î
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
if exist b2.exe (
  b2 install --build-dir=%VCBuildTmpPath% --prefix=%InstallSDKPath% --includedir=%dbyoungSDKPath%\include -sEXPAT_INCLUDE=%dbyoungSDKPath%\include -sEXPAT_LIBPATH=%dbyoungSDKPath%\lib --toolset=%LangToolset% address-model=%PlatformModel% link=static runtime-link=static  threading=multi variant=release
) else (
  call bootstrap.bat
  b2 install --build-dir=%VCBuildTmpPath% --prefix=%InstallSDKPath% --includedir=%dbyoungSDKPath%\include -sEXPAT_INCLUDE=%dbyoungSDKPath%\include -sEXPAT_LIBPATH=%dbyoungSDKPath%\lib --toolset=%LangToolset% address-model=%PlatformModel% link=static runtime-link=static  threading=multi variant=release
)

:: ºÏ≤È VC ±‡“Î «∑Ò”–¥ÌŒÛ
if %ERRORLEVEL% NEQ 0 (
  echo ±‡“Î≥ˆœ÷¥ÌŒÛ£¨Õ£÷π±‡“Î
  pause
  goto bEnd
)

:bEnd
