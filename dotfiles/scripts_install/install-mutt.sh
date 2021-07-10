#!/usr/bin/env bash

PREV_DIR=`pwd`

SOURCES_ROOT=$HOME/sources
if [ ! -e $SOURCES_ROOT ]; then
  mkdir $SOURCES_ROOT
fi
# ===================================================
# ===================================================
# ============slang (mutt dependency)===============
# ===================================================
# ===================================================
NAME=slang
VERSION=2.3.1
NAME_VERSION=$NAME-$VERSION
ROOT=$SOURCES_ROOT/$NAME
TARGET=$ROOT/$NAME_VERSION
LATEST=$ROOT/$NAME-latest
if [ ! -e $ROOT ];then
  mkdir $ROOT
fi

if [ ! -e $TARGET ]; then

  TAR_NAME="${NAME_VERSION}a.tar.bz2"
  TAR=$ROOT/$TAR_NAME
  RET=1

  wget "http://www.jedsoft.org/releases/$NAME/$TAR_NAME" -O $TAR
  if [ $? -eq 0 ];then
    mkdir $TARGET
    tar -xf $TAR -C $TARGET --strip-components=1
    if [ $? -eq 0 ];then 
      cd $TARGET
      ./configure --prefix=/usr/local --with-readline=gnu
      if [ $? -eq 0 ]; then
        make
        if [ $? -eq 0 ]; then
          CURRENT=`pwd`
          if [ -e $LATEST ];then
            # uninstall previous
            cd $LATEST
            sudo make uninstall
            cd $CURRENT
            rm -rf $LATEST
          fi
          sudo make install
          if [ $? -eq 0 ];then
            RET=0
            ln -s $TARGET $LATEST
            echo "$NAME OK"
          fi
        fi
      fi
    fi
    if [ ! $RET -eq 0 ];then
      rm -rf $TARGET
    fi
    rm $TAR
  fi
fi
# ===================================================
# ===================================================
# libiconv
# ===================================================
# ===================================================
NAME=libiconv
VERSION=1.14
NAME_VERSION=$NAME-$VERSION
ROOT=$SOURCES_ROOT/$NAME
TARGET=$ROOT/$NAME_VERSION
LATEST=$ROOT/$NAME-latest
if [ ! -e $ROOT ];then
  mkdir $ROOT
fi

if [ ! -e $TARGET ]; then

  TAR_NAME=$NAME_VERSION.tar.gz
  TAR=$ROOT/$TAR_NAME
  RET=1

  wget "http://ftp.gnu.org/pub/gnu/$NAME/$TAR_NAME" -O $TAR
  if [ $? -eq 0 ];then
    mkdir $TARGET
    tar -xzf $TAR -C $TARGET --strip-components=1
    if [ $? -eq 0 ];then 
      cd $TARGET
      ./configure --prefix=/usr/local
      if [ $? -eq 0 ]; then
        make
        if [ $? -eq 0 ]; then
          CURRENT=`pwd`
          if [ -e $LATEST ];then
            # uninstall previous
            cd $LATEST
            sudo make uninstall
            cd $CURRENT
            rm -rf $LATEST
          fi
          sudo make install
          if [ $? -eq 0 ];then
            RET=0
            ln -s $TARGET $LATEST
            echo "$NAME OK"
          fi
        fi
      fi
    fi
    if [ ! $RET -eq 0 ];then
      rm -rf $TARGET
    fi
    rm $TAR
  fi
fi
# ===================================================
# ===================================================
# openssl
# ===================================================
# ===================================================
# 

# ubuntu has custom patches for openssl
# and a custom installation will not work properly
#

