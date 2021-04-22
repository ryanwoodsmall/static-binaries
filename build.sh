#!/usr/bin/env bash
#
# build static binaries
#
# XXX - requires docker client/server "experimental" flag for cross-compilation!
# XXX - need better tls provider stuff
# XXX - need away to turn off openssl and git recipes
# XXX - should checkout image match target arch/${karch}/${uarch}
# XXX - openrisc... man
#
# single package with ccache, download and /usr/local/tmp volumes:
#   env \
#     karch=armv7l \
#     extradockeropts="-v crosware-downloads:/usr/local/crosware/downloads -v crosware-ccache:/root/.ccache -v crosware-ult:/usr/local/tmp" \
#     recipelist=mksh \
#     binarylist=/usr/local/crosware/software/mksh/current/bin/mksh \
#       bash build.sh

set -eu
set -o pipefail

function failexit() {
  echo "${BASH_SOURCE[0]}: ${@}" 1>&2
  exit 1
}

td="$(cd $(dirname $(realpath ${BASH_SOURCE[0]})) && pwd)"
test -e "${td}/common.sh" && source "${td}/common.sh" || failexit "could not source ${td}/common.sh"
test -z "${dockerimagearch}" && failexit "do not know how to build on ${karch}/${uarch}..." || true

export archdir="${td}/${archdir}"
test -e "${archdir}" || mkdir -p "${archdir}"
test -e "${archdir}" || failexit "${archdir} does not exist"

: ${staticbinaryimage:="crosware-build-static-binaries"}
: ${cwtop:="/usr/local/crosware"}
: ${cwsw:="${cwtop}/software"}
: ${tlsprovider:="libressl"}
: ${curlprovider:="${tlsprovider}"}
: ${outputdir:="/static-binaries"}
: ${buildscript:="/build-static-binaries.sh"}
: ${extradockeropts:=""}
: ${recipelist:=""}
if [ -z "${recipelist}" ] ; then
  # git
  recipelist+=" 9base"
  recipelist+=" bash"
  recipelist+=" bearssl"
  recipelist+=" bootstrapmake"
  recipelist+=" busybox"
  recipelist+=" ccache"
  recipelist+=" coreutils"
  # curl
  recipelist+=" curl${curlprovider}"
  recipelist+=" dash"
  recipelist+=" dropbear"
  recipelist+=" jo"
  recipelist+=" jq"
  recipelist+=" less"
  recipelist+=" libxml2"
  # openssl
  recipelist+=" links"
  recipelist+=" miller"
  recipelist+=" mksh"
  recipelist+=" neatvi"
  recipelist+=" qemacs"
  recipelist+=" rlwrap"
  recipelist+=" rsync"
  # git
  recipelist+=" sbase"
  recipelist+=" screen"
  # openssl
  recipelist+=" socat"
  # openssl
  recipelist+=" stunnel"
  recipelist+=" tini"
  recipelist+=" tmux"
  recipelist+=" toybox"
  # git
  recipelist+=" ubase"
  recipelist+=" unrar"
  recipelist+=" xmlstarlet"
  recipelist+=" xz"
