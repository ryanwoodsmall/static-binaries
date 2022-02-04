#!/usr/bin/env bash
#
# create architecture-specific bundles and a megabundle with an arch extractor script
# keep the bins to a minimum for the time being, enough to bootstrap some bash stuff
#
# XXX - self-modifying bin: single binary (curl, bash, ...) bundle that can unpack itself
#   build with "--quiet-unshar"
#   fix a couple of echo lines
#     sed -i '/{echo}.*(created|removed)/s,$,>/dev/null,g' prog
#   at top of shar:
#     prog=`realpath $0`
#     cd /tmp
#   at bottom:
#     sh unshar-arch.sh >/dev/null 2>&1
#     install -m 755 `basename $prog` $prog
#     cd - >/dev/null 2>&1
#     exec $prog "$@"
#
# XXX - pack with xz/lzo/etc.? could be multi-arch shar'ed itself...
#

set -eu

: ${TS:="$(date +%Y%m%d%H%M%S)"}
: ${arches:="aarch64 armhf i686 riscv64 x86_64"}
: ${bins:="bash busybox curl sbase-box toybox ubase-box"}
: ${workdir:="$(cd $(dirname $(basename ${0})) ; pwd)"}
: ${archdir:="${workdir}"}
: ${tmpdir:="${workdir}/tmp/${TS}_${$}_${RANDOM}_static-binary_bundle"}
: ${sharextopts:=""}
: ${sharopts:="--uuencode --no-md5-digest --no-check-existing --no-i18n ${sharextopts}"}
: ${sharprefix:="${TS}"}
: ${sharext:="shar"}
: ${bundlename:="${sharprefix}-bundle.${sharext}"}
: ${bundledir:="${tmpdir}/bundle"}
: ${bundleshar:="${tmpdir}/${bundlename}"}
: ${unsharscript:="${workdir}/unshar-arch.sh"}

declare -A archbins
for a in ${arches} ; do
  archbins["${a}"]=""
done

declare -A archshars bundleshargzs
for a in ${arches} ; do
  archshars["${a}"]="${sharprefix}-${a}.${sharext}"
  bundleshargzs["${a}"]="${archshars[${a}]}.gz"
done

function failexit() {
  echo "error: ${@}" 1>&2
  exit 1
}

# prereqs
for r in gzip sha256sum shar ; do
  command -v "${r}" &>/dev/null || failexit "${r} not found"
done

# make sure we have gnu shar, not at&t or whatever
shar --version | grep -qi 'gnu sharutils' || failexit "$(command -v shar) does not appear to be shar from gnu sharutils"

# check for existence of binaries for each arch
for a in ${arches} ; do
  for b in ${bins} ; do
    f="${archdir}/${a}/${b}"
    test -e "${f}" || failexit "no ${b} binary for arch ${a} at ${f}"
    archbins["${a}"]+=" ${f}"
  done
done

# create a shar for each arch
for a in ${arches} ; do
  d="${tmpdir}/${a}"
  h="${tmpdir}/${sharprefix}-${a}.${sharext}"
  k="${h}.sha256sum"
  # make a target directory
  mkdir -p "${d}"
  test -d "${d}" || failexit "${d} does not appear to be a directory"
  # copy all the bins in
  for f in ${archbins["${a}"]} ; do
    s="$(basename ${f})"
    t="${d}/${s}"
    echo "installing ${s} for arch ${a} to ${t}"
    install -m 755 "${f}" "${t}"
  done
  # create the shar
  pushd "${d}" &>/dev/null
  echo "creating ${h}"
  shar ${sharopts} ${bins} > "${h}"
  popd &>/dev/null
  # sha256sum
  pushd "${tmpdir}" &>/dev/null
  echo "saving sha256sum to ${k}"
  sha256sum "$(basename ${h})" > "${k}"
  popd &>/dev/null
  # clean up
  echo "removing ${d}"
  rm -rf "${d}"
  echo
done

# create a mega bundle
mkdir -p "${bundledir}"
test -d "${bundledir}" || failexit "${bundledir} does not appear to be a directory"
pushd "${bundledir}" &>/dev/null
rm -f *.sha256sum
# gzip and checksum every arch
for a in ${arches} ; do
  s="${archshars[${a}]}"
  g="${s}.gz"
  k="${g}.sha256sum"
  cp -a "${tmpdir}/${s}" "${bundledir}/${s}"
  echo "compressing bundle shar ${s}"
  gzip -9 "${s}"
  echo "saving sha256sum to ${k}"
  sha256sum "${g}" > "${k}"
done
echo "copying ${unsharscript}"
install -m 755 "${unsharscript}" "$(basename ${unsharscript})"
echo "creating ${bundleshar}"
shar ${sharopts} ${bundleshargzs[@]} *.sha256sum *.sh > "${bundleshar}"
popd &>/dev/null
echo

# checksum the bundle
pushd "${tmpdir}" &>/dev/null
echo "saving sha256sum to ${bundleshar}.sha256sum"
sha256sum "$(basename ${bundleshar})" > "${bundleshar}.sha256sum"
popd &>/dev/null

# clean up
echo "removing ${bundledir}"
rm -rf "${bundledir}"
echo

echo "saved everything in ${tmpdir}"
echo
