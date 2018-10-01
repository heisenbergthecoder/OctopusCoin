#!/bin/bash
export PATH=/root/mxe/usr/bin:$PATH

MINGW_THREAD_BUGFIX=0

MXE_INCLUDE_PATH=/root/mxe/usr/i686-w64-mingw32.static/include
MXE_LIB_PATH=/root/mxe/usr/i686-w64-mingw32.static/lib

MXE_SHARED_INCLUDE_PATH=/root/mxe/usr/i686-w64-mingw32.shared/include
MXE_SHARED_LIB_PATH=/root/mxe/usr/i686-w64-mingw32.shared/lib

cd ./src/leveldb
chmod +x *
#TARGET_OS=NATIVE_WINDOWS make CC=i686-w64-mingw32.static-gcc CXX=i686-w64-mingw32.static-g++ OPT="-m64 -pipe -fstack-protector-all -D_FORTIFY_SOURCE=2 -O2" -I $MXE_INCLUDE_PATH -pthread libleveldb.a libmemenv.a
TARGET_OS=NATIVE_WINDOWS make CC=i686-w64-mingw32.static-gcc CXX=i686-w64-mingw32.static-g++ libleveldb.a libmemenv.a
cd ../..

cd ./src/secp256k1
./autogen.sh
./configure --host=i686-w64-mingw32.static --prefix=/root/mxe/usr/i686-w64-mingw32.static --enable-static --disable-shared --with-bignum=no  --enable-module-recovery
make
cd ../..

i686-w64-mingw32.static-qmake-qt5 \
    BOOST_LIB_SUFFIX=-mt \
    BOOST_THREAD_LIB_SUFFIX=_win32-mt \
    BOOST_INCLUDE_PATH=$MXE_INCLUDE_PATH/boost \
    BOOST_LIB_PATH=$MXE_LIB_PATH \
    OPENSSL_INCLUDE_PATH=$MXE_INCLUDE_PATH/openssl \
    OPENSSL_LIB_PATH=$MXE_LIB_PATH \
    BDB_INCLUDE_PATH=$MXE_INCLUDE_PATH \
    BDB_LIB_PATH=$MXE_LIB_PATH \
    MINIUPNPC_INCLUDE_PATH=$MXE_INCLUDE_PATH \
    MINIUPNPC_LIB_PATH=$MXE_LIB_PATH \
    QMAKE_LRELEASE=/root/mxe/usr/i686-w64-mingw32.static/qt5/bin/lrelease octopus-qt.pro

make -f Makefile.Release