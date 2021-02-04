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
set "MKL_ROOT_DIR=F:\Green\Language\Intel\PSXE2020\compilers_and_libraries_2020.4.311\windows\mkl"
set "mfxlibInc=%InstallSDKPath%\include\mfx"
set "mfxlibLib=%InstallSDKPath%\lib"

cls

:: TBB 和自带的 ITT 有冲突，屏蔽掉
CD /D %InstallSDKPath%\lib
if exist tbb.lib (
  if exist tbb.lib.bak (
    del tbb.lib.bak
  )
 rename tbb.lib tbb.lib.bak 
)

:: 是否使用 GPU 
set "USEGPU="
set "USECPU=CPU"
if %BuildHostX8664%==x86 (
  set "USEGPU=-DCPU_ONLY=ON -DWITH_CUDA=OFF -DVTK_USE_CUDA=OFF"
  set "USECPU=CPU"
  ) else (
  set "USEGPU=-DCPU_ONLY=OFF -DWITH_CUDA=ON -DVTK_USE_CUDA=ON -DOPENCV_EXTRA_MODULES_PATH=%~d0\Source\opencv_contrib"
  set "USECPU=GPU"
  if not exist "%~d0\Source\opencv_contrib" (
    git clone --progress --recursive -v "https://github.com/opencv/opencv_contrib.git" "%~d0\Source\opencv_contrib"
    git clone --progress --recursive -v "https://github.com/opencv/opencv_extra.git"   "%~d0\Source\opencv_extra"
    )
)

:: 设置 CMake 编译参数
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: 编译静态库
cls
echo 编译 OpenCV 静态库 
title 编译 OpenCV 静态库 
set LibraryStaticType=static

:: 编译目录
set "BuildOpenCVStaticPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%\%LibraryStaticType%"
if exist %BuildOpenCVStaticPath% (
  echo 删除编译临时目录 %BuildOpenCVStaticPath%
  RD /S /Q "%BuildOpenCVStaticPath%"
)

:: 还原代码
CD /D "%~d0\Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %~d0\Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: 源代码目录
CD /D %~d0\Source\%SourceCodeName%"

:: 编译 OpenCV 静态库
echo 开始编译 OpenCV 静态库 
cmake %Bpara% %USEGPU% -DCMAKE_SUPPRESS_REGENERATION=OFF -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath%\%SourceCodeName%\%USECPU%\%LibraryStaticType% -Thost=%BuildHostX8664% -B %BuildOpenCVStaticPath% -G %BuildLanguageX% -A %BuildPlatform_% %~d0\Source\%SourceCodeName%
cmake %BuildOpenCVStaticPath%

:: VC 编译之前，检查是否有工程文件需要修改的补丁，有则给工程文件打补丁 (xz 工程有问题，不能编译 MT 类型)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo 修正工程中，请稍候......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %BuildOpenCVStaticPath% %dbyoungSDKPath% %VCMakeRootPath%
)

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %BuildOpenCVStaticPath%\%VCProjectNameX% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildOpenCVStaticPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildOpenCVStaticPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)
  
:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildOpenCVStaticPath%" --config Release --target install
	
:: 检查 CMake 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 编译动态库
cls
echo 编译 OpenCV 动态库 
title 编译 OpenCV 动态库
set LibraryShareType=share

:: 编译目录
set "BuildOpenCVSharePath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%\%LibraryShareType%"
if exist %BuildOpenCVSharePath% (
  echo 删除编译临时目录 %BuildOpenCVSharePath%
  RD /S /Q "%BuildOpenCVSharePath%"
)

:: 还原代码
CD /D "%~d0\Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: 重命名 static 静态库目录
CD /D "%dbyoungSDKPath%\opencv\%USECPU%"
if exist static (
  rename static static_bak
)

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %~d0\Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: 源代码目录
CD /D %~d0\Source\%SourceCodeName%"

:: 字符串搜索替换，修改为编译动态库类型
set Temp01=-DBUILD_SHARED=OFF
set Temp02=-DBUILD_SHARED=ON
set Temp03=-DBUILD_SHARED_LIBS=OFF
set Temp04=-DBUILD_SHARED_LIBS=ON
set Temp05=-DBUILD_STATIC=ON
set Temp06=-DBUILD_STATIC=OFF
set Temp07=-DBUILD_TESTING=OFF
set Temp08=-DBUILD_TESTING=ON
set Temp09=-DBUILD_TESTS=OFF
set Temp10=-DBUILD_TESTS=ON
set Temp11=-DBUILD_EXAMPLES=OFF
set Temp12=-DBUILD_EXAMPLES=ON

