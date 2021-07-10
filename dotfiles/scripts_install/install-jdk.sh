#!/usr/bin/env bash
# 1. run script
# 2. manually configure installation
#   update-alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_45/bin/java 100  
#   update-alternatives --config java
PREV_DIR=`pwd`

TEMP_DIR=`mktemp -d`
DEST_TAR=$TEMP_DIR/jdk.tar.gz
JDK_BETA=b13
JDK_VERSION=8u121
UNTAR=$TEMP_DIR/$JDK_VERSION
TARGET=/opt/jdk$JDK_VERSION

cd $TEMP_DIR

if [ ! -e $TARGET ]; then
  wget -O $DEST_TAR \
        http://download.oracle.com/otn-pub/java/jdk/$JDK_VERSION-$JDK_BETA/e9e7ea248e2c4826b92b3f075a80e441/jdk-$JDK_VERSION-linux-x64.tar.gz \
        --no-cookies \
        --no-check-certificate \
        --header "Cookie: oraclelicense=accept-securebackup-cookie"
  if [ $? -eq 0 ]; then
    echo "tar -xzvf $DEST_TAR -C $UNTAR --strip-components=1"
    mkdir $UNTAR
    tar -xzvf $DEST_TAR -C $UNTAR --strip-components=1
    if [ $? -eq 0 ]; then
      sudo mv $UNTAR $TARGET 
      if [ $? -eq 0 ]; then
        echo "INSTALLED"
        sudo rm -rf $UNTAR 
        sudo chown root:root $TARGET -R
        which java
        if [ ! $? -eq 0 ]; then
          # only do this when there is no java
          sudo update-alternatives --install /usr/bin/java java $TARGET/bin/java 100
          sudo update-alternatives --config java
          #
          sudo update-alternatives --install /usr/bin/javac javac $TARGET/bin/javac 100
          sudo update-alternatives --config javac
          #
          sudo update-alternatives --install /usr/bin/jar jar $TARGET/bin/jar 100
          sudo update-alternatives --config jar
        fi
      else
        echo "NOT INSTALLED"
      fi
    fi
  fi
else
  echo "JDK$JDK_VERSION is allready installed to $TARGET"
fi

cd $PREV_DIR
