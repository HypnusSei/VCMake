@echo off

set "Bname=%1"
set "Bhttp=%2"
set "Bpath=%3"
set "Build=%4 %5 %6 %7 %8 %9"

set "SourcePath=%~d0\Source"

if exist "%SourcePath%\%Bname%"   goto Compile

:: hg ��������������·�� px86.txt/px64.txt ��,Ҳ������ϵͳ�����У�������Ҫ����ϵͳ����·���У���Ϊϵͳ����·���г�������
echo ���� %Bname%
title ���� %Bname%
  hg clone %Bhttp% %SourcePath%\%Bname%
  
:Compile
echo ���� %Bname%
title ���� %Bname%
 "%Bpath%Script\vcm" %Bpath% %Bname% %Build%
