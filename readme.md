# VC-CMake : VC2017/VC2019 CMake Compilation Source Code

- [简体中文](readmeCN.md)

## Document Description:
    Tools             : Directory; Place the tools needed for compilation. Such as cmake, pkgconfig, 7z, etc;
    Patch             : Directory; Place source patches;
    Single            : Directory; Place custom build files that you want to compile your own source code;
    After             : Directory; Place the cmd/bat for the your own action to be performed after the installation is completed;
    Script \ dlzip.cmd: Download a compressed source code file from the web
    Script \ dlgit.cmd: Download source code in GIT mode
    Script \ dlsvn.cmd: Download source code in SVN mode
    Script \ px86.txt : system search path when compiling x86; Modify according to the machine directory;
    Script \ px64.txt : system search path when compiling x64; Modify according to the machine directory;
    Script \ vcp.txt  : CMake compilation parameters; You can add it at will, add it without subtraction, unless you get compilation errors;
    Script \ vcc.cmd  : VC compilation environment check;
    Script \ vcm.cmd  : VC compilation; The core;
    vcx86.cmd         : Compile master switch. Start compiling for x86 platform; Support VC2017、VC2019;
    vcx64.cmd         : Compile master switch. Start compiling for x64 platform; Support VC2017、VC2019;
    vca.cmd           : The source code to be compiled is placed here, you can add it at will;

## Compile specification:
    The vcx86.cmd/vcx64.cmd file must be run in administrator mode;
    At the beginning of compilation, the source code directory is checked for existence; 
    If it exists, it will not be downloaded again;
    In other words, if the source code directory exists, that download address can be filled in arbitrarily;
    In other words, you can manually copy the source code directory to the Source directory for compilation;
    Since it is CMake compilation, of course, the source code must be supports CMake compilation. 
    That is to say, the source code directory must contain the CMakeLists.txt file;
    The default compiler is a static library of type MT. Other types can be modified by yourself;
    WIN7X64、WIN10X64 test pass；Support X86、X64;

## Communication and connection:
    Email：dbyoung@sina.com
    QQ   ：101611228
