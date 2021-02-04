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

:: TBB ���Դ��� ITT �г�ͻ�����ε�
CD /D %InstallSDKPath%\lib
if exist tbb.lib (
  if exist tbb.lib.bak (
    del tbb.lib.bak
  )
 rename tbb.lib tbb.lib.bak 
)

:: �Ƿ�ʹ�� GPU 
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

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ���뾲̬��
cls
echo ���� OpenCV ��̬�� 
title ���� OpenCV ��̬�� 
set LibraryStaticType=static

:: ����Ŀ¼
set "BuildOpenCVStaticPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%\%LibraryStaticType%"
if exist %BuildOpenCVStaticPath% (
  echo ɾ��������ʱĿ¼ %BuildOpenCVStaticPath%
  RD /S /Q "%BuildOpenCVStaticPath%"
)

:: ��ԭ����
CD /D "%~d0\Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %~d0\Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: Դ����Ŀ¼
CD /D %~d0\Source\%SourceCodeName%"

:: ���� OpenCV ��̬��
echo ��ʼ���� OpenCV ��̬�� 
cmake %Bpara% %USEGPU% -DCMAKE_SUPPRESS_REGENERATION=OFF -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath%\%SourceCodeName%\%USECPU%\%LibraryStaticType% -Thost=%BuildHostX8664% -B %BuildOpenCVStaticPath% -G %BuildLanguageX% -A %BuildPlatform_% %~d0\Source\%SourceCodeName%
cmake %BuildOpenCVStaticPath%

:: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo ���������У����Ժ�......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %BuildOpenCVStaticPath% %dbyoungSDKPath% %VCMakeRootPath%
)

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildOpenCVStaticPath%\%VCProjectNameX% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildOpenCVStaticPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildOpenCVStaticPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)
  
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildOpenCVStaticPath%" --config Release --target install
	
:: ��� CMake �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ���붯̬��
cls
echo ���� OpenCV ��̬�� 
title ���� OpenCV ��̬��
set LibraryShareType=share

:: ����Ŀ¼
set "BuildOpenCVSharePath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%\%LibraryShareType%"
if exist %BuildOpenCVSharePath% (
  echo ɾ��������ʱĿ¼ %BuildOpenCVSharePath%
  RD /S /Q "%BuildOpenCVSharePath%"
)

:: ��ԭ����
CD /D "%~d0\Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: ������ static ��̬��Ŀ¼
CD /D "%dbyoungSDKPath%\opencv\%USECPU%"
if exist static (
  rename static static_bak
)

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %~d0\Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: Դ����Ŀ¼
CD /D %~d0\Source\%SourceCodeName%"

:: �ַ��������滻���޸�Ϊ���붯̬������
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

:: ���� OpenCV ��̬��
cmake %TTT% %USEGPU% -DBUILD_opencv_world=OFF -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath%\%SourceCodeName%\%USECPU%\%LibraryShareType% -Thost=%BuildHostX8664% -B %BuildOpenCVSharePath% -G %BuildLanguageX% -A %BuildPlatform_% %~d0\Source\%SourceCodeName%
cmake %BuildOpenCVSharePath%

:: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo ���������У����Ժ�......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %BuildOpenCVSharePath% %dbyoungSDKPath% %VCMakeRootPath%
)

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildOpenCVSharePath%\%VCProjectNameX% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildOpenCVSharePath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildOpenCVSharePath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildOpenCVSharePath%" --config Release --target install
	
:: ��� CMake �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ���� world ��̬��
cls
echo ���� OpenCV world ��̬�� 
title ���� OpenCV world ��̬��
set LibraryWorldType=world

:: ����Ŀ¼
set "BuildOpenCVWorldPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%\%LibraryWorldType%"
if exist %BuildOpenCVWorldPath% (
  echo ɾ��������ʱĿ¼ %BuildOpenCVWorldPath%
  RD /S /Q "%BuildOpenCVWorldPath%"
)

:: ��ԭ����
CD /D "%~d0\Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %~d0\Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%~d0\Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: Դ����Ŀ¼
CD /D %~d0\Source\%SourceCodeName%"

:: �ַ��������滻���޸�Ϊ���붯̬������
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

:: ���� OpenCV world ��̬��
cmake %TTT% %USEGPU% -DBUILD_opencv_world=ON -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath%\%SourceCodeName%\%USECPU%\%LibraryWorldType% -Thost=%BuildHostX8664% -B %BuildOpenCVWorldPath% -G %BuildLanguageX% -A %BuildPlatform_% %~d0\Source\%SourceCodeName%
cmake %BuildOpenCVWorldPath%

:: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo ���������У����Ժ�......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %BuildOpenCVWorldPath% %dbyoungSDKPath% %VCMakeRootPath%
)

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildOpenCVWorldPath%\%VCProjectNameX% /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildOpenCVWorldPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildOpenCVWorldPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildOpenCVWorldPath%" --config Release --target install
	
:: ��� CMake �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ��ԭ����
CD /D "%~d0\Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: �������֮�󣬻ָ���̬��Ŀ¼
:bEnd
CD /D "%dbyoungSDKPath%\opencv\%USECPU%"
rename static_bak static

:: �������֮�󣬻ָ� TBB 
CD /D %InstallSDKPath%\lib
if exist tbb.lib.bak (
  if exist tbb.lib (
    del tbb.lib
  )
 rename tbb.lib.bak tbb.lib
)
