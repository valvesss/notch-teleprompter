#!/bin/zsh
# Gera Teleprompter.app (sem ícone no Dock). Uso: ./build.sh && open Teleprompter.app
set -e
cd "$(dirname "$0")"
APP=Teleprompter.app
rm -rf $APP
mkdir -p $APP/Contents/MacOS $APP/Contents/Resources
swiftc -O Teleprompter.swift -o $APP/Contents/MacOS/Teleprompter -framework Cocoa -framework WebKit
cp index.html $APP/Contents/Resources/
cp Info.plist $APP/Contents/
codesign --force --sign - $APP
echo "ok: $PWD/$APP"
