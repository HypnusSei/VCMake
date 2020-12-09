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
set "MSYS2=%SCOOP%\apps\MSYS2\current"
set "Path=%MSYS2%\usr\bin;%Path%"

:: 安装 scoop 软件包
if not exist "%SCOOP%\shims\scoop.ps1" (
  @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://get.scoop.sh'))"
  scoop bucket add extras
  ) 

:: 安装 scoop 工具包
set strTools=7zip/git/sliksvn/mercurial/pkg-config/cmake/curl/bison/winflexbison/ninja/swig/ant/jom/nasm/yasm/vswhere/llvm/doxygen/gnuplot/julia/latex/graphviz/go/rust-msvc/rust/msys2/anaconda3
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
