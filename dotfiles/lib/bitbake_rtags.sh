#!/bin/bash

#use the folder name as package name
package=$(pwd | sed "s/.*\///")
#this will let vim call bitbake with correct package name
export PACKAGE=$package

#Make sure we rebuild everything with bear to capture the compilation database.
bitbake -c clean $package #Clean to make everything compile

#The tasks before compile can fail when wrapped in Bear so use normal bitbake
bitbake $package:do_prepare_recipe_sysroot
bitbake $package:do_configure

bear bitbake $package:do_compile

bitbake -c clean $package #Clean to make everything compile
