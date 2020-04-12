#!/usr/bin/env bash
set -e

DIST="./dist"
DEV_HOST="localhost:3000"
BUILD_HOST="localhost:9000"

mkdir -p "$DIST"

case "$1" in
  run)
    php -t ./pages -S "$DEV_HOST"
    ;;
  build)
    echo "Starting..."
    # start server in background process
    nohup php -t ./pages -S "$BUILD_HOST" 1>/dev/null 2>&1 &
    pid=$!
    # render every page to html
    for page in ./pages/*.php; do
      url="$BUILD_HOST/$(basename "$page")"
      dist="$DIST/$(basename "${page/%.php/.html}")"
      curl -s "$url" > "$dist"
      echo "✓ $dist"
    done
    kill -9 $pid
    echo "Done"
    ;;
  *)
    echo "Unknown command: use 'run' or 'build'"
    ;;
esac