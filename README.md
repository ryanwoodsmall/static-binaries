# static-binaries

some static binaries for linux, maybe useful for bootstrapping, no big deal

# details

- built with/via [crosware](https://github.com/ryanwoodsmall/crosware)
- binaries are built with [musl-cross-make](https://github.com/richfelker/musl-cross-make) compilers
- static compilers are available at [musl-misc](https://github.com/ryanwoodsmall/musl-misc)
- sabotage's [netbsd-curses](https://github.com/sabotage-linux/netbsd-curses) is used to avoid external termcap/terminfo db
- can be run with proper `qemu-${ARCH}-static` setup directly on a system or in a docker container

# note!

:warning: _big stinking warning_ :warning:

- **binaries almost certainly will not be the latest version!**
- **some architectures may or may not be in sync, have all binaries available, etc.!**

these may be useful but they're a means to an end, so don't replace your userspace with these...

updates will be provided, possibly, sometime, on an "i guess i should maybe update that" basis.

# binaries

| binary | info | site |
| --- | --- | --- |
| `9p` | 9p client from plan9port | https://github.com/9fans/plan9port |
| `ag` | the silver searcher | https://geoff.greer.fm/ag/ |
| `alpine-iconv` | character encoding converter from alpine | https://gitlab.alpinelinux.org/alpine/aports/-/tree/master/main/musl |
| `bash` | gnu bash shell | https://www.gnu.org/software/bash/ |
| `brssl` | bearssl ssl/tls implementation | https://bearssl.org/ |
| `busybox` | busybox single-binary userspace | https://busybox.net/ |
| `carl` | small curl-like utility from crypto ancienne (cryanc) | https://github.com/classilla/cryanc |
| `ccache` | c/c++ compiler cache, v3.x | https://ccache.dev/ |
| `coreutils` | gnu coreutils in single-binary symlink form | https://www.gnu.org/software/coreutils/ |
| `curl` | curl http/https/ftp/etc. client | https://curl.se/ |
| `dash` | dash shell | http://gondor.apana.org.au/~herbert/dash/ |
| `dropbearmulti` | dropbear single-binary ssh/scp client/server | https://matt.ucc.asn.au/dropbear/dropbear.html |
| `entr` | entr, run arbitrary commands when a file changes | http://eradman.com/entrproject/ |
| `getconf` | system configuration utility from alpine | https://gitlab.alpinelinux.org/alpine/aports/-/tree/master/main/musl |
| `getent` | user/group information utility from alpine | https://gitlab.alpinelinux.org/alpine/aports/-/tree/master/main/musl |
| `ixpc` | 9p client/server library/utility | https://github.com/0intro/libixp |
| `jo` | json output from shell | https://github.com/jpmens/jo |
| `jq` | jq, sed/awk/grep/etc. for json | https://stedolan.github.io/jq/ |
| `less` | less console text pager | http://www.greenwoodsoftware.com/less/ |
| `links` | links console-mode web browser | http://links.twibright.com/ |
| `make` | gnu make | https://www.gnu.org/software/make/ |
| `mandoc` | man page utilty | http://mandoc.bsd.lv/ |
| `mk` | mk, from suckless 9base | https://git.suckless.org/9base/ |
| `mksh` | mirbsd korn shell | http://www.mirbsd.org/mksh.htm |
| `mlr` | miller, like jq for csv, tsv, etc. (ver 5, in c) | https://github.com/johnkerl/miller |
| `nc` | netcat | ... |
| `neatvi` | small vi-alike | https://github.com/aligrudi/neatvi |
| `patchelf` | ELF binary modification utility | https://github.com/nixos/patchelf |
| `pv` | pipe viewer | https://www.ivarch.com/programs/pv.shtml |
| `px5g` | ssl/tls key/cert generator using mbedtls, from openwrt | https://github.com/openwrt/openwrt/blob/master/package/utils/px5g-mbedtls/px5g-mbedtls.c |
| `qemacs` | small emacs-alike | https://bellard.org/qemacs/ |
| `rc` | rc shell, from suckless 9base | https://git.suckless.org/9base/ |
| `rlwrap` | readline wrapper to add history, etc., to programs without | https://github.com/hanslub42/rlwrap |
| `rsync` | incremental network file transfer program | https://rsync.samba.org/ |
| `sbase-box` | suckless sbase portable userspace in a single binary | https://git.suckless.org/sbase/ |
| `screen` | gnu screen window manager | https://www.gnu.org/software/screen/ |
| `socat` | general purpose network/socat/server/etc. connector | http://www.dest-unreach.org/socat/ |
| `sslh` | SSL/SSH multiplexer | https://github.com/yrutschle/sslh |
| `stunnel` | secure tunnel ssl/tls service wrapper/tunnel/proxy | https://www.stunnel.org/ |
| `tini` | small init for container use | https://github.com/krallin/tini |
| `tmux` | tmux terminal mutliplexer/window manager/etc. | https://github.com/tmux/tmux |
| `toybox` | toybox single-binary userspace | http://landley.net/toybox/ |
| `u9fs` | userspace 9p server | https://github.com/Plan9-Archive/u9fs |
| `ubase-box` | suckless ubase unportable tools in a single binary | https://git.suckless.org/ubase/ |
| `unrar` | rar file unarachiver | https://www.rarlab.com/rar_add.htm |
| `urlencode` | URL encoder/decorder utility from 9base | https://tools.suckless.org/9base/ |
| `x509cert` | x.509 cert generator using bearssl | https://github.com/michaelforney/x509cert |
| `xml` | xmlstartlet toolkit | http://xmlstar.sourceforge.net/ |
| `xmllint` | libxml2 linter | http://xmlsoft.org/ |
| `xz` | xz/lzma (de-)compression tool | https://tukaani.org/xz/ |

## libraries used

various libs that may or may not be used by static binaries above.

| library | info | site |
| --- | --- | --- |
| `acl` | POSIX access control lists | https://savannah.nongnu.org/projects/acl |
| `attr` | library for extended filesystem attributes | https://savannah.nongnu.org/projects/attr |
| `expat` | XML parsing library | https://libexpat.github.io/ |
| `gettext-tiny` | lightweight/stub replacements for GNU gettext | https://github.com/sabotage-linux/gettext-tiny |
| `gmp` | GNU bignum lib | https://gmplib.org/ |
| `libbsd` | BSD function/compatibility library | https://gitlab.freedesktop.org/libbsd/libbsd |
| `libcap` | linux capabilities | https://sites.google.com/site/fullycapable/ |
| `libconfig` | structured config file library | https://github.com/hyperrealm/libconfig |
| `libedit` | NetBSD editline library | https://thrysoee.dk/editline/ |
| `libev` | event loop library | https://software.schmorp.de/pkg/libev.html |
| `libevent` | event library using callbacks/signals/timeouts | https://libevent.org/ |
| `libgcrypt` | crytpograhic library from GnuPG | https://www.gnupg.org/software/libgcrypt/index.html |
| `libgpg-error` | error-handling library for GnuPG | https://www.gnupg.org/software/libgpg-error/index.html |
| `libmd` | BSD message digest library | https://gitlab.freedesktop.org/libbsd/libmd |
| `libproxprotocol` | HAproxy proxy protocol library | https://github.com/kosmas-valianos/libproxyprotocol |
| `libressl` | OpenBSD TLS/SSL library | https://www.libressl.org/ |
| `libssh2` | client-side SSH2 protocol lib | https://libssh2.org/ |
| `libxml2` | XML parsing library | https://gitlab.gnome.org/GNOME/libxml2 |
| `libxslt` | XSLT library for libxml2 | https://gitlab.gnome.org/GNOME/libxslt |
| `lz4` | compression library | https://lz4.org/ |
| `mbedtls` | embedded TLS/SSL library | https://github.com/Mbed-TLS/mbedtls |
| `musl` | small C standard library | https://musl.libc.org/ |
| `netbsd-curses` | portable NetBSD curses implementation | https://github.com/sabotage-linux/netbsd-curses |
| `nghttp2` | HTTP/2 client library | https://nghttp2.org/ |
| `oniguruma` | regular expression library | https://github.com/kkos/oniguruma |
| `openssl` | TLS/SSL library | https://openssl-library.org/ |
| `pcre` | perl compatible regular expression library | https://www.pcre.org/ |
| `readline` | library for line editing, history, completion, etc. | https://tiswww.cwru.edu/php/chet/readline/rltop.html |
| `zlib` | compression library | https://zlib.net/ |
| `zstd` | compression library | https://facebook.github.io/zstd/ |

# todo

- need to checksum/catalog binaries, sha-256 should work
- capture versions as well?
- libraries
- licenses
- add
  - `byacc`
  - `diff` (GNU)
  - `flex`
  - `gawk`
  - `git2` (`libgit2`)
  - `ggrep` (GNU)
  - `mawk`
  - `m4` (GNU)
  - `nextvi`
  - `patch` (GNU)
  - `reflex`
  - `gsed` (GNU)
  - ...
