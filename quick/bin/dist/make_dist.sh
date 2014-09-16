#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="`dirname $DIR`"
DIR="`dirname $DIR`"
DIR="`dirname $DIR`"

QUICK_V3_ROOT=$DIR

echo ""
echo "QUICK_V3_ROOT = \"$QUICK_V3_ROOT\""
echo ""

WORKDIR=$QUICK_V3_ROOT/dist_workdir/dist/

if [ -d "$WORKDIR" ]; then
    rm -fr "$WORKDIR"
fi
mkdir -p "$WORKDIR"

cd "$QUICK_V3_ROOT"
git archive v3quick | tar -x -C "$WORKDIR"
rm "$WORKDIR/player3.exe"

cd quick/player/proj.mac

xcodebuild -configuration Debug \
    CODE_SIGN_IDENTITY="Developer ID Application: CocoaChina (U7E7529TA5)" \
    QUICK_V3_ROOT="$QUICK_V3_ROOT" \
    -workspace player3.xcworkspace \
    -scheme player3 \
    -archivePath ./build \
    archive

mv ./build.xcarchive/Products/Applications/player3.app "$WORKDIR"
rm -fr ./build.xcarchive

spctl -a -v "$WORKDIR/player3.app/"
echo ""
