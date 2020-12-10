@echo off

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceProjName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7

del /Q "%InstallSDKPath%\lib\brotlicommon.lib"
del /Q "%InstallSDKPath%\lib\brotlidec.lib"
del /Q "%InstallSDKPath%\lib\brotlienc.lib"

copy /Y "%InstallSDKPath%\lib\brotlicommon-static.lib" "%InstallSDKPath%\lib\brotlicommon.lib"
copy /Y "%InstallSDKPath%\lib\brotlicommon-static.lib" "%InstallSDKPath%\lib\libbrotlicommon.lib"
copy /Y "%InstallSDKPath%\lib\brotlidec-static.lib" "%InstallSDKPath%\lib\brotlidec.lib"
copy /Y "%InstallSDKPath%\lib\brotlidec-static.lib" "%InstallSDKPath%\lib\libbrotlidec.lib"
copy /Y "%InstallSDKPath%\lib\brotlienc-static.lib" "%InstallSDKPath%\lib\brotlienc.lib"
copy /Y "%InstallSDKPath%\lib\brotlienc-static.lib" "%InstallSDKPath%\lib\libbrotlienc.lib"
