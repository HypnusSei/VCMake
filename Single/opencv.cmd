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
set "MKL_ROOT_DIR=H:\Green\Language\Intel\PSXE2020\compilers_and_libraries_2020.4.311\windows\mkl"
set "mfxlibInc=%InstallSDKPath%\include\mfx"
set "mfxlibLib=%InstallSDKPath%\lib"

cls
title ��ʼ���� OpenCV ��̬�� 
CD /D %InstallSDKPath%\lib
if exist tbb.lib (
  rename tbb.lib tbb.lib.bak
)

:: �Ƿ�ʹ�� GPU 
set "USEGPU="
set "USECPU=CPU"
rem if %BuildHostX8664%==x86 (
rem   set "USEGPU=-DCPU_ONLY=ON -DWITH_CUDA=OFF -DVTK_USE_CUDA=OFF"
rem   set "USECPU=CPU"
rem   ) else (
rem   set "USEGPU=-DCPU_ONLY=OFF -DWITH_CUDA=ON -DVTK_USE_CUDA=ON -DOPENCV_EXTRA_MODULES_PATH=%VCMakeRootPath%Source\opencv_contrib"
rem   set "USECPU=GPU"
rem   if not exist "%VCMakeRootPath%Source\opencv_contrib" (
rem     git clone --progress --recursive -v "https://github.com/opencv/opencv_contrib.git" "%VCMakeRootPath%Source\opencv_contrib"
rem     git clone --progress --recursive -v "https://github.com/opencv/opencv_extra.git"   "%VCMakeRootPath%Source\opencv_extra"
rem     )
rem )

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ���뾲̬��
set LibraryStaticType=static

:: ����Ŀ¼
set "BuildOpenCVStaticPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%\%LibraryStaticType%"
if exist %BuildOpenCVStaticPath% (
  echo ɾ��������ʱĿ¼ %BuildOpenCVStaticPath%
  RD /S /Q "%BuildOpenCVStaticPath%"
)

:: ��ԭ����
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %VCMakeRootPath%Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: Դ����Ŀ¼
CD /D %VCMakeRootPath%Source\%SourceCodeName%"

:: ���� OpenCV ��̬��
echo ��ʼ���� OpenCV ��̬�� 
cmake %Bpara% %USEGPU% -DCMAKE_SUPPRESS_REGENERATION=OFF -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath%\%SourceCodeName%\%USECPU%\%LibraryStaticType% -Thost=%BuildHostX8664% -B %BuildOpenCVStaticPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%
cmake %BuildOpenCVStaticPath%

:: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo ���������У����Ժ�......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %BuildOpenCVStaticPath% %dbyoungSDKPath% %InstallSDKPath%
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
set LibraryShareType=share

:: ����Ŀ¼
set "BuildOpenCVSharePath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%\%LibraryShareType%"
if exist %BuildOpenCVSharePath% (
  echo ɾ��������ʱĿ¼ %BuildOpenCVSharePath%
  RD /S /Q "%BuildOpenCVSharePath%"
)

:: ��ԭ����
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: ������ static ��̬��Ŀ¼
CD /D "%dbyoungSDKPath%\opencv\%USECPU%"
if exist static (
  rename static static_bak
)

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %VCMakeRootPath%Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: Դ����Ŀ¼
CD /D %VCMakeRootPath%Source\%SourceCodeName%"

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
echo ���� OpenCV ��̬�� 
title ���� OpenCV ��̬�� 

cmake %TTT% %USEGPU% -DBUILD_opencv_world=ON -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath%\%SourceCodeName%\%USECPU%\%LibraryShareType% -Thost=%BuildHostX8664% -B %BuildOpenCVSharePath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%
cmake %BuildOpenCVSharePath%

:: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo ���������У����Ժ�......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %BuildOpenCVSharePath% %dbyoungSDKPath% %InstallSDKPath%
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
set LibraryWorldType=world

:: ����Ŀ¼
set "BuildOpenCVWorldPath=%VCMakeRootPath%VSBuild\%SourceCodeName%\%BuildHostX8664%\%LibraryWorldType%"
if exist %BuildOpenCVWorldPath% (
  echo ɾ��������ʱĿ¼ %BuildOpenCVWorldPath%
  RD /S /Q "%BuildOpenCVWorldPath%"
)

:: ��ԭ����
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: ������ static ��̬��Ŀ¼
CD /D "%dbyoungSDKPath%\opencv\%USECPU%"
if exist static (
  rename static static_bak
)

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %VCMakeRootPath%Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: Դ����Ŀ¼
CD /D %VCMakeRootPath%Source\%SourceCodeName%"

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
echo ���� OpenCV ��̬�� 
title ���� OpenCV ��̬�� 

cmake %TTT% %USEGPU% -DBUILD_opencv_world=ON -DSWIG_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\swig\4.0.2\swig.exe -DANT_EXECUTABLE=%VCMakeRootPath%Tools\x64\scoop\apps\ant\1.10.9\bin\ant.bat -DMFX_INCLUDE_DIRS=%mfxlibInc% -DMFX_LIBRARIES=%mfxlibLib%\libmfx_vs2015.lib -DCMAKE_INSTALL_PREFIX=%InstallSDKPath%\%SourceCodeName%\%USECPU%\%LibraryWorldType% -Thost=%BuildHostX8664% -B %BuildOpenCVWorldPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%
cmake %BuildOpenCVWorldPath%

:: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo ���������У����Ժ�......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %BuildOpenCVWorldPath% %dbyoungSDKPath% %InstallSDKPath%
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
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:: �������֮�󣬻ָ���̬��Ŀ¼
:bEnd
CD /D "%dbyoungSDKPath%\opencv\%USECPU%"
rename static_bak static

CD /D %InstallSDKPath%\lib
if exist tbb.lib.bak (
  rename tbb.lib.bak tbb.lib
)
