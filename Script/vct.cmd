@echo off
setlocal EnableDelayedExpansion
title  安装编译源代码过程中需要使用到的工具软件

:: 设置环境变量 
set "VCMakeRootPath=%1"
set "SCOOP=%VCMakeRootPath%Tools\x64\scoop"
set "Python2Path=%VCMakeRootPath%Tools\Python\2.7.16"
set "Python3Path=%VCMakeRootPath%Tools\Python\3.8.2"
set "Path=%SCOOP%\shims;%Path%"
set "Ruby=%SCOOP%\apps\ruby"
set "Perl=%VCMakeRootPath%Tools\Perl"
set "MSYS2=%VCMakeRootPath%Tools\MSYS2"
set "Path=%MSYS2%\usr\bin;%Path%"
set "x86=mingw-w64-i686"
set "x64=mingw-w64-x86_64"

:: 安装 scoop 软件包
if not exist "%SCOOP%\shims\scoop.ps1" (
  @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://get.scoop.sh'))"
  scoop bucket add extras
  ) 

:: 安装 scoop 工具包
set strTools=7zip/git/sliksvn/mercurial/pkg-config/cmake/curl/bison/winflexbison/ninja/swig/ant/jom/nasm/yasm/vswhere/llvm/doxygen/gnuplot/julia/latex/graphviz/go/rust-msvc/rust/anaconda3
:split
for /f "tokens=1,* delims=/" %%i in ("%strTools%") do (
  set ToolName=%%i
  if not exist "%SCOOP%\apps\%ToolName%" (
    call scoop install %ToolName%
  )
  set strTools=%%j
)
if not "%strTools%"=="" goto split

CD /D %VCMakeRootPath%Tools

:: 安装 MSYS2 软件
if not exist %MSYS2% (
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://repo.msys2.org/distrib/x86_64/msys2-x86_64-20201109.exe
rem   msys2-x86_64-20201109.exe --platform minimal InstallDir="%MSYS2%"
  msys2-x86_64-20201109.exe --platform minimal --script silent-install.js -v InstallPrefix="%MSYS2%"
  echo export http_proxy=127.0.0.1:1080>%MSYS2%\etc\profile.d\proxy.sh
  echo export https_proxy=127.0.0.1:1080>>%MSYS2%\etc\profile.d\proxy.sh
  echo export ftp_proxy=127.0.0.1:1080>>%MSYS2%\etc\profile.d\proxy.sh
  echo export HTTP_PROXY=127.0.0.1:1080>>%MSYS2%\etc\profile.d\proxy.sh
  echo export HTTPS_PROXY=127.0.0.1:1080>>%MSYS2%\etc\profile.d\proxy.sh
  echo export FTP_PROXY=127.0.0.1:1080>>%MSYS2%\etc\profile.d\proxy.sh
  bash -c "pacman -Syu"
  bash -c "pacman -Su"
  bash -c "pacman -S --noconfirm git subversion cvs mercurial doxygen swig p7zip lzip ed meson automake autoconf libtool m4 make cmake gettext gmp pkg-config findutils ruby ruby-docs yasm nasm patch perl dos2unix unzip gperf flex bison autogen python3 help2man"
  bash -c "pacman -S --noconfirm --needed base-devel msys2-devel %x64%-toolchain %x86%-toolchain"
  bash -c "pacman -S --noconfirm %x86%-python-wincertstore %x86%-python-certifi %x86%-meson %x86%-yasm %x86%-nasm %x86%-gtk3 %x86%-cmake %x86%-cninja %x86%-openh264 %x86%-ffmpeg %x86%-libjpeg-turbo %x86%-lua51 %x86%-llvm %x86%-qt5-static %x86%-gimp %x86%-ogre3d %x86%-ceres-solver %x86%-gflags %x86%-glog %x86%-hdf5 %x86%-opencv %x86%-tesseract-ocr %x86%-vtk"
  bash -c "pacman -S --noconfirm %x64%-python-wincertstore %x64%-python-certifi %x64%-meson %x64%-yasm %x64%-nasm %x64%-gtk3 %x64%-cmake %x64%-cninja %x64%-openh264 %x64%-ffmpeg %x64%-libjpeg-turbo %x64%-lua51 %x64%-llvm %x64%-qt5-static %x64%-gimp %x64%-ogre3d %x64%-ceres-solver %x64%-gflags %x64%-glog %x64%-hdf5 %x64%-opencv %x64%-tesseract-ocr %x64%-vtk"
)

:: 安装 Python 2.7.16 软件
if not exist %Python2Path% (
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/2.7.16/python-2.7.16.msi 
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/2.7.16/python-2.7.16.amd64.msi 
  call python-2.7.16.msi        /qn TARGETDIR="%Python2Path%\x86"
  call python-2.7.16.amd64.msi /qn TARGETDIR="%Python2Path%\x64"
  call "%Python2Path%\x86\python" -m pip install --upgrade pip
  call "%Python2Path%\x64\python" -m pip install --upgrade pip
  
  CD /D "%Python2Path%\x86\scripts"
  pip install numpy
  pip install flake8
  pip install pylint
  pip install PyYaml
  
  CD /D "%Python2Path%\x64\scripts"
  pip install numpy
  pip install flake8
  pip install pylint
  pip install PyYaml
)

CD /D %VCMakeRootPath%Tools

:: 安装 Python 3.8.2 软件
if not exist %Python3Path% (
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/3.8.2/python-3.8.2.exe
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/3.8.2/python-3.8.2-amd64.exe 
  call python-3.8.2.exe        /quiet TargetDir="%Python3Path%\x86" InstallAllUsers=1
  call python-3.8.2-amd64.exe /quiet TargetDir="%Python3Path%\x64" InstallAllUsers=1
  call "%Python3Path%\x86\python" -m pip install --upgrade pip
  call "%Python3Path%\x64\python" -m pip install --upgrade pip

  CD /D "%Python3Path%\x86\scripts"
  pip install numpy==1.19.3
  pip install flake8
  pip install pylint
  pip install meson
  pip install PyYaml
  
  CD /D "%Python3Path%\x64\scripts"
  pip install numpy==1.19.3
  pip install flake8
  pip install pylint
  pip install meson
  pip install PyYaml
)

CD /D %VCMakeRootPath%Tools

:: 安装 Perl 软件
if not exist %Perl% (
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  http://strawberryperl.com/download/5.32.0.1/strawberry-perl-5.32.0.1-64bit.msi
  call msiexec /i strawberry-perl-5.32.0.1-64bit.msi /quiet INSTALLDIR=%Perl%"
)

CD /D %VCMakeRootPath%
