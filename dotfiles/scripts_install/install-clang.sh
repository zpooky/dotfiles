#!/bin/bash

PREV_DIR=`pwd`

SOURCES_ROOT=$HOME/sources
if [ ! -e $SOURCES_ROOT ]; then
  mkdir $SOURCES_ROOT
fi

NAME=llvm
ROOT=$SOURCES_ROOT/$NAME

CLANG_NAME=clang
TOOLS_ROOT=$ROOT/tools
CLANG_ROOT=$TOOLS_ROOT/clang
BUILD_ROOT=$ROOT/build
CLANG_TOOLS_ROOT=$CLANG_ROOT/tools
CLANG_TOOLS_EXTRA=$CLANG_TOOLS_ROOT/extra

cd $SOURCES_ROOT

if [ ! -e $ROOT ]; then
  svn co http://llvm.org/svn/llvm-project/llvm/trunk $ROOT
  if [ ! $? -eq 0 ]; then
    rm -rf $ROOT
    echo "llvm failed to clone"
    exit 1
  fi
fi

if [ -e $ROOT ]; then
  cd $TOOLS_ROOT

  if [ ! -e $CLANG_ROOT ];then
    svn co http://llvm.org/svn/llvm-project/cfe/trunk $CLANG_ROOT
    if [ ! $? -eq 0 ]; then
      rm -rf $CLANG_ROOT
      echo "clang failed to clone"
      exit 1
    fi
  fi

  if [ -e $CLANG_ROOT ]; then

    if [ ! -e $CLANG_TOOLS_EXTRA ]; then
      svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk $CLANG_TOOLS_EXTRA
      if [ ! $? -eq 0 ]; then
        rm -rf $CLANG_TOOLS_EXTRA
        echo "clang-tools-extra failed to clone"
        exit 1
      fi
    fi

    if [ ! -e $BUILD_ROOT ]; then
      mkdir $BUILD_ROOT
    fi

    cd $BUILD_ROOT

    # CC=gcc CXX=g++                              \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_TARGETS_TO_BUILD="host" -Wno-dev ..
    if [ $? -eq 0 ];then
      make -j 4
      if [ $? -eq 0 ];then
        make install
        if [ $? -eq 0 ];then
          clang --version
        fi
      fi
    fi

  fi
fi

cd $PREV_DIR
