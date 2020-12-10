@echo off

set VCMakeRootPath=%1
set BuildLanguageX=%2
set BuildPlatform1=%3
set BuildPlatform2=%4
set dbyoungSDKPath=%5
set InstallSDKPath=%6
set "Buildtype=%VCMakeRootPath% %BuildLanguageX% %BuildPlatform1% %BuildPlatform2% %dbyoungSDKPath% %InstallSDKPath%"

:: 编译未成功，待验证
rem call "%VCMakeRootPath%Script\dlgit" ImageMagick-windows          https://github.com/ImageMagick/ImageMagick-windows.git              %Buildtype% nghttp2.sln
rem call "%VCMakeRootPath%Script\dlzip" ncurses-6.2                  https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.2.tar.gz              %Buildtype% ncurses.sln
rem call "%VCMakeRootPath%Script\dlgit" fish                         https://git.sr.ht/~faho/fish                                        %Buildtype% fish.sln
rem call "%VCMakeRootPath%Script\dlgit" PDCurses                     https://github.com/Bill-Gray/PDCurses.git                           %Buildtype% PDCurses.sln
rem call "%VCMakeRootPath%Script\dlgit" doxygen                      https://github.com/doxygen/doxygen.git                              %Buildtype% doxygen.sln
rem call "%VCMakeRootPath%Script\dlgit" pytorch                      https://github.com/pytorch/pytorch.git                              %Buildtype% Caffe2.sln
rem call "%VCMakeRootPath%Script\dlgit" libvidstab                   https://github.com/georgmartius/vid.stab.git                        %Buildtype% vid.stab.sln
rem call "%VCMakeRootPath%Script\dlgit" libwebsockets                https://github.com/warmcat/libwebsockets.git                        %Buildtype% libwebsockets.sln
rem call "%VCMakeRootPath%Script\dlgit" aom                          https://aomedia.googlesource.com/aom                                %Buildtype% aom.sln
rem call "%VCMakeRootPath%Script\dlgit" pkg-config                   git://anongit.freedesktop.org/pkg-config                            %Buildtype% pkg-config.sln
rem call "%VCMakeRootPath%Script\dlgit" libkml                       https://github.com/libkml/libkml.git                                %Buildtype% libkml.sln
rem call "%VCMakeRootPath%Script\dlgit" FreeImage                    https://github.com/Kanma/FreeImage.git                              %Buildtype% FreeImage.sln
rem call "%VCMakeRootPath%Script\dlgit" cegui-deps                   https://github.com/cegui/cegui-dependencies.git                     %Buildtype% CEGUI-DEPS.sln
rem call "%VCMakeRootPath%Script\dlgit" caffe                        https://github.com/BVLC/caffe.git#windows                           %Buildtype% caffe.sln
rem call "%VCMakeRootPath%Script\dlgit" cegui                        https://github.com/cegui/cegui.git                                  %Buildtype% CEGUI.sln
rem call "%VCMakeRootPath%Script\dlgit" qTox                         https://github.com/qTox/qTox.git                                    %Buildtype% qTox.sln
rem call "%VCMakeRootPath%Script\dlgit" flang                        https://github.com/flang-compiler/flang.git                         %Buildtype% flang.sln
rem call "%VCMakeRootPath%Script\dlgit" rocksdb                      https://github.com/facebook/rocksdb.git                             %Buildtype% rocksdb.sln

