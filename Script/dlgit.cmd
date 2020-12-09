@echo off
SETLOCAL EnableDelayedExpansion

set "Bname=%1"
set "Bhttp=%2"
set "Bpath=%3"
set "Build=%4 %5 %6 %7 %8 %9"
set "Bdivi=#"

set "SourcePath=%~d0\Source"

if exist "%SourcePath%\%Bname%"   goto Compile

:: git 软件必须存在搜索路径 px86.txt/px64.txt 中,也可以在系统搜索中；尽量不要放在系统搜索路径中，因为系统搜索路径有长度限制
echo 下载 %Bname%
title 下载 %Bname%

:: 判断是否有分支
set bExistBranch=false
echo %Bhttp% | findstr %Bdivi% >nul && set bExistBranch=true

set string=%Bhttp%
set num=0
if %bExistBranch%==true (
  :split
  for /f "tokens=1,* delims=#" %%i in ("%string%") do (
    set a[%num%]=%%i
    set /a num+=1
    set string=%%j
  )
  if not "%string%"=="" goto split
  git clone --progress --recursive  --branch %a[1]% -v %a[0]% %SourcePath%\%Bname%
  goto Compile
) else (
  git clone --progress --recursive                 -v %Bhttp% %SourcePath%\%Bname%
)
 
:Compile
echo 编译 %Bname%
title 编译 %Bname%
 "%Bpath%Script\vcm" %Bpath% %Bname% %Build%
