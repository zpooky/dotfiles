#!/usr/bin/env bash

PREV_DIR=`pwd`

TEMP_DIR=`mktemp -d`
NODE_VERSION=v6.9.4
DEST_TAR=$TEMP_DIR/node.tar.gz
UNTAR=$TEMP_DIR/node
TARGET=/opt/node-$NODE_VERSION
TARGET_LINK=/opt/node-latest

if [ ! -e $TARGET ]; then

  cd $TEMP_DIR
  wget -O $DEST_TAR https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz
  if [ $? -eq 0 ]; then
    mkdir $UNTAR
    tar -xf $DEST_TAR -C $UNTAR --strip-components=1
    if [ $? -eq 0 ]; then
      sudo chown root:root $UNTAR || exit 1
      sudo mv $UNTAR $TARGET
      if [ ! $? -eq 0 ]; then
        ln -s $TARGET $TARGET_LINK
        sudo rm $TARGET
      else
        which node
        if [ ! $? -eq 0 ]; then
          sudo update-alternatives --install /usr/bin/node node $TARGET/bin/node 100
          sudo update-alternatives --config node
        fi
        which npm
        if [ ! $? -eq 0 ]; then
          sudo update-alternatives --install /usr/bin/npm npm $TARGET/bin/npm 100
          sudo update-alternatives --config npm
        fi
        echo "SUCCESS"
      fi
    fi
  fi

  cd $PREV_DIR
else

  echo "node-$NODE_VERSION is allready installed in $TARGET"
  exit 1

fi
