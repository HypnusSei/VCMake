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

:: ���� CMake �������
set "sFile=%VCMakeRootPath%Script\vcp.txt"
set "sPara="
for /f "tokens=*" %%I in (%sFile%) do (set "sPara=!sPara! %%I")
set "Bpara=%sPara% %Bpara%"

:: ����Ƿ��� patch �����ļ�
 if exist "%VCMakeRootPath%Patch\%SourceCodeName%.patch" (
   copy /Y "%VCMakeRootPath%Patch\%SourceCodeName%.patch" "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
   CD /D %VCMakeRootPath%Source\%SourceCodeName%
   git apply "%SourceCodeName%.patch"
   del "%VCMakeRootPath%Source\%SourceCodeName%\%SourceCodeName%.patch"
 )

:: ���� Caffe
cmake  %Bpara% ^
 -DHDF5_DIR=%dbyoungSDKPath%\cmake\hdf5 ^
 -DLMDB_LIBRARIES=%dbyoungSDKPath%\lib\lmdb.lib ^
 -DBLAS=mkl ^
 -DMKL_WITH_OPENMP=ON ^
 -DCPU_ONLY=ON ^
 -DUSE_OPENCV=OFF ^
 -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B "%BuildCaffePath%" -G %BuildLanguageX% -A %BuildPlatformX% %VCMakeRootPath%Source\%SourceCodeName%
cmake %BuildCaffePath%

:: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
if exist "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" (
  echo ���������У����Ժ�......
  call "%VCMakeRootPath%Patch\%SourceCodeName%_sln.cmd" %VCBuildTmpPath% %dbyoungSDKPath%
)

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildCaffePath%\Caffe.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildCaffePath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildCaffePath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)
  
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildCaffePath%" --config Release --target install
	
:: ��� CMake �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: Դ���뻹ԭ
CD /D "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:bEnd
