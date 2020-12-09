@echo off
SETLOCAL EnableDelayedExpansion

set "Bname=%1"
set "Bhttp=%2"
set "Bpath=%3"
set "Build=%4 %5 %6 %7 %8 %9"
set "Bdivi=#"

set "SourcePath=%~d0\Source"

if exist "%SourcePath%\%Bname%"   goto Compile

:: git ��������������·�� px86.txt/px64.txt ��,Ҳ������ϵͳ�����У�������Ҫ����ϵͳ����·���У���Ϊϵͳ����·���г�������
echo ���� %Bname%
title ���� %Bname%

:: �ж��Ƿ��з�֧
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
echo ���� %Bname%
title ���� %Bname%
 "%Bpath%Script\vcm" %Bpath% %Bname% %Build%
