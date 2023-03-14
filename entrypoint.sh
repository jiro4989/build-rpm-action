#!/bin/sh

set -eux

INPUT_VERSION="$(echo "$INPUT_VERSION" | sed -E "s,^refs/tags/,,")"

OPTS=""
if [ ! "$INPUT_VENDOR" = "" ]; then
  OPTS="--vendor:$INPUT_VENDOR"
fi

/replacetool \
  --specfile:/template.spec \
  --summary:"$INPUT_SUMMARY" \
  --package-root:"$INPUT_PACKAGE_ROOT" \
  --package:"$INPUT_PACKAGE" \
  --version:"$INPUT_VERSION" \
  --arch:"$INPUT_ARCH" \
  --maintainer:"$INPUT_MAINTAINER" \
  --description:"$INPUT_DESC" \
  --license:"$INPUT_LICENSE" \
  --post:"$INPUT_POST" \
  "$OPTS"

readonly RPMBUILD_DIR="$HOME/rpmbuild"
readonly RPMBUILD_SOURCE_DIR="$RPMBUILD_DIR/SOURCES"
readonly RPMBUILD_SPEC_DIR="$RPMBUILD_DIR/SPECS"
(
  readonly WORKDIR="/tmp/work"
  mkdir "$WORKDIR"
  cp /template.spec "$WORKDIR"
  cp -rp "$INPUT_PACKAGE_ROOT" "$WORKDIR/$INPUT_PACKAGE"
  cd "$WORKDIR"
  tar czf tmp.tar.gz "$INPUT_PACKAGE/"

  mkdir -p "$RPMBUILD_SOURCE_DIR"
  mkdir -p "$RPMBUILD_SPEC_DIR"
  mv tmp.tar.gz "$RPMBUILD_SOURCE_DIR"

  cp -p template.spec "$RPMBUILD_SPEC_DIR"
  rpmbuild -bb "$RPMBUILD_SPEC_DIR/template.spec"
)

cp -p "$RPMBUILD_DIR/RPMS/$(uname -m)"/*.rpm .

ls -lah ./*.rpm
