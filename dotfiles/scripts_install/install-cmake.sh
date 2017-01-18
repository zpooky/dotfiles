#!/bin/bash

PREV_DIR=`pwd`

CMAKE_NAME=cmake-3.7.1
CMAKE_TAR=$CMAKE_NAME.tar.gz

TARGET=$HOME

TEMP_DIR=`mktemp -d`
cd $TEMP_DIR

echo "Specify target"
echo "suggestions: "
echo " - /usr/ - for all"
echo " - /usr/local - for all(Prefered)"
echo " - / - for all..."
echo " - $HOME - for only you. have to add $HOME/bin to path."
printf "target[$HOME]: "

read NEW_TARGET
if [ ! -z "$NEW_TARGET" ]; then
  TARGET="$NEW_TARGET"
fi
if [ ! -d "$TARGET" ]; then
  echo "prefix '$TARGET' does not exist"
  exit 1
fi

echo ""
echo "installing to $TARGET"
echo ""
echo "About to install $CMAKE_NAME"
printf "Currently installed "
echo `cmake --version` | head -1
echo ""
read -p "Are you sure? [y/N]: " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "aborting"
  exit 1
fi
echo ""
echo ""
echo ""
wget -O $CMAKE_TAR https://cmake.org/files/v3.7/$CMAKE_NAME
if [ $? -eq 0 ]; then
  tar -xzvf $CMAKE_TAR
  if [ $? -eq 0 ]; then
    cd $CMAKE_NAME
    ./bootstrap --prefix=$TARGET
    if [ $? -eq 0 ]; then
      make
      if [ $? -eq 0 ]; then
        make install
        if [ $? -eq 0 ]; then
          echo "OK"
          echo "OK"
          echo "OK"
          echo "OK"
        fi
      fi
    fi
  fi
fi

cd $PREV_DIR
