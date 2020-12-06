@echo off

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceProjName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7

set "BuildCEGUIDEPPath=%VCMakeRootPath%VSBuild\%SourceProjName%\%BuildHostX8664%"

xcopy /Y /E "%BuildCEGUIDEPPath%\dependencies\include\*.*" "%InstallSDKPath%\include\"
xcopy /Y /E "%BuildCEGUIDEPPath%\dependencies\lib\static\*.*" "%InstallSDKPath%\lib\"
copy /Y "%VCMakeRootPath%After\cegui-dep.h" "%InstallSDKPath%\include\freetype\ftstroke.h"