fi
: ${binarylist:=""}
if [ -z "${binarylist}" ] ; then
  binarylist+=" ${cwsw}/9base/current/bin/mk"
  binarylist+=" ${cwsw}/9base/current/bin/rc"
  binarylist+=" ${cwsw}/9base/current/bin/urlencode"
  binarylist+=" ${cwsw}/bash/current/bin/bash"
  binarylist+=" ${cwsw}/bearssl/current/bin/brssl"
  binarylist+=" ${cwsw}/bootstrapmake/current/bin/make"
  binarylist+=" ${cwsw}/busybox/current/bin/busybox"
  binarylist+=" ${cwsw}/ccache/current/bin/ccache"
  binarylist+=" ${cwsw}/coreutils/current/bin/coreutils"
  binarylist+=" ${cwsw}/curl${curlprovider}/current/bin/curl"
  binarylist+=" ${cwsw}/dash/current/bin/dash"
  binarylist+=" ${cwsw}/dropbear/current/bin/dropbearmulti"
  binarylist+=" ${cwsw}/jo/current/bin/jo"
  binarylist+=" ${cwsw}/jq/current/bin/jq"
  binarylist+=" ${cwsw}/less/current/bin/less"
  binarylist+=" ${cwsw}/libxml2/current/bin/xmllint"
  binarylist+=" ${cwsw}/links/current/bin/links"
  binarylist+=" ${cwsw}/miller/current/bin/mlr"
  binarylist+=" ${cwsw}/mksh/current/bin/mksh"
  binarylist+=" ${cwsw}/neatvi/current/bin/neatvi"
  binarylist+=" ${cwsw}/qemacs/current/bin/qemacs"
  binarylist+=" ${cwsw}/rlwrap/current/bin/rlwrap"
  binarylist+=" ${cwsw}/rsync/current/bin/rsync"
  binarylist+=" ${cwsw}/sbase/current/bin/sbase-box"
  binarylist+=" ${cwsw}/screen/current/bin/screen"
  binarylist+=" ${cwsw}/socat/current/bin/socat"
  binarylist+=" ${cwsw}/stunnel/current/bin/stunnel"
  binarylist+=" ${cwsw}/tini/current/sbin/tini"
  binarylist+=" ${cwsw}/tmux/current/bin/tmux"
  binarylist+=" ${cwsw}/toybox/current/bin/toybox"
  binarylist+=" ${cwsw}/ubase/current/bin/ubase-box"
  binarylist+=" ${cwsw}/unrar/current/bin/unrar"
  binarylist+=" ${cwsw}/xmlstarlet/current/bin/xml"
  binarylist+=" ${cwsw}/xz/current/bin/xz"
fi

docker build --pull --no-cache --tag ${staticbinaryimage}:${dockerimagearch} - <<EOF
FROM ${checkoutimage} as CHECKOUT
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install git \
    && mkdir -p /usr/local \
    && cd /usr/local \
    && git clone https://github.com/ryanwoodsmall/crosware.git \
    && ( cd crosware ; git gc --aggressive ) \
    && tar -C / -zcf /tmp/crosware.tar.bz2 /usr/local/crosware
FROM --platform=linux/${dockerplatformarch} ${buildimage}:${dockerimagearch}
COPY --from=CHECKOUT /tmp/crosware.tar.bz2 /tmp/
RUN uname -m \
    && cd / \
    && rm -rf ${cwtop} \
    && tar -C / -zxf /tmp/crosware.tar.bz2 \
    && cd - \
    && echo 'export CW_GIT_CMD=git${tlsprovider}' >> /etc/profile.d/crosware.sh \
    && . /etc/profile \
    && crosware install statictoolchain \
    && crosware install ccache \
    && echo '#!/usr/bin/env bash' > ${buildscript} \
    && echo '. /etc/profile' >> ${buildscript} \
    && echo 'export CW_GIT_CMD=gitlibressl' >> ${buildscript} \
    && echo 'for i in ${recipelist} ; do crosware check-installed \${i} || crosware install \${i} ; done' >> ${buildscript} \
    && echo '. /etc/profile' >> ${buildscript} \
    && echo 'echo ${recipelist} | grep -i curl && { ln -sf \$(which curl-${curlprovider} | xargs realpath) \$(which curl-${curlprovider} | xargs realpath | xargs dirname)/curl ; } || true' >> ${buildscript} \
    && echo 'for b in ${binarylist} ; do strip --strip-all \$(realpath \${b}) ; install -m 0755 \$(realpath \${b}) ${outputdir}/\$(basename \${b}) ; done' >> ${buildscript} \
    && chmod 755 ${buildscript} \
    && cat ${buildscript}
EOF

sync
until $(docker inspect ${staticbinaryimage}:${dockerimagearch} >/dev/null 2>&1) ; do
  echo "waiting for ${staticbinaryimage}:${dockerimagearch} to show up..."
  sleep 1
done
docker run --rm ${staticbinaryimage}:${dockerimagearch} uname -m
docker rm -f ${staticbinaryimage}_${dockerimagearch} >/dev/null 2>&1 || true

# --platform linux/${dockerplatformarch} \
eval docker run -it --rm \
  --name ${staticbinaryimage}_${dockerimagearch} \
  --volume ${archdir}:${outputdir} \
  ${extradockeropts} \
    ${staticbinaryimage}:${dockerimagearch} \
      bash -lc "${buildscript}"
