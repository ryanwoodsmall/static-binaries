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
| `bash` | gnu bash shell | https://www.gnu.org/software/bash/ |
| `brssl` | bearssl ssl/tls implementation | https://bearssl.org/ |
| `busybox` | busybox single-binary userspace | https://busybox.net/ |
| `ccache` | c/c++ compiler cache, v3.x | https://ccache.dev/ |
| `coreutils` | gnu coreutils in single-binary symlink form | https://www.gnu.org/software/coreutils/ |
| `curl` | curl http/https/ftp/etc. client | https://curl.se/ |
| `dash` | dash shell | http://gondor.apana.org.au/~herbert/dash/ |
| `dropbearmulti` | dropbear single-binary ssh/scp client/server | https://matt.ucc.asn.au/dropbear/dropbear.html |
| `jo` | json output from shell | https://github.com/jpmens/jo |
| `jq` | jq, sed/awk/grep/etc. for json | https://stedolan.github.io/jq/ |
| `less` | less console text pager | http://www.greenwoodsoftware.com/less/ |
| `links` | links console-mode web browser | http://links.twibright.com/ |
| `make` | gnu make | https://www.gnu.org/software/make/ |
| `mk` | mk, from suckless 9base | https://git.suckless.org/9base/ |
| `mksh` | mirbsd korn shell | http://www.mirbsd.org/mksh.htm |
| `mlr` | miller, like jq for csv, tsv, etc. (ver 5, in c) | https://github.com/johnkerl/miller |
| `neatvi` | small vi-alike | https://github.com/aligrudi/neatvi |
| `px5g` | ssl/tls key/cert generator using mbedtls, from openwrt | https://github.com/openwrt/openwrt/blob/master/package/utils/px5g-mbedtls/px5g-mbedtls.c |
| `qemacs` | small emacs-alike | https://bellard.org/qemacs/ |
| `rc` | rc shell, from suckless 9base | https://git.suckless.org/9base/ |
| `rlwrap` | readline wrapper to add history, etc., to programs without | https://github.com/hanslub42/rlwrap |
| `rsync` | incremental network file transfer program | https://rsync.samba.org/ |
| `sbase-box` | suckless sbase portable userspace in a single binary | https://git.suckless.org/sbase/ |
| `screen` | gnu screen window manager | https://www.gnu.org/software/screen/ |
| `socat` | general purpose network/socat/server/etc. connector | http://www.dest-unreach.org/socat/ |
| `stunnel` | secure tunnel ssl/tls service wrapper/tunnel/proxy | https://www.stunnel.org/ |
| `tini` | small init for container use | https://github.com/krallin/tini |
| `tmux` | tmux terminal mutliplexer/window manager/etc. | https://github.com/tmux/tmux |
| `toybox` | toybox single-binary userspace | http://landley.net/toybox/ |
| `ubase-box` | suckless ubase unportable tools in a single binary | https://git.suckless.org/ubase/ |
| `unrar` | rar file unarachiver | https://www.rarlab.com/rar_add.htm |
| `x509cert` | x.509 cert generator using bearssl | https://github.com/michaelforney/x509cert |
| `xml` | xmlstartlet toolkit | http://xmlstar.sourceforge.net/ |
| `xmllint` | libxml2 linter | http://xmlsoft.org/ |
| `xz` | xz/lzma (de-)compression tool | https://tukaani.org/xz/ |

# todo

- need to checksum/catalog binaries, sha-256 should work
- capture versions as well?
