::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::: 1.0：Windows10下，编译 OpenSSL 需要管理员权限，因为它需要向系统盘写入数据；
:::: 2.0：编译 lapack，  需要 Intel Parallel Studio 2020 开发组件 (包含 ifort Fortran 编译器), CMake 只能使用 Ninja 模式(bUseNinja=1)，不能使用 VS 模式；
:::: 3.1：编译 Openblas，需要 Fortran 编译器, miniconda3                 包含 flang Fortran 编译器, CMake 使用 Ninja + clang + flang 模式(bUseNinja=0)；
:::: 3.2：编译 Openblas，需要 Fortran 编译器, Intel Parallel Studio 2020 包含 flang Fortran 编译器, CMake 使用 Ninja + clang + ifort 模式(bUseNinja=0)；
:::: 4.0：编译 PDFium，  需要 VS2019 + Windows SDK 10.0.19041.0, 必须使用 clang 编译，不能使用 cl 编译；
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
setlocal EnableDelayedExpansion
Color A

set httpAddr=127.0.0.1
set httpPort=1080
set vsLangVC=2019
  
:: 设置网络代理；如果没有网络代理，可以注释掉这两行代码；
set http_proxy=http://%httpAddr%:%httpPort%
set https_proxy=http://%httpAddr%:%httpPort%

:: 设置当前目录
set "VCMakeRootPath=%~dp0"

:: 编译参数；安装位置有可能不和 SDK 位置相同。比如 QT5 的安装位置，为 SDK 目录下的子目录
set "BuildLang=VS%vsLangVC%"
set "Platform1=%1"
set "Platform2=%2"
set "dbSDKPath=%VCMakeRootPath%VSSDK\%Platform2%"
set "SetupPath=%VCMakeRootPath%VSSDK\%Platform2%"
set "bUseNinja=0"

:: 安装编译源码需要使用到的工具
call "%VCMakeRootPath%\Script\vct.cmd" %VCMakeRootPath%

:: 编译源码
call "%VCMakeRootPath%\Script\vcc.cmd" %VCMakeRootPath% %BuildLang% %Platform1% %Platform2% %dbSDKPath% %SetupPath% %bUseNinja%
rem call %VCMakeRootPath%Other\PDFium %VCMakeRootPath%Source %VCMakeRootPath%Build %VCMakeRootPath%VSSDK %VCMakeRootPath%Tools\CMake\bin %Platform2% %vsLangVC% 1 %httpAddr% %httpPort%
