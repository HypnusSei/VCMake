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

:: ����Դ��
if not exist %SourcePosPath%\PDFium ( 
  :: ����Ŀ¼
  CD /D %SourcePosPath%
  md PDFium
  CD PDFium
  md PDFium
  md depot_tools
  CD /D  %SourcePosPath%\PDFium

  :: ���� depot_tools
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

  :: ��ѹ depot_tools
  call 7z -bd -y x depot_tools.zip -o%DepotTools_DIR%

  :: ��¡����
  call gclient config --unmanaged %PDFium_URL%
  call gclient sync
)

:: ɾ��ԭ�б�����ʱĿ¼
if exist %PDFium_BUILD_DIR% (
  echo ɾ��������ʱĿ¼
  RD /S /Q %PDFium_BUILD_DIR%
)

:: ��������Ŀ¼
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

:: ���ɱ�����������ļ�
echo ���ɱ�����������ļ�
echo # �Ƿ����� goma ֧��>%PDFium_BUILD_DIR%\args.gn
echo use_goma = false>>%PDFium_BUILD_DIR%\args.gn
echo # �Ƿ����Ϊ Chrome ���>>%PDFium_BUILD_DIR%\args.gn
echo clang_use_chrome_plugins = false>>%PDFium_BUILD_DIR%\args.gn
echo # �Ƿ���б������>>%PDFium_BUILD_DIR%\args.gn
echo pdf_is_standalone = true>>%PDFium_BUILD_DIR%\args.gn
echo # �Ƿ����� skia ֧�� >>%PDFium_BUILD_DIR%\args.gn
echo pdf_use_skia = false>>%PDFium_BUILD_DIR%\args.gn
echo pdf_use_skia_paths = false>>%PDFium_BUILD_DIR%\args.gn
echo # true ����Ϊ debug �汾��false ����Ϊ release �汾>>%PDFium_BUILD_DIR%\args.gn
echo is_debug = false>>%PDFium_BUILD_DIR%\args.gn
echo # true ����Ϊ��̬�⣬false ����Ϊ��̬��>>%PDFium_BUILD_DIR%\args.gn
echo is_component_build = false>>%PDFium_BUILD_DIR%\args.gn
echo # ����Ϊ������һ����̬�⣻is_component_build Ϊ false �ǣ���ѡ��ſ��á�false ����Ϊ�����̬�⣬true ����Ϊһ����̬��>>%PDFium_BUILD_DIR%\args.gn
echo pdf_is_complete_lib = true>>%PDFium_BUILD_DIR%\args.gn
echo # xfa ֧��>>%PDFium_BUILD_DIR%\args.gn 
echo pdf_enable_xfa = true>>%PDFium_BUILD_DIR%\args.gn
echo # v8  ֧�֣����� v8 �󣬱���ʱ�������>>%PDFium_BUILD_DIR%\args.gn
echo pdf_enable_v8 = true>>%PDFium_BUILD_DIR%\args.gn
echo # cpu �ܹ�>>%PDFium_BUILD_DIR%\args.gn
echo target_cpu = "%WinOSPlatform%">>%PDFium_BUILD_DIR%\args.gn
echo # true ���� clang ���б��룬false ���� VS2017/VS2019 ����>>%PDFium_BUILD_DIR%\args.gn
echo is_clang = true>>%PDFium_BUILD_DIR%\args.gn
echo #  ���÷�Ƕ��ʽ����>>%PDFium_BUILD_DIR%\args.gn
echo pdf_is_standalone = true>>%PDFium_BUILD_DIR%\args.gn

CD /D  %SourcePosPath%\PDFium\PDFium

:: ���� Ninja �ļ�
call gn gen --ide=vs %PDFium_BUILD_DIR% 

:: �޸� MD ����Ϊ MT
call fsr '%PDFium_BUILD_DIR%','*.ninja',' /MD',' /MT',1,1,'ASCII'
call fsr '%PDFium_BUILD_DIR%','*.vcxproj','MultiThreadedDLL','MultiThreaded',1,0,'UTF8'

:: ����
call ninja -C %PDFium_BUILD_DIR% pdfium

:: ��� CMake �����Ƿ��д���
if %errorlevel% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
)

:: ��װ
xcopy /S /Y %PDFium_SOURCE_DIR%\public %PDFium_INCLUDE_DIR%\
del %PDFium_INCLUDE_DIR%\DEPS
del %PDFium_INCLUDE_DIR%\README
del %PDFium_INCLUDE_DIR%\PRESUBMIT.py
copy /Y %PDFium_BUILD_DIR%\obj\pdfium.lib %PDFium_LIB_DIR%
copy /Y %PDFium_BUILD_DIR%\icudtl.dat %PDFium_LIB_DIR%
copy /Y %PDFium_BUILD_DIR%\snapshot_blob.bin %PDFium_LIB_DIR%
