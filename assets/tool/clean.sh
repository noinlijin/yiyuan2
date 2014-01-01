#!/bin/bash

# Get path
# - - -
x=`echo $0 | grep "^/"`
pwdp=`pwd`
if test "${x}"; then                                                                                                                         
  dir=`dirname $0`
else
  dir=`dirname $pwdp/$0`
fi
cd $dir
# - - -
# Get path

rm ../dist/*
rm -rf ../dist/.build/
rm ../Gruntfile.js
