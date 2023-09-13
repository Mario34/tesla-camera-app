#!/bin/sh
# brew install create-dmg
rm -rf TeslaCamera.dmg

flutter build macos --release

create-dmg \
  --volname "TeslaCamera" \
  --app-drop-link 600 185 \
  "TeslaCamera.dmg" \
  "/Users/azhon/office/FlutterProjects/tesla_camera/build/macos/Build/Products/Release/Tesla Camera.app"