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
set SourceFullPath=%~d0\Source\%SourceCodePath%

cd %SourceFullPath%

set "SourceCodePathLine=%SourceCodePath:\=/%"

:: 下载子模块
bash --login -i -c "./CloneRepositories.sh https://github.com/ImageMagick full"

:: 检查是否有 patch 补丁文件
 if exist "%BakupCurrentCD%\Patch\%SourceProjName%.patch" (
   copy /Y "%BakupCurrentCD%\Patch\%SourceProjName%.patch" "%BakupCurrentCD%\Source\%SourceProjName%\%SourceProjName%.patch"
   cd  "%BakupCurrentCD%\Source\%SourceProjName%"
   git apply "%SourceProjName%.patch"
   del "%BakupCurrentCD%\Source\%SourceProjName%\%SourceProjName%.patch"
 )

MSBuild.exe ".\VisualMagick\configure\configure.sln"^
 /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=zxerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=zxwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

cd "VisualMagick\configure"
call configure.exe

MSBuild.exe %SourceFullPath%\VisualMagick\VisualStaticMT.sln^
 /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=zxerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=zxwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)