# NAME=openssl
# VERSION="1.0.2j"
# NAME_VERSION=$NAME-$VERSION
# ROOT=$SOURCES_ROOT/$NAME
# TARGET=$ROOT/$NAME_VERSION
# LATEST=$ROOT/$NAME-latest
# if [ ! -e $ROOT ];then
#   mkdir $ROOT
# fi
#
# if [ ! -e $TARGET ]; then
#
#   TAR_NAME=$NAME_VERSION.tar.gz
#   TAR=$ROOT/$TAR_NAME
#   RET=1
#   wget "https://openssl.org/source/$TAR_NAME" -O $TAR
#   if [ $? -eq 0 ];then
#     mkdir $TARGET
#     tar -xzf $TAR -C $TARGET --strip-components=1
#     if [ $? -eq 0 ];then 
#       cd $TARGET
#       ./config --prefix=/usr/local --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic
#       if [ $? -eq 0 ]; then
#         make depend
#         if [ $? -eq 0 ]; then
#           make
#           if [ $? -eq 0 ]; then
#             CURRENT=`pwd`
#             if [ -e $LATEST ];then
#               make MANDIR=/usr/share/man MANSUFFIX=ssl install && install -dv -m755 /usr/share/doc/openssl-1.0.2j  && cp -vfr doc/*     /usr/share/doc/openssl-1.0.2j
#               # uninstall previous
#               cd $LATEST
#               sudo make uninstall
#               cd $CURRENT
#               rm -rf $LATEST
#             fi
#             sudo make install
#             if [ $? -eq 0 ];then
#               RET=0
#               ln -s $TARGET $LATEST
#               echo "$NAME OK"
#             fi
#           fi
#         fi
#       fi
#     fi
#     if [ ! $RET -eq 0 ];then
#       rm -rf $TARGET
#     fi
#     rm $TAR
#   fi
# fi
# ===================================================
# ===================================================
# gpg
# ===================================================
# ===================================================
GPG_PACKAGES=(npth libgpg-error libgcrypt libksba libassuan gnupg)
GPG_VERSIONS=(1.3  1.26         1.7.6     1.3.5   2.4.3     2.1.18)
for((n=0; n<6; n++)) 
{
  NAME=${GPG_PACKAGES[$n]}
  VERSION=${GPG_VERSIONS[$n]}
  NAME_VERSION=$NAME-$VERSION
  ROOT=$SOURCES_ROOT/$NAME
  TARGET=$ROOT/$NAME_VERSION
  LATEST=$ROOT/$NAME-latest
  if [ ! -e $ROOT ];then
    mkdir $ROOT
  fi

  if [ ! -e $TARGET ]; then

    TAR_NAME=$NAME_VERSION.tar.bz2
    TAR=$ROOT/$TAR_NAME

    wget "https://www.gnupg.org/ftp/gcrypt/$NAME/$TAR_NAME" -O $TAR
    if [ $? -eq 0 ];then
      mkdir $TARGET
      tar -xf $TAR -C $TARGET --strip-components=1
      if [ $? -eq 0 ];then 
        cd $TARGET
        ./configure --prefix=/usr/local
        if [ $? -eq 0 ]; then
          make
          if [ $? -eq 0 ]; then
            CURRENT=`pwd`
            if [ -e $LATEST ];then
              # uninstall previous
              cd $LATEST
              sudo make uninstall
              cd $CURRENT
              rm -rf $LATEST
            fi
            sudo make install
            if [ $? -eq 0 ];then
              ln -s $TARGET $LATEST
              echo "$NAME OK"
            fi
          fi
        fi
      fi
      if [ ! $? -eq 0 ];then
        rm -rf $TARGET
      fi
      rm $TAR
    fi
  fi
}
# ===================================================
# ===================================================
# gdbm
# ===================================================
# ===================================================
NAME=gdbm
VERSION=1.12
NAME_VERSION=$NAME-$VERSION
ROOT=$SOURCES_ROOT/$NAME
TARGET=$ROOT/$NAME_VERSION
LATEST=$ROOT/$NAME-latest
if [ ! -e $ROOT ];then
  mkdir $ROOT
fi

if [ ! -e $TARGET ]; then

  TAR_NAME=$NAME_VERSION.tar.gz
  TAR=$ROOT/$TAR_NAME
  RET=1

  wget "ftp://ftp.gnu.org/gnu/$NAME/$TAR_NAME" -O $TAR
  if [ $? -eq 0 ];then
    mkdir $TARGET
    tar -xzf $TAR -C $TARGET --strip-components=1
    if [ $? -eq 0 ];then 
      cd $TARGET
      ./configure --prefix=/usr/local
      if [ $? -eq 0 ]; then
        make
        if [ $? -eq 0 ]; then
          CURRENT=`pwd`
          if [ -e $LATEST ];then
            # uninstall previous
            cd $LATEST
            sudo make uninstall
            cd $CURRENT
            rm -rf $LATEST
          fi
          sudo make install
          if [ $? -eq 0 ];then
            RET=0
            ln -s $TARGET $LATEST
            echo "$NAME OK"
          fi
        fi
      fi
    fi
    if [ ! $RET -eq 0 ];then
      rm -rf $TARGET
    fi
    rm $TAR
  fi
fi
# ===================================================
# ===================================================
# SASL
# ===================================================
# ===================================================
NAME=cyrus-sasl
VERSION=2.1.26
NAME_VERSION=$NAME-$VERSION
ROOT=$SOURCES_ROOT/$NAME
TARGET=$ROOT/$NAME_VERSION
LATEST=$ROOT/$NAME-latest
if [ ! -e $ROOT ];then
  mkdir $ROOT
