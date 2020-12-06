@echo off 
title  安装编译源代码过程中需要使用到的工具软件

:: 设置环境变量 
set "VCMakeRootPath=%1"
set "SCOOP=%VCMakeRootPath%Tools\x64\scoop"
set "Python2Path=%VCMakeRootPath%Tools\Python\2.7.16"
set "Python3Path=%VCMakeRootPath%Tools\Python\3.8.2"
set "Path=%SCOOP%\shims;%Path%"
set "mconda3=%VCMakeRootPath%Tools\mconda3"
set "Perl=%VCMakeRootPath%Tools\Perl"

:: 安装 scoop 软件包
if not exist "%SCOOP%\shims\scoop.ps1" (@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://get.scoop.sh'))") 

:: 安装 scoop 工具包
set InstallTools=7zip/git/sliksvn/mercurial/pkg-config/cmake/curl/bison/winflexbison/ninja/swig/ant/jom/nasm/yasm/vswhere/llvm/doxygen/gnuplot/julia/ruby/latex/graphviz/go/rust-msvc/rust
:split
for /f "tokens=1,* delims=/" %%i in ("%InstallTools%") do (
  set ToolName=%%i
  if not exist "%SCOOP%\apps\%ToolName%" (call scoop install %ToolName%)
  set InstallTools=%%j
)
if not "%InstallTools%"=="" goto split

:: 安装 scoop - msys2 软件
if not exist "%SCOOP%\apps\msys2" (
  call scoop install msys2
  call ridk install
  )

:: 安装 scoop - miniconda3 软件
if not exist "%SCOOP%\apps\miniconda3" (
  call scoop bucket add extras
  call scoop install miniconda3
  call conda install -n root -c pscondaenvs pscondaenvs
  )

:: 安装 Python 2.7.16 软件
if not exist %Python2Path% (
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/2.7.16/python-2.7.16rc1.msi
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/2.7.16/python-2.7.16rc1.amd64.msi
  call  msiexec.exe /a python-2.7.16rc1.msi       /qn TARGETDIR="%Python2Path%\x86"
  call  msiexec.exe /a python-2.7.16rc1.amd64.msi /qn TARGETDIR="%Python2Path%\x64"
  CD /D "%Python2Path%\x86\scripts"
  pip install numpy==1.19.3
  pip install flake8
  pip install pylint
  pip install meson
  pip install PyYaml
  CD /D "%Python2Path%\x64\scripts"
  pip install numpy=1.19.3
  pip install flake8
  pip install pylint
  pip install meson
  pip install PyYaml
)

:: 安装 Python 3.8.2 软件
if not exist %Python3Path% (
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/3.8.2/python-3.8.2.exe
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/3.8.2/python-3.8.2-amd64.exe 

  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/3.8.2/python-3.8.2.exe
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://www.python.org/ftp/python/3.8.2/python-3.8.2-amd64.exe 
  call python-3.8.2.exe        /quiet TargetDir="%Python3Path%\x86" InstallAllUsers=1
  call python-3.8.2-amd64.exe /quiet TargetDir="%Python3Path%\x64" InstallAllUsers=1
  CD /D "%Python3Path%\x86\scripts"
  pip install numpy==1.19.3
  pip install flake8
  pip install pylint
  pip install meson
  pip install PyYaml
  CD /D "%Python3Path%\x64\scripts"
  pip install numpy=1.19.3
  pip install flake8
  pip install pylint
  pip install meson
  pip install PyYaml
)

:: 安装 mconda3 软件
if not exist %mconda3% (
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe
  call Miniconda3-latest-Windows-x86_64.exe        /quiet TargetDir=%mconda3%"
)

:: 安装 Perl 软件
if not exist %Perl% (
  call %SCOOP%\apps\curl\current\bin\curl -x 127.0.0.1:1080 --connect-timeout 30 --retry 10 --retry-delay 5 -C - -OL  http://strawberryperl.com/download/5.32.0.1/strawberry-perl-5.32.0.1-64bit.msi
  call  msiexec.exe /a strawberry-perl-5.32.0.1-64bit.msi  /qn TARGETDIR=%Perl%"
)

