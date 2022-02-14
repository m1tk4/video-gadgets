#!/bin/bash

VER=${1:=0.0.0}

# Create new tmp root dir
ROOTDIR=`mktemp -d`

# Fill it with files
tar xvzf dist/video-gadgets-$VER.tgz -C $ROOTDIR
install -D pkg/deb/conffiles $ROOTDIR/DEBIAN/conffiles
sed "s/^Version.*/Version: $VER/g" pkg/deb/control >$ROOTDIR/DEBIAN/control

# Build it
dpkg-deb --build --root-owner-group $ROOTDIR dist/video-gadgets_${VER}_all.deb

# Clean
rm -rf $ROOTDIR
