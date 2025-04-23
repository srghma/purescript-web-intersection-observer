#!/usr/bin/env bash

set -e

export PATH="$(pwd)/node_modules/.bin:$PATH"

# Prefer user-defined CHROME_BIN, otherwise auto-detect
if [ -z "$CHROME_BIN" ]; then
  for bin in google-chrome-stable google-chrome chromium; do
    if command -v "$bin" >/dev/null 2>&1; then
      CHROME_BIN="$bin"
      break
    fi
  done
fi

if [ -z "$CHROME_BIN" ]; then
  echo "❌ Chrome executable not found. Please set CHROME_BIN or install a compatible Chrome."
  exit 1
else
  echo "✅ Using Chrome executable: $CHROME_BIN"
fi

CHROME_ARGS=(disable-web-security)

# Add --no-sandbox if running in CI
#
# Prevents error in CI
# [2702:2702:0423/033606.891092:FATAL:content/browser/zygote_host/zygote_host_impl_linux.cc:132] No usable sandbox! If you are running on Ubuntu 23.10+ or another Linux distro that has disabled unprivileged user namespaces with AppArmor, see https://chromium.googlesource.com/chromium/src/+/main/docs/security/apparmor-userns-restrictions.md. Otherwise see https://chromium.googlesource.com/chromium/src/+/main/docs/linux/suid_sandbox_development.md for more information on developing with the (older) SUID sandbox. If you want to live dangerously and need an immediate workaround, you can try using --no-sandbox.
if [ "$CI" = "true" ]; then
  echo "⚠️  CI=true detected — adding --no-sandbox to bypass Chromium AppArmor restriction"
  CHROME_ARGS+=(no-sandbox)
fi

spago bundle --module Test.Main --platform browser --outfile output/test_module.js --bundle-type module

# pnpx purs-backend-es bundle-module --main Test.Main --platform browser --to output/test_module.js

#  --visible \
# need to disable-web-security in chromium to allow cross-origin requests to fetch .js files
mocha-headless-chrome \
  --executablePath "$CHROME_BIN" \
  --timeout 999999999 \
  --file test/browser/index_module.html \
  --out output/test-output-headless.txt \
  $(for arg in "${CHROME_ARGS[@]}"; do echo --args "$arg"; done)

fail() {
    echo -e "\nTests output:\n"
    cat output/test-output-headless.txt
    exit 1
}

test_single() {
    str="$1"
    echo -n "${str}? "
    if ! grep -q "$str" output/test-output-headless.txt; then
        echo "Nope."
        fail
    else
        echo "Yes!"
    fi
}

test_single "\"passes\":1"
test_single "\"pending\":0"
test_single "\"failures\":0"
