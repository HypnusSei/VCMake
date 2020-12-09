@echo off

set "Bname=%1"
set "Bhttp=%2"
set "Bpath=%3"
set "Build=%4 %5 %6 %7 %8 %9"

set "SourcePath=%~d0\Source"

if exist "%SourcePath%\%Bname%"   goto Compile

:: hg 软件必须存在搜索路径 px86.txt/px64.txt 中,也可以在系统搜索中；尽量不要放在系统搜索路径中，因为系统搜索路径有长度限制
echo 下载 %Bname%
title 下载 %Bname%
  hg clone %Bhttp% %SourcePath%\%Bname%
  
:Compile
echo 编译 %Bname%
title 编译 %Bname%
 "%Bpath%Script\vcm" %Bpath% %Bname% %Build%
