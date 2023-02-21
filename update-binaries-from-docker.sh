#!/usr/bin/env bash
#
# update some static binaries from our upstream docker builds
#
# XXX - max 127 layers in a dockerfile, getting close...
# XXX - probably need to move to per-arch cp/tar w/loop and COPY each arch.tar off
#

set -eu
set -o pipefail

# arrays to hold our dockerfile (generated) and programs
declare -a dockerfile
declare -a progs
# hashes for docker and binary directories
declare -A dockerarch
dockerarch['amd64']='x86_64'
dockerarch['arm64v8']='aarch64'
dockerarch['arm32v6']='armhf'
dockerarch['i386']='i686'
dockerarch['riscv64']='riscv64'
dockerarches="${!dockerarch[@]}"

# vendor/image:arch defaults, overridable in environment
: ${v:="ryanwoodsmall"}
: ${i:="crosware"}
: ${a:="${dockerarches}"}
# tag default for generated image
: ${t:="static-binaries"}

# crosware vars
export cwtop="/usr/local/crosware"
export cwsw="${cwtop}/software"
export td="${cwtop}/tmp/${t}"

# build out our list of programs to copy
progs+=( "/usr/bin/bash" )
progs+=( "/usr/bin/busybox" )
progs+=( "/usr/bin/curl" )
progs+=( "/usr/bin/toybox" )
progs+=( "${cwsw}/9base/current/bin/mk" )
progs+=( "${cwsw}/9base/current/bin/rc" )
progs+=( "${cwsw}/ag/current/bin/ag" )
progs+=( "${cwsw}/bearssl/current/bin/brssl" )
progs+=( "${cwsw}/dropbear/current/bin/dropbearmulti" )
progs+=( "${cwsw}/entr/current/bin/entr" )
progs+=( "${cwsw}/jo/current/bin/jo" )
progs+=( "${cwsw}/jq/current/bin/jq" )
progs+=( "${cwsw}/less/current/bin/less" )
progs+=( "${cwsw}/make/current/bin/make" )
progs+=( "${cwsw}/pv/current/bin/pv" )
progs+=( "${cwsw}/px5g/current/bin/px5g" )
progs+=( "${cwsw}/rlwrap/current/bin/rlwrap" )
progs+=( "${cwsw}/sbase/current/bin/sbase-box" )
progs+=( "${cwsw}/tini/current/sbin/tini" )
progs+=( "${cwsw}/ubase/current/bin/ubase-box" )
progs+=( "${cwsw}/x509cert/current/bin/x509cert" )
progs+=( "${cwsw}/xz/current/bin/xz" )

# build out a dockerfile
dockerfile=()
for arch in ${a} ; do
  dockerfile+=( "FROM ${v}/${i}:${arch} AS ${arch}" )
done
dockerfile+=( "FROM ${v}/${i}" )
dockerfile+=( "RUN rm -rf ${td} && mkdir -p ${td}" )
dockerfile+=( "WORKDIR ${td}" )
for arch in ${a} ; do
  ad="${td}/${dockerarch[${arch}]}"
  dockerfile+=( "RUN cd ${td} && rm -rf ${ad} && mkdir -p ${ad}" )
  for prog in ${progs[@]} ; do
    sn="$(basename ${prog})"
    dockerfile+=( "COPY --from=${arch} ${prog} ${ad}/${sn}" )
  done
done
dockerfile+=( "RUN find . -type f | xargs toybox file | sort" )

# kill existing image
docker image rm ${v}/${i}:${t} || true

# build our image...
for i in ${!dockerfile[@]} ; do
  echo "${dockerfile[${i}]}"
done | docker build --no-cache --pull --tag ${v}/${i}:${t} -

# and run a tar -c | tar -x to get our payload
docker run --rm ${v}/${i}:${t} tar -cf - . | tar -xvf -
