@echo off
set SourcePosPath=%1
set BuildPDFiumPH=%2
set SetupSDKPathX=%3
set CompToolsPath=%4
set WinOSPlatform=%5
set VSLanguageVer=%6
set UserHttpProxy=%7
set HttpProxyAddr=%8
set HttpProxyPort=%9

set DEPOT_TOOLS_WIN_TOOLCHAIN=0
set GYP_MSVS_VERSION=%VSLanguageVer%
set GYP_MSVS_OVERRIDE_PATH=C:\Program Files (x86)\Microsoft Visual Studio\%VSLanguageVer%\Enterprise

set DepotTools_URL=https://storage.googleapis.com/chrome-infra/depot_tools.zip
set WindowsSDK_DIR=C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\%WinOSPlatform%
set PDFium_URL=https://pdfium.googlesource.com/pdfium.git
set DepotTools_DIR=%SourcePosPath%\PDFium\depot_tools
set PDFium_SOURCE_DIR=%SourcePosPath%\PDFium\PDFium
set PDFium_BUILD_DIR=%BuildPDFiumPH%\PDFium\%WinOSPlatform%
set PDFium_BRANCH=master
set PDFium_INCLUDE_DIR=%SetupSDKPathX%\%WinOSPlatform%\include\PDFium
set PDFium_LIB_DIR=%SetupSDKPathX%\%WinOSPlatform%\lib
set PATH=%CompToolsPath%;%DepotTools_DIR%;%WindowsSDK_DIR%;%PATH%
set NO_AUTH_BOTO_CONFIG=%SourcePosPath%\PDFium\boto.cfg
set http_proxy=
set https_proxy=

:: 下载源码
if not exist %SourcePosPath%\PDFium ( 
  :: 创建目录
  CD /D %SourcePosPath%
  md PDFium
  CD PDFium
  md PDFium
  md depot_tools
  CD /D  %SourcePosPath%\PDFium

  :: 下载 depot_tools
  if %UserHttpProxy%==1 (
    call curl -x http://%HttpProxyAddr%:%HttpProxyPort% -fsSL -o depot_tools.zip %DepotTools_URL%
    set http_proxy=http://%HttpProxyAddr%:%HttpProxyPort%
    set https_proxy=http://%HttpProxyAddr%:%HttpProxyPort%
    echo [Boto]>%NO_AUTH_BOTO_CONFIG%
    echo proxy=%HttpProxyAddr%>>%NO_AUTH_BOTO_CONFIG%
    echo proxy_port=%HttpProxyPort%>>%NO_AUTH_BOTO_CONFIG%
  ) else (
    call curl                                           -fsSL -o depot_tools.zip %DepotTools_URL%
  )

  :: 解压 depot_tools
  call 7z -bd -y x depot_tools.zip -o%DepotTools_DIR%

  :: 克隆代码
  call gclient config --unmanaged %PDFium_URL%
  call gclient sync
)

:: 删除原有编译临时目录
if exist %PDFium_BUILD_DIR% (
  echo 删除编译临时目录
  RD /S /Q %PDFium_BUILD_DIR%
)

:: 创建编译目录
if not exist %BuildPDFiumPH%\PDFium (
  CD /D %BuildPDFiumPH%
  MD PDFium
  CD PDFium
  MD %WinOSPlatform%
)

if not exist %PDFium_BUILD_DIR% (
  CD /D %BuildPDFiumPH%\PDFium
  MD %WinOSPlatform%
)

:: 生成编译参数配置文件
echo 生成编译参数配置文件
echo # 是否启用 goma 支持>%PDFium_BUILD_DIR%\args.gn
echo use_goma = false>>%PDFium_BUILD_DIR%\args.gn
echo # 是否编译为 Chrome 插件>>%PDFium_BUILD_DIR%\args.gn
echo clang_use_chrome_plugins = false>>%PDFium_BUILD_DIR%\args.gn
echo # 是否进行编译测试>>%PDFium_BUILD_DIR%\args.gn
echo pdf_is_standalone = true>>%PDFium_BUILD_DIR%\args.gn
echo # 是否启用 skia 支持 >>%PDFium_BUILD_DIR%\args.gn
echo pdf_use_skia = false>>%PDFium_BUILD_DIR%\args.gn
echo pdf_use_skia_paths = false>>%PDFium_BUILD_DIR%\args.gn
echo # true 编译为 debug 版本，false 编译为 release 版本>>%PDFium_BUILD_DIR%\args.gn
echo is_debug = false>>%PDFium_BUILD_DIR%\args.gn
echo # true 编译为动态库，false 编译为静态库>>%PDFium_BUILD_DIR%\args.gn
echo is_component_build = false>>%PDFium_BUILD_DIR%\args.gn
echo # 编译为独立的一个静态库；is_component_build 为 false 是，此选项才可用。false 编译为多个静态库，true 编译为一个静态库>>%PDFium_BUILD_DIR%\args.gn
echo pdf_is_complete_lib = true>>%PDFium_BUILD_DIR%\args.gn
echo # xfa 支持>>%PDFium_BUILD_DIR%\args.gn 
echo pdf_enable_xfa = true>>%PDFium_BUILD_DIR%\args.gn
echo # v8  支持；启用 v8 后，编译时间会增加>>%PDFium_BUILD_DIR%\args.gn
echo pdf_enable_v8 = true>>%PDFium_BUILD_DIR%\args.gn
echo # cpu 架构>>%PDFium_BUILD_DIR%\args.gn
echo target_cpu = "%WinOSPlatform%">>%PDFium_BUILD_DIR%\args.gn
echo # true 将用 clang 进行编译，false 将用 VS2017/VS2019 编译>>%PDFium_BUILD_DIR%\args.gn
echo is_clang = true>>%PDFium_BUILD_DIR%\args.gn
echo #  设置非嵌入式构建>>%PDFium_BUILD_DIR%\args.gn
echo pdf_is_standalone = true>>%PDFium_BUILD_DIR%\args.gn

CD /D  %SourcePosPath%\PDFium\PDFium

:: 生成 Ninja 文件
call gn gen --ide=vs %PDFium_BUILD_DIR% 

:: 修改 MD 编译为 MT
call fsr '%PDFium_BUILD_DIR%','*.ninja',' /MD',' /MT',1,1,'ASCII'
call fsr '%PDFium_BUILD_DIR%','*.vcxproj','MultiThreadedDLL','MultiThreaded',1,0,'UTF8'

:: 编译
call ninja -C %PDFium_BUILD_DIR% pdfium

:: 检查 CMake 编译是否有错误
if %errorlevel% NEQ 0 (
  echo 编译出现错误，停止编译
  pause
)

:: 安装
xcopy /S /Y %PDFium_SOURCE_DIR%\public %PDFium_INCLUDE_DIR%\
del %PDFium_INCLUDE_DIR%\DEPS
del %PDFium_INCLUDE_DIR%\README
del %PDFium_INCLUDE_DIR%\PRESUBMIT.py
copy /Y %PDFium_BUILD_DIR%\obj\pdfium.lib %PDFium_LIB_DIR%
copy /Y %PDFium_BUILD_DIR%\icudtl.dat %PDFium_LIB_DIR%
copy /Y %PDFium_BUILD_DIR%\snapshot_blob.bin %PDFium_LIB_DIR%
