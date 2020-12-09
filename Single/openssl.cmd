@echo off
SETLOCAL EnableDelayedExpansion
Color A

set VCMakeRootPath=%1
set dbyoungSDKPath=%2
set InstallSDKPath=%3
set SourceCodeName=%4
set BuildPlatform_=%5
set BuildLanguageX=%6
set BuildHostX8664=%7
set VCProjectNameX=%8


:: Դ����Ŀ¼
set "OpenSSLSRC=%~d0\Source\%SourceCodeName%"
CD /D %OpenSSLSRC%

:: ����ƽ̨
if %BuildPlatform_%==Win32 ( 
  set bp=VC-WIN32 
) else (
  set bp=VC-WIN64A 
)

:: ����
perl Configure %bp% no-shared --prefix="%InstallSDKPath%"
nmake
nmake install

:: ��� VC �����Ƿ��д���
if %ERRORLEVEL% NEQ 0 (
  echo ������ִ���ֹͣ����
  pause
  goto bEnd
)

:: ����֤��
if %BuildPlatform_%==Win32 ( 
  xcopy /Y /E "%ProgramFiles(x86)%\Common Files\SSL\*.*" "%dbyoungSDKPath%\CA\SSL\"
) else (
  xcopy /Y /E "%ProgramFiles%\Common Files\SSL\*.*" "%dbyoungSDKPath%\CA\SSL\"
)

:: ��װ PC �ļ�
set "InstallPCPath=%dbyoungSDKPath:\=/%"

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\openssl.pc
@echo exec_prefix=${prefix}>>%dbyoungSDKPath%\lib\pkgconfig\openssl.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\openssl.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\openssl.pc
@echo Name: OpenSSL>>%dbyoungSDKPath%\lib\pkgconfig\openssl.pc
@echo Description: Secure Sockets Layer and cryptography libraries and tools>>%dbyoungSDKPath%\lib\pkgconfig\openssl.pc
@echo Version: 3.0>>%dbyoungSDKPath%\lib\pkgconfig\openssl.pc
@echo Requires: libssl libcrypto>>%dbyoungSDKPath%\lib\pkgconfig\openssl.pc

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo exec_prefix=${prefix}>>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo enginesdir=${libdir}/engines-1_1>>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Name: OpenSSL-libcrypto>>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Description: OpenSSL cryptography library>>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Version: 3.0>>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Libs: -L${libdir} -lcrypto>>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Libs.private: -lws2_32 -lgdi32 -lcrypt32 >>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc
@echo Cflags: -I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\libcrypto.pc

@echo prefix=%InstallPCPath%>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc
@echo exec_prefix=${prefix}>>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc
@echo libdir=${exec_prefix}/lib>>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc
@echo includedir=${prefix}/include>>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc
@echo Name: OpenSSL-libssl>>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc
@echo Description: Secure Sockets Layer and cryptography libraries>>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc
@echo Version: 3.0>>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc
@echo Requires.private: libcrypto>>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc
@echo Libs: -L${libdir} -lssl>>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc
@echo Cflags: -I${includedir}>>%dbyoungSDKPath%\lib\pkgconfig\libssl.pc

:: ���밲װ��ϣ�������ʱ�ļ�
nmake clean
