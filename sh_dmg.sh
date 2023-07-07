#!/bin/sh
# brew install create-dmg
rm -rf TeslaCamera.dmg

flutter build macos --release

create-dmg \
  --volname "TeslaCamera" \
  "TeslaCamera.dmg" \
  "/Users/azhon/office/FlutterProjects/tesla_camera/build/macos/Build/Products/Release/Tesla Camera.app"