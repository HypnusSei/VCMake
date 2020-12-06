::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::: 1.0��Windows10�£����� OpenSSL ��Ҫ����ԱȨ�ޣ���Ϊ����Ҫ��ϵͳ��д�����ݣ�
:::: 2.0������ lapack��  ��Ҫ Intel Parallel Studio 2020 ������� (���� ifort Fortran ������), CMake ֻ��ʹ�� Ninja ģʽ(bUseNinja=1)������ʹ�� VS ģʽ��
:::: 3.1������ Openblas����Ҫ Fortran ������, miniconda3                 ���� flang Fortran ������, CMake ʹ�� Ninja + clang + flang ģʽ(bUseNinja=0)��
:::: 3.2������ Openblas����Ҫ Fortran ������, Intel Parallel Studio 2020 ���� flang Fortran ������, CMake ʹ�� Ninja + clang + ifort ģʽ(bUseNinja=0)��
:::: 4.0������ PDFium��  ��Ҫ VS2019 + Windows SDK 10.0.19041.0, ����ʹ�� clang ���룬����ʹ�� cl ���룻
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
setlocal EnableDelayedExpansion
Color A

set httpAddr=127.0.0.1
set httpPort=1080
set vsLangVC=2019
  
:: ��������������û�������������ע�͵������д��룻
set http_proxy=http://%httpAddr%:%httpPort%
set https_proxy=http://%httpAddr%:%httpPort%

:: ���õ�ǰĿ¼
set "VCMakeRootPath=%~dp0"

:: �����������װλ���п��ܲ��� SDK λ����ͬ������ QT5 �İ�װλ�ã�Ϊ SDK Ŀ¼�µ���Ŀ¼
set "BuildLang=VS%vsLangVC%"
set "Platform1=%1"
set "Platform2=%2"
set "dbSDKPath=%VCMakeRootPath%VSSDK\%Platform2%"
set "SetupPath=%VCMakeRootPath%VSSDK\%Platform2%"
set "bUseNinja=0"

:: ��װ����Դ����Ҫʹ�õ��Ĺ���
call "%VCMakeRootPath%\Script\vct.cmd" %VCMakeRootPath%

:: ����Դ��
call "%VCMakeRootPath%\Script\vcc.cmd" %VCMakeRootPath% %BuildLang% %Platform1% %Platform2% %dbSDKPath% %SetupPath% %bUseNinja%
rem call %VCMakeRootPath%Other\PDFium %VCMakeRootPath%Source %VCMakeRootPath%Build %VCMakeRootPath%VSSDK %VCMakeRootPath%Tools\CMake\bin %Platform2% %vsLangVC% 1 %httpAddr% %httpPort%
