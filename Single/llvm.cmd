@echo off
SETLOCAL EnableDelayedExpansion

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceCodeName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7
set VCProjectNameX=%8
set BuildLLVMPathX=%VCMakeRootPath%VSBuild\llvm\%BuildHostX8664%
set BuildCLANGPath=%VCMakeRootPath%VSBuild\clang\%BuildHostX8664%

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

:: ���� llvm
echo ��ʼ CMake ����
cmake %Bpara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildLLVMPathX% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\llvm
cmake %BuildLLVMPathX%

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildLLVMPathX%\llvm.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildLLVMPathX%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildLLVMPathX%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  :: �ٱ���һ��
  MSBuild.exe %BuildLLVMPathX%\llvm.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
   /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
   /flp1:LogFile=%BuildLLVMPathX%\zerror.log;errorsonly;Verbosity=diagnostic^
   /flp2:LogFile=%BuildLLVMPathX%\zwarns.log;warningsonly;Verbosity=diagnostic

  if %ERRORLEVEL% NEQ 0 (
    echo ������ֶ�ջ����������� VS �򿪣����밲װ���ɹ������������
    pause
  )
)
  
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildLLVMPathX%" --config Release --target install
	
:: ��� CMake �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ֶ�ջ����������� VS �򿪣����밲װ���ɹ������������
  pause
)

echo ---------------------------------------------------------------------------------------------------------
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe
tskill msbuild.exe

:: ɾ��������ʱĿ¼
if exist %BuildCLANGPath% (
  echo ɾ��������ʱĿ¼ %BuildCLANGPath%
  RD /S /Q "%BuildCLANGPath%"
)

:: ���� clang
echo ���� llvm - clang
title ���� llvm - clang
cmake %Bpara% -DCMAKE_INSTALL_PREFIX=%InstallSDKPath% -Thost=%BuildHostX8664% -B %BuildCLANGPath% -G %BuildLanguageX% -A %BuildPlatform_% %VCMakeRootPath%\Source\%SourceCodeName%\clang
cmake %BuildCLANGPath%

echo ��������б���ʧ�ܣ��� CMAKE-GUI �򿪣�����ɹ����ٰ����������
pause

:: VC ����֮ǰ������Ƿ��й����ļ���Ҫ�޸ĵĲ���������������ļ��򲹶� (xz ���������⣬���ܱ��� MT ����)
if exist "%VCMakeRootPath%Patch\clang_sln.cmd" (
  echo ���������У����Ժ�......
  call "%VCMakeRootPath%Patch\clang_sln.cmd" %BuildCLANGPath% %dbyoungSDKPath% %InstallSDKPath%
)

:: VC ����̱��룻�ӿ�����ٶȣ�����������Ʋ���ȷ����Ӱ����룬ֻ�ǲ���ʹ�� VC �Ķ���̱��롣����̱������ܶ���̱��룬����󹤳�ʱ��������������Ӧ�ٶ�
MSBuild.exe %BuildCLANGPath%\clang.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
 /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
 /flp1:LogFile=%BuildCLANGPath%\zerror.log;errorsonly;Verbosity=diagnostic^
 /flp2:LogFile=%BuildCLANGPath%\zwarns.log;warningsonly;Verbosity=diagnostic

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  :: �ٱ���һ��
  MSBuild.exe %BuildCLANGPath%\clang.sln /nologo /consoleloggerparameters:Verbosity=minimal /maxcpucount /nodeReuse:true^
   /target:Build /property:Configuration=Release;Platform=%BuildPlatform_%^
   /flp1:LogFile=%BuildCLANGPath%\zerror.log;errorsonly;Verbosity=diagnostic^
   /flp2:LogFile=%BuildCLANGPath%\zwarns.log;warningsonly;Verbosity=diagnostic

  if %ERRORLEVEL% NEQ 0 (
    echo ������ֶ�ջ����������� VS �򿪣����밲װ���ɹ������������
    pause
  )
)
  
:: ������� VC ����̱���û���κ����⣬����Ͳ����ٱ����ˣ�ֱ�Ӱ�װ��
CMake --build "%BuildCLANGPath%" --config Release --target install
	
:: ��� CMake �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ֶ�ջ����������� VS �򿪣����밲װ���ɹ������������
  pause
)

:: Դ���뻹ԭ
cd /d "%VCMakeRootPath%Source\%SourceCodeName%"
git clean -d  -fx -f
git checkout .

:bEnd
