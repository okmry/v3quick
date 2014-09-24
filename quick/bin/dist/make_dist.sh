#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="`dirname $DIR`"
DIR="`dirname $DIR`"
DIR="`dirname $DIR`"

QUICK_V3_ROOT=$DIR
VERSION=`cat $QUICK_V3_ROOT/VERSION`
WORKDIR=$QUICK_V3_ROOT/dist_workdir/quick-$VERSION
CERT="CocoaChina (U7E7529TA5)"

echo ""
echo "QUICK_V3_ROOT = \"$QUICK_V3_ROOT\""
echo "VERSION = \"$VERSION\""
echo "WORKDIR = \"$WORKDIR\""
echo ""

if [ -d "$WORKDIR" ]; then
    rm -fr "$WORKDIR"
fi
mkdir -p "$WORKDIR"

cd "$QUICK_V3_ROOT"
git archive v3quick | tar -x -C "$WORKDIR"

cd quick/player/proj.mac

cp -rf player3.xcodeproj/xcuserdata/USER.xcuserdatad/ player3.xcodeproj/xcuserdata/$USER.xcuserdatad/
xcodebuild -configuration Debug \
    CODE_SIGN_IDENTITY="Developer ID Application: $CERT" \
    QUICK_V3_ROOT="$QUICK_V3_ROOT" \
    -workspace player3.xcworkspace \
    -scheme player3 \
    -archivePath ./build \
    archive

mv ./build.xcarchive/Products/Applications/player3.app "$WORKDIR"
rm -fr ./build.xcarchive

spctl -a -v "$WORKDIR/player3.app/"
echo ""
echo "<QUICK>/player3.app/: accepted"
echo "source=Developer ID"
echo "override=security disabled"
echo ""

rm -fr $QUICK_V3_ROOT/quick/bin/dist/build/
packagesbuild -v $QUICK_V3_ROOT/quick/bin/dist/quickcocos2dx.pkgproj

du -h -d 1 $QUICK_V3_ROOT/quick/bin/dist/build
echo ""

SRC_PKG=$QUICK_V3_ROOT/quick/bin/dist/build/quick-cocos2d-x-$VERSION.mpkg
DEST_PKG=$QUICK_V3_ROOT/quick/bin/dist/build/Install.mpkg
sudo productsign --sign "Developer ID Installer: $CERT" "$SRC_PKG/Contents/Packages/quickcocos2dx.pkg" "$DEST_PKG/Contents/Packages/quickcocos2dx.pkg"
echo ""
sudo productsign --sign "Developer ID Application: $CERT" "$SRC_PKG" "$DEST_PKG"
echo ""
