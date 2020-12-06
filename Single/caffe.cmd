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
set BuildCaffePath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%

:: 设置 CMake 编译参数
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %VCMakeRootPath%Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: 编译 Caffe
cmake  %Bpara% ^
 -DHDF5_DIR=%dbyoungSDKPath%\cmake\hdf5 ^
 -DLMDB_LIBRARIES=%dbyoungSDKPath%\lib\lmdb.lib ^
 -DBLAS=mkl ^
 -DMKL_WITH_OPENMP=ON ^
 -DCPU_ONLY=ON ^
 -DUSE_OPENCV=OFF ^
 -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B "%BuildCaffePath%" -G %BuildLanguageX% -A %BuildPlatformX% %VCMakeRootPath%Source\%SourceCodeName%
cmake %BuildCaffePath%

:: VC 编译之前，检查是否有工程文件需要修改的补丁，有则给工程文件打补丁 (xz 工程有问题，不能编译 MT 类型)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo 修正工程中，请稍候......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %VCBuildTmpPath% %dbyoungSDKPath%
)

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %BuildCaffePath%\Caffe.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildCaffePath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildCaffePath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)
  
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildCaffePath%" --config Release --target install
	
:: 检查 CMake 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 源代码还原
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:bEnd
