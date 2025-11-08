#!/bin/bash
set -e

echo "Installing Flutter..."

# Install Flutter
if [ ! -d "$HOME/flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 $HOME/flutter
fi

export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$HOME/flutter/bin/cache/dart-sdk/bin"

# Configure Flutter
flutter config --no-analytics
flutter config --enable-web

# Get dependencies and build
flutter pub get
flutter build web --release --no-tree-shake-icons
