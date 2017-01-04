#!/bin/bash

echo "you have to manually configure script by editing it"
exit 1

PREV_DIR=`pwd`

TEMP_DIR=`mktemp -d`
cd $TEMP_DIR

GCC_UNTAR=gcc-6.2.0
GCC_NAME=$GCC_UNTAR
GCC_TAR=$GCC_UNTAR.tar.bz2
wget ftp://ftp.nluug.nl/mirror/languages/gcc/releases/$GCC_NAME/$GCC_TAR

tar -xvf $GCC_TAR
rm $GCC_TAR

cd $GCC_UNTAR

# precrec
./contrib/download_prerequisites 
# configure installation
./configure --prefix=/usr/ --disable-multilib
# build
make
# install
sudo make install

cd $PREV_DIR