:: 编译成功
rem call "%VCMakeRootPath%Script\dlzip" zlib-1.2.11                  https://www.zlib.net/zlib-1.2.11.tar.gz                             %Buildtype% zlib.sln
rem call "%VCMakeRootPath%Script\dlgit" xz                           https://git.tukaani.org/xz.git                                      %Buildtype% xz.sln
rem call "%VCMakeRootPath%Script\dlgit" bzip2                        https://github.com/osrf/bzip2_cmake.git                             %Buildtype% bzip2.sln
rem call "%VCMakeRootPath%Script\dlgit" z3                           https://github.com/Z3Prover/z3.git                                  %Buildtype% z3.sln
rem call "%VCMakeRootPath%Script\dlgit" lz4                          https://github.com/lz4/lz4.git                                      %Buildtype% lz4.sln
rem call "%VCMakeRootPath%Script\dlgit" zziplib                      https://github.com/gdraheim/zziplib.git                             %Buildtype% zziplib.sln
rem call "%VCMakeRootPath%Script\dlgit" snappy                       https://github.com/willyd/snappy.git                                %Buildtype% snappy.sln
rem call "%VCMakeRootPath%Script\dlgit" zstd                         https://github.com/facebook/zstd.git                                %Buildtype% zstd.sln
rem call "%VCMakeRootPath%Script\dlgit" giflib                       https://github.com/xbmc/giflib.git                                  %Buildtype% giflib.sln
rem call "%VCMakeRootPath%Script\dlgit" libjpeg-turbo                https://github.com/libjpeg-turbo/libjpeg-turbo.git                  %Buildtype% libjpeg-turbo.sln
rem call "%VCMakeRootPath%Script\dlgit" libpng                       https://github.com/glennrp/libpng.git                               %Buildtype% libpng.sln
rem call "%VCMakeRootPath%Script\dlgit" libtiff                      https://gitlab.com/libtiff/libtiff.git                              %Buildtype% tiff.sln
rem call "%VCMakeRootPath%Script\dlgit" openjpeg                     https://github.com/uclouvain/openjpeg.git                           %Buildtype% openjpeg.sln
rem call "%VCMakeRootPath%Script\dlgit" libwebp                      https://chromium.googlesource.com/webm/libwebp                      %Buildtype% webp.sln
rem call "%VCMakeRootPath%Script\dlgit" leptonica                    https://github.com/DanBloomberg/leptonica.git                       %Buildtype% leptonica.sln
rem call "%VCMakeRootPath%Script\dlgit" tesseract                    https://github.com/tesseract-ocr/tesseract.git                      %Buildtype% tesseract.sln
rem call "%VCMakeRootPath%Script\dlzip" SDL2-2.0.12                  http://www.libsdl.org/release/SDL2-2.0.12.tar.gz                    %Buildtype% sdl2.sln
rem call "%VCMakeRootPath%Script\dlgit" gflags                       https://github.com/gflags/gflags.git                                %Buildtype% gflags.sln
rem call "%VCMakeRootPath%Script\dlgit" glog                         https://github.com/google/glog.git                                  %Buildtype% glog.sln
rem call "%VCMakeRootPath%Script\dlgit" gtest                        https://github.com/google/googletest.git                            %Buildtype% googletest-distribution.sln
rem call "%VCMakeRootPath%Script\dlzip" sqlite-snapshot-202003121754 https://www.sqlite.org/snapshot/sqlite-snapshot-202003121754.tar.gz %Buildtype% sqlite.sln
rem call "%VCMakeRootPath%Script\dlgit" libssh2                      https://github.com/libssh2/libssh2.git                              %Buildtype% libssh2.sln
rem call "%VCMakeRootPath%Script\dlgit" gettext                      https://github.com/georgegerdin/gettext-cmake.git                   %Buildtype% gettext.sln
rem call "%VCMakeRootPath%Script\dlgit" freetype                     https://github.com/winlibs/freetype.git                             %Buildtype% freetype.sln
call "%VCMakeRootPath%Script\dlgit" brotli                       https://github.com/google/brotli.git                                %Buildtype% brotli.sln
call "%VCMakeRootPath%Script\dlgit" harfbuzz                     https://github.com/harfbuzz/harfbuzz.git                            %Buildtype% harfbuzz.sln
call "%VCMakeRootPath%Script\dlgit" hdf5                         https://github.com/live-clones/hdf5.git                             %Buildtype% hdf5.sln
call "%VCMakeRootPath%Script\dlgit" libiconv                     https://github.com/LuaDist/libiconv.git                             %Buildtype% libiconv.sln
call "%VCMakeRootPath%Script\dlgit" libxml2                      https://github.com/GNOME/libxml2.git                                %Buildtype% libxml2.sln
call "%VCMakeRootPath%Script\dlgit" pcre                         https://github.com/svn2github/pcre.git                              %Buildtype% pcre.sln
call "%VCMakeRootPath%Script\dlzip" pcre2-10.34                  https://downloads.sourceforge.net/pcre/pcre2-10.34.tar.bz2          %Buildtype% pcre2.sln
call "%VCMakeRootPath%Script\dlgit" boost                        https://github.com/boostorg/boost.git                               %Buildtype% boost.sln
call "%VCMakeRootPath%Script\dlgit" leveldb                      https://github.com/google/leveldb.git                              %Buildtype% leveldb.sln
call "%VCMakeRootPath%Script\dlgit" openssl                      https://github.com/openssl/openssl.git                              %Buildtype% openssl.sln
call "%VCMakeRootPath%Script\dlgit" nghttp2                      https://github.com/nghttp2/nghttp2.git                              %Buildtype% nghttp2.sln
call "%VCMakeRootPath%Script\dlgit" eigen                        https://github.com/eigenteam/eigen-git-mirror.git                   %Buildtype% eigen3.sln
call "%VCMakeRootPath%Script\dlgit" c-ares                       https://github.com/c-ares/c-ares.git                                %Buildtype% c-ares.sln
call "%VCMakeRootPath%Script\dlgit" curl                         https://github.com/curl/curl.git                                    %Buildtype% curl.sln
call "%VCMakeRootPath%Script\dlgit" fribidi                      https://github.com/fribidi/fribidi.git                              %Buildtype% fribidi.sln
call "%VCMakeRootPath%Script\dlgit" tinyxml2                     https://github.com/leethomason/tinyxml2.git                         %Buildtype% tinyxml2.sln
call "%VCMakeRootPath%Script\dlgit" llvm                         https://github.com/llvm/llvm-project.git                            %Buildtype% llvm.sln
call "%VCMakeRootPath%Script\dlgit" CastXML                      https://github.com/CastXML/CastXML.git                              %Buildtype% CastXML.sln
call "%VCMakeRootPath%Script\dlgit" libexpat                     https://github.com/libexpat/libexpat.git                            %Buildtype% expat.sln
call "%VCMakeRootPath%Script\dlgit" fontconfig                   https://github.com/georgegerdin/fontconfig-cmake.git                %Buildtype% fontconfig.sln
call "%VCMakeRootPath%Script\dlgit" icu                          https://github.com/hunter-packages/icu.git                          %Buildtype% icu.sln
call "%VCMakeRootPath%Script\dlgit" websocketpp                  https://github.com/zaphoyd/websocketpp.git                          %Buildtype% websocketpp.sln
call "%VCMakeRootPath%Script\dlgit" PROJ                         https://github.com/OSGeo/PROJ.git                                   %Buildtype% PROJ.sln
call "%VCMakeRootPath%Script\dlgit" ceres                        https://github.com/ceres-solver/ceres-solver.git                    %Buildtype% ceres.sln
call "%VCMakeRootPath%Script\dlgit" glib                         https://github.com/GNOME/glib.git                                   %Buildtype% glib.sln
call "%VCMakeRootPath%Script\dlgit" pixman                       https://gitlab.freedesktop.org/pixman/pixman                        %Buildtype% pixman.sln
call "%VCMakeRootPath%Script\dlgit" cairo                        https://github.com/freedesktop/cairo.git                            %Buildtype% cairo.sln
call "%VCMakeRootPath%Script\dlgit" qt5                          https://code.qt.io/qt/qt5.git#5.15.0                                %Buildtype% qt5.sln
call "%VCMakeRootPath%Script\dlzip" qt6                          http://mirrors.sjtug.sjtu.edu.cn/qt/archive/qt/6.0/6.0.0/single/qt-everywhere-src-6.0.0.tar.xz %Buildtype% qt6.sln
call "%VCMakeRootPath%Script\dlzip" VTK-9.0.1                    https://www.vtk.org/files/release/9.0/VTK-9.0.1.tar.gz              %Buildtype% VTK.sln
call "%VCMakeRootPath%Script\dlgit" AMF                          https://github.com/GPUOpen-LibrariesAndSDKs/AMF.git                 %Buildtype% AMF.sln
call "%VCMakeRootPath%Script\dlzip" libogg-1.3.4                 http://downloads.xiph.org/releases/ogg/libogg-1.3.4.tar.gz          %Buildtype% libogg.sln
call "%VCMakeRootPath%Script\dlzip" libvorbis-1.3.6              http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.6.tar.gz    %Buildtype% libvorbis.sln
call "%VCMakeRootPath%Script\dlzip" libtheora-1.1.1              http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2   %Buildtype% libtheora.sln
call "%VCMakeRootPath%Script\dlzip" flac-1.3.2                   http://downloads.xiph.org/releases/flac/flac-1.3.2.tar.xz           %Buildtype% flac.sln
call "%VCMakeRootPath%Script\dlgit" tbb                          https://github.com/intel/tbb.git                                    %Buildtype% tbb.sln
call "%VCMakeRootPath%Script\dlgit" lua                          https://github.com/LuaDist/lua.git                                  %Buildtype% lua.sln
call "%VCMakeRootPath%Script\dlgit" libuv                        https://github.com/libuv/libuv.git                                  %Buildtype% libuv.sln
call "%VCMakeRootPath%Script\dlgit" openh264                     https://github.com/cisco/openh264.git                               %Buildtype% openh264.sln
call "%VCMakeRootPath%Script\dlgit" OIS                          https://github.com/wgois/OIS.git                                    %Buildtype% OIS.sln
call "%VCMakeRootPath%Script\dlhg"  x265                         https://bitbucket.org/multicoreware/x265                            %Buildtype% x265.sln
call "%VCMakeRootPath%Script\dlgit" yasm                         https://github.com/yasm/yasm.git                                    %Buildtype% yasm.sln
call "%VCMakeRootPath%Script\dlgit" dav1d                        https://code.videolan.org/videolan/dav1d.git                        %Buildtype% dav1d.sln
call "%VCMakeRootPath%Script\dlgit" ZenLib                       https://github.com/MediaArea/ZenLib.git                             %Buildtype% ZenLib.sln
call "%VCMakeRootPath%Script\dlgit" minizip                      https://github.com/nmoinvaz/minizip.git                             %Buildtype% minizip.sln
call "%VCMakeRootPath%Script\dlgit" uriparser                    https://github.com/uriparser/uriparser.git                          %Buildtype% uriparser.sln
call "%VCMakeRootPath%Script\dlgit" gdal                         https://github.com/OSGeo/gdal.git                                   %Buildtype% gdal.sln
call "%VCMakeRootPath%Script\dlgit" lmdb                         https://github.com/LMDB/lmdb.git                                    %Buildtype% lmdb.sln
call "%VCMakeRootPath%Script\dlgit" protobuf                     https://github.com/protocolbuffers/protobuf.git#3.5.x               %Buildtype% protobuf.sln
call "%VCMakeRootPath%Script\dlgit" opencv                       https://github.com/opencv/opencv.git                                %Buildtype% opencv.sln
rem call "%VCMakeRootPath%Script\dlgit" wxWidgets                    https://github.com/wxWidgets/wxWidgets.git                          %Buildtype% wxWidgets.sln
rem call "%VCMakeRootPath%Script\dlgit" lapack                       https://github.com/Reference-LAPACK/lapack.git                      %Buildtype% lapack.sln
rem call "%VCMakeRootPath%Script\dlgit" OpenBLAS                     https://github.com/xianyi/OpenBLAS.git                              %Buildtype% OpenBLAS.sln
rem call "%VCMakeRootPath%Script\dlgit" cmake                        https://gitlab.kitware.com/cmake/cmake.git                          %Buildtype% cmake.sln
