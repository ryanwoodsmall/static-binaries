#!/bin/sh
#
# runs the proper arch shar from a bundle
# try to stay at least a little posix-y/simple
# want this to run under busybox ash, dash, ksh variants, etc.
#
# XXX - still need to symlink busybox/toybox/etc. applets
#

failexit() {
  echo "$@"
  exit 1
}

command -v gzip >/dev/null 2>&1
test $? -eq 0 || failexit "no gzip"

if [ -z "$ARCH" ] ; then
  uname -m | grep ^aarch64 >/dev/null 2>&1 && ARCH="aarch64" || true
  uname -m | grep ^arm >/dev/null 2>&1 && ARCH="armhf" || true
  uname -m | grep ^i >/dev/null 2>&1 && ARCH="i686" || true
  uname -m | grep ^x86_64 >/dev/null 2>&1 && ARCH="x86_64" || true
  uname -m | grep ^riscv64 >/dev/null 2>&1 && ARCH="riscv64" || true
fi

test -z "$ARCH" && failexit "no known arch detected"

echo "arch $ARCH detected"

SHARGZ=`ls *.shar.gz 2>/dev/null | grep $ARCH | sort -n | tail -1`

test -z "$SHARGZ" && failexit "no .shar.gz found for $ARCH"

echo "shar $SHARGZ detected"

command -v sha256sum >/dev/null 2>&1
if [ $? -eq 0 ] ; then
  if [ -e $SHARGZ.sha256sum ] ; then
    sha256sum -c $SHARGZ.sha256sum || failexit "$SHARGZ did not match stored sha256sum"
  else
    echo "no .sha256sum found for $SHARGZ, not checksumming"
  fi
fi

echo "extracting $SHAR"
gzip -dc $SHARGZ | sh

echo done
echo
