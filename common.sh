: ${archdir:=""}
: ${buildimage:="ryanwoodsmall/crosware"}
: ${checkoutimage:="debian"}
: ${dockerarch:="$(docker info 2>/dev/null | awk -F: '/Architecture/{print $NF}')"}
: ${dockerimagearch:=""}
: ${dockerplatformarch:=""}
: ${karch:="$(uname -m)"}
: ${uarch:="${HOSTTYPE}"}

if [[ ${karch} =~ ^aarch64 ]] ; then
  test -z "${archdir}" && archdir=aarch64 || true
  test -z "${dockerimagearch}" && dockerimagearch=arm64v8 || true
  test -z "${dockerplatformarch}" && dockerplatformarch=aarch64|| true
elif [[ ${karch} =~ ^arm ]] ; then
  test -z "${archdir}" && archdir=armhf || true
  test -z "${dockerimagearch}" && dockerimagearch=arm32v6 || true
  test -z "${dockerplatformarch}" && dockerplatformarch=armhf || true
elif [[ ${karch} =~ ^i.86 ]] ; then
  test -z "${archdir}" && archdir=i686 || true
  test -z "${dockerimagearch}" && dockerimagearch=i386 || true
  test -z "${dockerplatformarch}" && dockerplatformarch=i386 || true
elif [[ ${karch} =~ ^o ]] ; then
  test -z "${archdir}" && archdir=or1k || true
elif [[ ${karch} =~ ^riscv64 ]] ; then
  #checkoutimage="riscv64/debian:sid"
  test -z "${archdir}" && archdir=riscv64 || true
  test -z "${dockerimagearch}" && dockerimagearch=riscv64 || true
  test -z "${dockerplatformarch}" && dockerplatformarch=riscv64 || true
elif [[ ${karch} =~ ^(x86_64|amd64) ]] ; then
  test -z "${archdir}" && archdir=x86_64 || true
  test -z "${dockerimagearch}" && dockerimagearch=amd64 || true
  test -z "${dockerplatformarch}" && dockerplatformarch=amd64 || true
else
  echo "${karch} not supported"
  exit 1
fi

export buildimage
export checkoutimage
export dockerimagearch
export karch
export archdir
export uarch
