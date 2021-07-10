#!/usr/bin/env bash

echo "you have to manually configure script by editing it"
exit 1

PREV_DIR=`pwd`

SOURCE_DIR="~/sources"
mkdir -p $SOURCE_DIR

cd $SOURCE_DIR

GCC_UNTAR=gcc-6.2.0
GCC_NAME=$GCC_UNTAR
if [ -e $GCC_UNTAR ]; then
  rm -rf $GCC_UNTAR
fi
GCC_TAR=$GCC_UNTAR.tar.bz2
wget ftp://ftp.nluug.nl/mirror/languages/gcc/releases/$GCC_NAME/$GCC_TAR
if [ ! $? -eq 0 ];then
  rm $GCC_TAR
  exit 1
fi

tar -xf $GCC_TAR || exit 1
rm $GCC_TAR

cd $GCC_UNTAR

# precrec
./contrib/download_prerequisites  || exit 1
# configure installation
./configure --prefix=/usr/local --disable-multilib || exit 1
# build using pipeline
# make -pipe
make -j 6 > /dev/null || exit 1
# install
sudo make install || exit 1

cd $PREV_DIR