fi

if [ ! -e $TARGET ]; then

  TAR_NAME=$NAME_VERSION.tar.gz
  TAR=$ROOT/$TAR_NAME

  PATCH_NAME=$NAME_VERSION-fixes-3.patch
  PATCH_FILE=$ROOT/$PATCH_NAME
  RET=1

  wget "ftp://ftp.cyrusimap.org/$NAME/$TAR_NAME" -O $TAR
  if [ $? -eq 0 ];then
    wget "http://www.linuxfromscratch.org/patches/blfs/svn/$PATCH_NAME" -O $PATCH_FILE
    if [ $? -eq 0 ];then
      mkdir $TARGET
      echo "------------------tar"
      tar -xzf $TAR -C $TARGET --strip-components=1
      if [ $? -eq 0 ];then 
        cd $TARGET
        echo "------------------patch"
        patch -Np1 -i $PATCH_FILE
        if [ $? -eq 0 ]; then
          echo "------------------autoreconf"
          autoreconf -fi
          if [ $? -eq 0 ]; then
            # --sysconfdir=/etc --enable-auth-sasldb --with-dbpath=/var/lib/sasl/sasldb2 --with-saslauthd=/var/run/saslauthd
            echo "------------------configure"
            ./configure --prefix=/usr/local
            if [ $? -eq 0 ]; then
              echo "------------------make"
              make
              if [ $? -eq 0 ]; then
                CURRENT=`pwd`
                if [ -e $LATEST ];then
                  # uninstall previous
                  cd $LATEST
                  sudo make uninstall
                  cd $CURRENT
                  rm -rf $LATEST
                fi
                echo "------------------make install"
                sudo make install
                if [ $? -eq 0 ];then
                  RET=0
                  ln -s $TARGET $LATEST
                  sudo ln -s /usr/local/lib/sasl2 /usr/lib/sasl2
                  sudo ln -s /usr/local/include/sasl /usr/include/sasl
                  echo "SASL OK"
                fi
              fi
            fi
          fi
        fi
      fi
    fi
    if [ ! $RET -eq 0 ];then
      rm -rf $TARGET
    fi
    rm $TAR
    rm $PATCH_FILE
  fi
fi

# ===================================================
# ===================================================
# mutt
# ===================================================
# ===================================================
NAME=mutt
MUTT_VERSION=1.7.2
MUTT=$NAME-$MUTT_VERSION
MUTT_ROOT=$SOURCES_ROOT/$NAME
TARGET=$MUTT_ROOT/$MUTT
if [ ! -e $MUTT_ROOT ];then
  mkdir $MUTT_ROOT
fi

sudo groupadd -g 34 mail
VAR_MAIL=/var/mail
if [ ! -e $VAR_MAIL ];then
  sudo mkdir $VAR_MAIL
fi
sudo chgrp -v mail $VAR_MAIL

if [ ! -e $TARGET ]; then
  MUTT_TAR_NAME=$MUTT.tar.gz
  MUTT_TAR=$MUTT_ROOT/$MUTT_TAR_NAME
  RET=1

  cd $MUTT_ROOT
  wget "ftp://ftp.mutt.org/pub/$NAME/$MUTT_TAR_NAME" -O $MUTT_TAR
  if [ $? -eq 0 ];then
    mkdir $TARGET
    tar -xzf $MUTT_TAR -C $TARGET --strip-components=1
    if [ $? -eq 0 ];then
      cd $TARGET
      ./configure --prefix=/usr --with-docdir=/usr/share/doc/$MUTT --with-openssl --with-ssl --with-slang --with-sasl --sysconfdir=/etc --enable-external-dotlock --enable-pop --enable-imap --enable-smtp --enable-hcache --enable-sidebar
      if [ $? -eq 0 ]; then
        make
        if [ $? -eq 0 ]; then
          CURRENT=`pwd`
          if [ -e $LATEST ];then
            # uninstall previous
            cd $LATEST
            sudo make uninstall
            cd $CURRENT
            rm -rf $LATEST
          fi
          sudo make install
          if [ $? -eq 0 ];then
            RET=0
            ln -s $TARGET $LATEST
            echo "MUTT OK"
          fi
        fi
      fi
    fi
  fi
  if [ ! $RET -eq 0 ];then
    rm -rf $TARGET
  fi
  rm $MUTT_TAR
fi

cd $PREV_DIR
