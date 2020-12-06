@echo off

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceProjName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7

copy /Y "%InstallSDKPath%\lib\intl-static.lib" "%InstallSDKPath%\lib\intl.lib"
copy /Y "%InstallSDKPath%\lib\intl-static.lib" "%InstallSDKPath%\lib\libintl.lib"
copy /Y "%InstallSDKPath%\include\libgnuintl.h" "%InstallSDKPath%\include\intl.h"
copy /Y "%InstallSDKPath%\include\libgnuintl.h" "%InstallSDKPath%\include\libintl.h"