set TTT=''
for /f "tokens=*" %%f in ('powershell -command "'%Bpara%' -replace '%Temp01%', '%Temp02%' -replace '%Temp03%', '%Temp04%' -replace '%Temp05%', '%Temp06%' -replace '%Temp07%', '%Temp08%' -replace '%Temp09%', '%Temp10%' -replace '%Temp11%', '%Temp12%' "') do (
  set TTT=%%f
)

:: 编译 OpenCV 动态库
cmake %TTT% %USEGPU% -DBUILD_opencv_world=OFF -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath%\%SourceCodeName%\%USECPU%\%LibraryShareType% -Thost=%BuildHostX8664% -B %BuildOpenCVSharePath% -G %BuildLanguageX% -A %BuildPlatform_% %~d0\Source\%SourceCodeName%
cmake %BuildOpenCVSharePath%

:: VC 编译之前，检查是否有工程文件需要修改的补丁，有则给工程文件打补丁 (xz 工程有问题，不能编译 MT 类型)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo 修正工程中，请稍候......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %BuildOpenCVSharePath% %dbyoungSDKPath% %VCMakeRootPath%
)

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %BuildOpenCVSharePath%\%VCProjectNameX% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildOpenCVSharePath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildOpenCVSharePath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildOpenCVSharePath%" --config Release --target install
	
:: 检查 CMake 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 编译 world 动态库
cls
echo 编译 OpenCV world 动态库 
title 编译 OpenCV world 动态库
set LibraryWorldType=world

:: 编译目录
set "BuildOpenCVWorldPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%\%LibraryWorldType%"
if exist %BuildOpenCVWorldPath% (
  echo 删除编译临时目录 %BuildOpenCVWorldPath%
  RD /S /Q "%BuildOpenCVWorldPath%"
)

:: 还原代码
CD /D "%~d0\Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: 检查是否有 patch 补丁文件
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %~d0\Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: 源代码目录
CD /D %~d0\Source\%SourceCodeName%"

:: 字符串搜索替换，修改为编译动态库类型
set Temp01=-DBUILD_SHARED=OFF
set Temp02=-DBUILD_SHARED=ON
set Temp03=-DBUILD_SHARED_LIBS=OFF
set Temp04=-DBUILD_SHARED_LIBS=ON
set Temp05=-DBUILD_STATIC=ON
set Temp06=-DBUILD_STATIC=OFF
set Temp07=-DBUILD_TESTING=OFF
set Temp08=-DBUILD_TESTING=ON
set Temp09=-DBUILD_TESTS=OFF
set Temp10=-DBUILD_TESTS=ON
set Temp11=-DBUILD_EXAMPLES=OFF
set Temp12=-DBUILD_EXAMPLES=ON

set TTT=''
for /f "tokens=*" %%f in ('powershell -command "'%Bpara%' -replace '%Temp01%', '%Temp02%' -replace '%Temp03%', '%Temp04%' -replace '%Temp05%', '%Temp06%' -replace '%Temp07%', '%Temp08%' -replace '%Temp09%', '%Temp10%' -replace '%Temp11%', '%Temp12%' "') do (
  set TTT=%%f
)

:: 编译 OpenCV world 动态库
cmake %TTT% %USEGPU% -DBUILD_opencv_world=ON -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath%\%SourceCodeName%\%USECPU%\%LibraryWorldType% -Thost=%BuildHostX8664% -B %BuildOpenCVWorldPath% -G %BuildLanguageX% -A %BuildPlatform_% %~d0\Source\%SourceCodeName%
cmake %BuildOpenCVWorldPath%

:: VC 编译之前，检查是否有工程文件需要修改的补丁，有则给工程文件打补丁 (xz 工程有问题，不能编译 MT 类型)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo 修正工程中，请稍候......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %BuildOpenCVWorldPath% %dbyoungSDKPath% %VCMakeRootPath%
)

:: VC 多进程编译；加快编译速度；如果工程名称不正确，不影响编译，只是不能使用 VC 的多进程编译。多进程编译会起很多进程编译，编译大工程时，会拖慢机器相应速度
MSBuild.exe %BuildOpenCVWorldPath%\%VCProjectNameX% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildOpenCVWorldPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildOpenCVWorldPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: 检查 VC 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 如果上面 VC 多进程编译没有任何问题，这里就不会再编译了，直接安装了
CMake --build "%BuildOpenCVWorldPath%" --config Release --target install
	
:: 检查 CMake 编译是否有错误
if %ERRORLEVEL% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
  goto bEnd
)

:: 还原代码
CD /D "%~d0\Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: 编译完成之后，恢复静态库目录
:bEnd
CD /D "%dbyoungSDKPath%\opencv\%USECPU%"
rename static_bak static

:: 编译完成之后，恢复 TBB 
CD /D %InstallSDKPath%\lib
if exist tbb.lib.bak (
  if exist tbb.lib (
    del tbb.lib
  )
 rename tbb.lib.bak tbb.lib
)
