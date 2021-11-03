# make install


```
% sudo make install
Password:
===--- building phase 0
/Applications/Xcode.app/Contents/Developer/usr/bin/make --no-print-directory -f ghc.mk phase=0 phase_0_builds
make[1]: Nothing to be done for `phase_0_builds'.
===--- building phase 1
/Applications/Xcode.app/Contents/Developer/usr/bin/make --no-print-directory -f ghc.mk phase=1 phase_1_builds
make[1]: Nothing to be done for `phase_1_builds'.
===--- building final phase
/Applications/Xcode.app/Contents/Developer/usr/bin/make --no-print-directory -f ghc.mk phase=final install
/usr/bin/install -c -m 755 -d "/usr/local/bin"
"rm" -f                                         "/usr/local/bin/hp2ps"  
create () { touch "$1" && chmod 755 "$1" ; } && create                                           "/usr/local/bin/hp2ps"
echo '#!/bin/sh'                                         >> "/usr/local/bin/hp2ps"
echo 'exedir="/usr/local/lib/ghc-9.3.20211103/bin"'                    >> "/usr/local/bin/hp2ps"
echo 'exeprog="hp2ps"'                          >> "/usr/local/bin/hp2ps"
echo 'executablename="$exedir/$exeprog"'           >> "/usr/local/bin/hp2ps"
echo 'datadir="/usr/local/share"'                             >> "/usr/local/bin/hp2ps"
echo 'bindir="/usr/local/bin"'                               >> "/usr/local/bin/hp2ps"
echo 'topdir="/usr/local/lib/ghc-9.3.20211103"'                               >> "/usr/local/bin/hp2ps"
cat utils/hp2ps/hp2ps.wrapper                         >> "/usr/local/bin/hp2ps"
chmod +x                                         "/usr/local/bin/hp2ps"
/usr/bin/install -c -m 755 -d "/usr/local/bin"
"rm" -f                                 "/usr/local/bin/ghci-9.3.20211103"  
create () { touch "$1" && chmod 755 "$1" ; } && create                                   "/usr/local/bin/ghci-9.3.20211103"
echo '#!/bin/sh'                                   >> "/usr/local/bin/ghci-9.3.20211103"
echo 'exec "/usr/local/bin/ghc-9.3.20211103" --interactive "$@"' >> "/usr/local/bin/ghci-9.3.20211103"
chmod +x                                 "/usr/local/bin/ghci-9.3.20211103"
"rm" -f "/usr/local/bin/ghci"  
ln -s ghci-9.3.20211103 "/usr/local/bin/ghci"
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/include"
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/include/." && /usr/bin/install -c -m 644  rts/include/./*.h "/usr/local/lib/ghc-9.3.20211103/include/./" &&   /usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/include/rts" && /usr/bin/install -c -m 644  rts/include/rts/*.h "/usr/local/lib/ghc-9.3.20211103/include/rts/" &&   /usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/include/rts/prof" && /usr/bin/install -c -m 644  rts/include/rts/prof/*.h "/usr/local/lib/ghc-9.3.20211103/include/rts/prof/" &&   /usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/include/rts/storage" && /usr/bin/install -c -m 644  rts/include/rts/storage/*.h "/usr/local/lib/ghc-9.3.20211103/include/rts/storage/" &&   /usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/include/stg" && /usr/bin/install -c -m 644  rts/include/stg/*.h "/usr/local/lib/ghc-9.3.20211103/include/stg/" &&  true
/usr/bin/install -c -m 644  \
		rts/dist-install/build/include/ghcautoconf.h rts/dist-install/build/include/ghcplatform.h rts/dist-install/build/include/ghcversion.h \
		rts/dist-install/build/include/DerivedConstants.h \
		"/usr/local/lib/ghc-9.3.20211103/include/"
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/include"
/usr/bin/install -c -m 644  rts/dist-install/build/ffi.h rts/dist-install/build/ffitarget.h "/usr/local/lib/ghc-9.3.20211103/include/"
/usr/bin/install -c -m 755 -d "/usr/local/bin"
"rm" -f                                         "/usr/local/bin/haddock-ghc-9.3.20211103"  
create () { touch "$1" && chmod 755 "$1" ; } && create                                           "/usr/local/bin/haddock-ghc-9.3.20211103"
echo '#!/bin/sh'                                         >> "/usr/local/bin/haddock-ghc-9.3.20211103"
echo 'exedir="/usr/local/lib/ghc-9.3.20211103/bin"'                    >> "/usr/local/bin/haddock-ghc-9.3.20211103"
echo 'exeprog="haddock"'                          >> "/usr/local/bin/haddock-ghc-9.3.20211103"
echo 'executablename="$exedir/$exeprog"'           >> "/usr/local/bin/haddock-ghc-9.3.20211103"
echo 'datadir="/usr/local/share"'                             >> "/usr/local/bin/haddock-ghc-9.3.20211103"
echo 'bindir="/usr/local/bin"'                               >> "/usr/local/bin/haddock-ghc-9.3.20211103"
echo 'topdir="/usr/local/lib/ghc-9.3.20211103"'                               >> "/usr/local/bin/haddock-ghc-9.3.20211103"
cat utils/haddock/haddock.wrapper                         >> "/usr/local/bin/haddock-ghc-9.3.20211103"
chmod +x                                         "/usr/local/bin/haddock-ghc-9.3.20211103"
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/html/"  
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/html/Classic.theme/"  
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/html/Linuwial.std-theme/"  
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/html/Ocean.theme/"  
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/latex/"
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/quick-jump.min.js "/usr/local/lib/ghc-9.3.20211103/html/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/quick-jump.css "/usr/local/lib/ghc-9.3.20211103/html/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/haddock-bundle.min.js "/usr/local/lib/ghc-9.3.20211103/html/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Classic.theme/haskell_icon.gif "/usr/local/lib/ghc-9.3.20211103/html/Classic.theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Classic.theme/minus.gif "/usr/local/lib/ghc-9.3.20211103/html/Classic.theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Classic.theme/plus.gif "/usr/local/lib/ghc-9.3.20211103/html/Classic.theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Classic.theme/xhaddock.css "/usr/local/lib/ghc-9.3.20211103/html/Classic.theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Ocean.theme/hslogo-16.png "/usr/local/lib/ghc-9.3.20211103/html/Ocean.theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Ocean.theme/minus.gif "/usr/local/lib/ghc-9.3.20211103/html/Ocean.theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Ocean.theme/ocean.css "/usr/local/lib/ghc-9.3.20211103/html/Ocean.theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Ocean.theme/plus.gif "/usr/local/lib/ghc-9.3.20211103/html/Ocean.theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Ocean.theme/synopsis.png "/usr/local/lib/ghc-9.3.20211103/html/Ocean.theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Linuwial.std-theme/linuwial.css "/usr/local/lib/ghc-9.3.20211103/html/Linuwial.std-theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/Linuwial.std-theme/synopsis.png "/usr/local/lib/ghc-9.3.20211103/html/Linuwial.std-theme/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/solarized.css "/usr/local/lib/ghc-9.3.20211103/html/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/html/highlight.js "/usr/local/lib/ghc-9.3.20211103/html/"  
/usr/bin/install -c -m 644  utils/haddock/haddock-api/resources/latex/haddock.sty "/usr/local/lib/ghc-9.3.20211103/latex/"
"rm" -f "/usr/local/bin/haddock"  
ln -s haddock-ghc-9.3.20211103 "/usr/local/bin/haddock"
/usr/bin/install -c -m 755 -d "/usr/local/bin"
"rm" -f                                         "/usr/local/bin/hsc2hs"  
create () { touch "$1" && chmod 755 "$1" ; } && create                                           "/usr/local/bin/hsc2hs"
echo '#!/bin/sh'                                         >> "/usr/local/bin/hsc2hs"
echo 'exedir="/usr/local/lib/ghc-9.3.20211103/bin"'                    >> "/usr/local/bin/hsc2hs"
echo 'exeprog="hsc2hs"'                          >> "/usr/local/bin/hsc2hs"
echo 'executablename="$exedir/$exeprog"'           >> "/usr/local/bin/hsc2hs"
echo 'datadir="/usr/local/share"'                             >> "/usr/local/bin/hsc2hs"
echo 'bindir="/usr/local/bin"'                               >> "/usr/local/bin/hsc2hs"
echo 'topdir="/usr/local/lib/ghc-9.3.20211103"'                               >> "/usr/local/bin/hsc2hs"
echo 'HSC2HS_EXTRA="--cflag=--target=arm64-apple-darwin --lflag=--target=arm64-apple-darwin"' >> "/usr/local/bin/hsc2hs"
cat utils/hsc2hs/hsc2hs.wrapper                         >> "/usr/local/bin/hsc2hs"
chmod +x                                         "/usr/local/bin/hsc2hs"
/usr/bin/install -c -m 644  utils/hsc2hs/data/template-hsc.h "/usr/local/lib/ghc-9.3.20211103"
/usr/bin/install -c -m 755 -d "/usr/local/bin"
"rm" -f                                         "/usr/local/bin/ghc-pkg-9.3.20211103"  
create () { touch "$1" && chmod 755 "$1" ; } && create                                           "/usr/local/bin/ghc-pkg-9.3.20211103"
echo '#!/bin/sh'                                         >> "/usr/local/bin/ghc-pkg-9.3.20211103"
echo 'exedir="/usr/local/lib/ghc-9.3.20211103/bin"'                    >> "/usr/local/bin/ghc-pkg-9.3.20211103"
echo 'exeprog="ghc-pkg"'                          >> "/usr/local/bin/ghc-pkg-9.3.20211103"
echo 'executablename="$exedir/$exeprog"'           >> "/usr/local/bin/ghc-pkg-9.3.20211103"
echo 'datadir="/usr/local/share"'                             >> "/usr/local/bin/ghc-pkg-9.3.20211103"
echo 'bindir="/usr/local/bin"'                               >> "/usr/local/bin/ghc-pkg-9.3.20211103"
echo 'topdir="/usr/local/lib/ghc-9.3.20211103"'                               >> "/usr/local/bin/ghc-pkg-9.3.20211103"
cat utils/ghc-pkg/ghc-pkg.wrapper                         >> "/usr/local/bin/ghc-pkg-9.3.20211103"
chmod +x                                         "/usr/local/bin/ghc-pkg-9.3.20211103"
/usr/bin/install -c -m 755 -d "/usr/local/bin"
"rm" -f "/usr/local/bin/ghc-pkg"  
ln -s ghc-pkg-9.3.20211103 "/usr/local/bin/ghc-pkg"
/usr/bin/install -c -m 755 -d "/usr/local/bin"
"rm" -f                                         "/usr/local/bin/hpc"  
create () { touch "$1" && chmod 755 "$1" ; } && create                                           "/usr/local/bin/hpc"
echo '#!/bin/sh'                                         >> "/usr/local/bin/hpc"
echo 'exedir="/usr/local/lib/ghc-9.3.20211103/bin"'                    >> "/usr/local/bin/hpc"
echo 'exeprog="hpc"'                          >> "/usr/local/bin/hpc"
echo 'executablename="$exedir/$exeprog"'           >> "/usr/local/bin/hpc"
echo 'datadir="/usr/local/share"'                             >> "/usr/local/bin/hpc"
echo 'bindir="/usr/local/bin"'                               >> "/usr/local/bin/hpc"
echo 'topdir="/usr/local/lib/ghc-9.3.20211103"'                               >> "/usr/local/bin/hpc"
cat utils/hpc/hpc.wrapper                         >> "/usr/local/bin/hpc"
chmod +x                                         "/usr/local/bin/hpc"
/usr/bin/install -c -m 755 -d "/usr/local/bin"
"rm" -f                                         "/usr/local/bin/runghc-9.3.20211103"  
create () { touch "$1" && chmod 755 "$1" ; } && create                                           "/usr/local/bin/runghc-9.3.20211103"
echo '#!/bin/sh'                                         >> "/usr/local/bin/runghc-9.3.20211103"
echo 'exedir="/usr/local/lib/ghc-9.3.20211103/bin"'                    >> "/usr/local/bin/runghc-9.3.20211103"
echo 'exeprog="runghc"'                          >> "/usr/local/bin/runghc-9.3.20211103"
echo 'executablename="$exedir/$exeprog"'           >> "/usr/local/bin/runghc-9.3.20211103"
echo 'datadir="/usr/local/share"'                             >> "/usr/local/bin/runghc-9.3.20211103"
echo 'bindir="/usr/local/bin"'                               >> "/usr/local/bin/runghc-9.3.20211103"
echo 'topdir="/usr/local/lib/ghc-9.3.20211103"'                               >> "/usr/local/bin/runghc-9.3.20211103"
echo 'ghcprog="ghc-9.3.20211103"' >> "/usr/local/bin/runghc-9.3.20211103"
cat utils/runghc/runghc.wrapper                         >> "/usr/local/bin/runghc-9.3.20211103"
chmod +x                                         "/usr/local/bin/runghc-9.3.20211103"
"rm" -f "/usr/local/bin/runhaskell"  
ln -s runghc "/usr/local/bin/runhaskell"
"rm" -f "/usr/local/bin/runghc"  
ln -s runghc-9.3.20211103 "/usr/local/bin/runghc"
/usr/bin/install -c -m 755 -d "/usr/local/bin"
"rm" -f                                         "/usr/local/bin/ghc-9.3.20211103"  
create () { touch "$1" && chmod 755 "$1" ; } && create                                           "/usr/local/bin/ghc-9.3.20211103"
echo '#!/bin/sh'                                         >> "/usr/local/bin/ghc-9.3.20211103"
echo 'exedir="/usr/local/lib/ghc-9.3.20211103/bin"'                    >> "/usr/local/bin/ghc-9.3.20211103"
echo 'exeprog="ghc-stage2"'                          >> "/usr/local/bin/ghc-9.3.20211103"
echo 'executablename="$exedir/$exeprog"'           >> "/usr/local/bin/ghc-9.3.20211103"
echo 'datadir="/usr/local/share"'                             >> "/usr/local/bin/ghc-9.3.20211103"
echo 'bindir="/usr/local/bin"'                               >> "/usr/local/bin/ghc-9.3.20211103"
echo 'topdir="/usr/local/lib/ghc-9.3.20211103"'                               >> "/usr/local/bin/ghc-9.3.20211103"
echo 'executablename="$exedir/ghc"' >> "/usr/local/bin/ghc-9.3.20211103"
cat ghc/ghc.wrapper                         >> "/usr/local/bin/ghc-9.3.20211103"
chmod +x                                         "/usr/local/bin/ghc-9.3.20211103"
"rm" -f "/usr/local/bin/ghc"  
ln -s ghc-9.3.20211103 "/usr/local/bin/ghc"
if [ -e "/usr/bin/xattr" ]; then "/usr/bin/xattr" -c -r .; fi
#  driver/ghc-usage.txt driver/ghci-usage.txt rts/dist-install/build/include/settings llvm-targets llvm-passes = libraries to install
#  "/usr/local/lib/ghc-9.3.20211103" = directory to install to
#
# The .dll case calls STRIP_CMD explicitly, instead of `install -s`, because
# on Win64, "install -s" calls a strip that doesn't understand 64bit binaries.
# For some reason, this means the DLLs end up non-executable, which means
# executables that use them just segfault.
/usr/bin/install -c -m 755 -d  "/usr/local/lib/ghc-9.3.20211103"
for i in  driver/ghc-usage.txt driver/ghci-usage.txt rts/dist-install/build/include/settings llvm-targets llvm-passes; do case $i in *.a) /usr/bin/install -c -m 644  $i  "/usr/local/lib/ghc-9.3.20211103"; ranlib  "/usr/local/lib/ghc-9.3.20211103"/`basename $i` ;; *.dll) /usr/bin/install -c -m 755  $i  "/usr/local/lib/ghc-9.3.20211103" ; strip  "/usr/local/lib/ghc-9.3.20211103"/`basename $i` ;; *.so) /usr/bin/install -c -m 755  $i  "/usr/local/lib/ghc-9.3.20211103" ;; *.dylib) /usr/bin/install -c -m 755  $i  "/usr/local/lib/ghc-9.3.20211103";; *) /usr/bin/install -c -m 644  $i  "/usr/local/lib/ghc-9.3.20211103"; esac; done
cc -E -undef -traditional -Wno-invalid-pp-token -Wno-unicode -Wno-trigraphs -P -DINSTALLING -DLIB_DIR='"/usr/local/lib/ghc-9.3.20211103"' -DINCLUDE_DIR='"/usr/local/lib/ghc-9.3.20211103/include"' -DFFI_INCLUDE_DIR= -DFFI_LIB_DIR= '-DFFI_LIB="Cffi"' -DLIBDW_INCLUDE_DIR= -DLIBDW_LIB_DIR= -Irts/include -Irts/dist-install/build/include -Irts/dist-install/build/include -x c rts/package.conf.in -o rts/dist-install/package.conf.install.raw
grep -v '^#pragma GCC' rts/dist-install/package.conf.install.raw | sed -e 's/""//g' -e 's/:[ 	]*,/: /g' >rts/dist-install/package.conf.install
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/bin"
for i in utils/unlit/dist-install/build/tmp/unlit utils/hp2ps/dist-install/build/tmp/hp2ps utils/hp2ps/dist-install/build/tmp/hp2ps utils/haddock/dist/build/tmp/haddock utils/haddock/dist/build/tmp/haddock utils/hsc2hs/dist-install/build/tmp/hsc2hs utils/hsc2hs/dist-install/build/tmp/hsc2hs utils/ghc-pkg/dist-install/build/tmp/ghc-pkg utils/ghc-pkg/dist-install/build/tmp/ghc-pkg utils/hpc/dist-install/build/tmp/hpc utils/hpc/dist-install/build/tmp/hpc utils/runghc/dist-install/build/tmp/runghc utils/runghc/dist-install/build/tmp/runghc ghc/stage2/build/tmp/ghc-stage2 ghc/stage2/build/tmp/ghc-stage2 utils/iserv/stage2/build/tmp/ghc-iserv utils/iserv/stage2_p/build/tmp/ghc-iserv-prof utils/iserv/stage2_dyn/build/tmp/ghc-iserv-dyn; do \
		/usr/bin/install -c -m 755  $i "/usr/local/lib/ghc-9.3.20211103/bin"; \
	done
"mv" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-stage2" "/usr/local/lib/ghc-9.3.20211103/bin/ghc"
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103"
"rm" -rf "/usr/local/lib/ghc-9.3.20211103/package.conf.d"  
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/package.conf.d"
/usr/bin/install -c -m 755 -d "/usr/local/lib/ghc-9.3.20211103/rts"
#  rts/dist-install/build/libHSrts.a rts/dist-install/build/libHSrts_p.a rts/dist-install/build/libHSrts-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_l.a rts/dist-install/build/libHSrts_debug.a rts/dist-install/build/libHSrts_thr.a rts/dist-install/build/libHSrts_thr_debug.a rts/dist-install/build/libHSrts_thr_l.a rts/dist-install/build/libHSrts_thr_p.a rts/dist-install/build/libHSrts_debug-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_thr-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_thr_debug-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_l-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_thr_l-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_thr_debug_p.a rts/dist-install/build/libHSrts_debug_p.a rts/dist-install/build/libffi.dylib rts/dist-install/build/libCffi.a rts/dist-install/build/libCffi_p.a rts/dist-install/build/libCffi_l.a rts/dist-install/build/libCffi_debug.a rts/dist-install/build/libCffi_thr.a rts/dist-install/build/libCffi_thr_debug.a rts/dist-install/build/libCffi_thr_l.a rts/dist-install/build/libCffi_thr_p.a rts/dist-install/build/libCffi_thr_debug_p.a rts/dist-install/build/libCffi_debug_p.a = libraries to install
#  "/usr/local/lib/ghc-9.3.20211103/rts" = directory to install to
#
# The .dll case calls STRIP_CMD explicitly, instead of `install -s`, because
# on Win64, "install -s" calls a strip that doesn't understand 64bit binaries.
# For some reason, this means the DLLs end up non-executable, which means
# executables that use them just segfault.
/usr/bin/install -c -m 755 -d  "/usr/local/lib/ghc-9.3.20211103/rts"
for i in  rts/dist-install/build/libHSrts.a rts/dist-install/build/libHSrts_p.a rts/dist-install/build/libHSrts-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_l.a rts/dist-install/build/libHSrts_debug.a rts/dist-install/build/libHSrts_thr.a rts/dist-install/build/libHSrts_thr_debug.a rts/dist-install/build/libHSrts_thr_l.a rts/dist-install/build/libHSrts_thr_p.a rts/dist-install/build/libHSrts_debug-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_thr-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_thr_debug-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_l-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_thr_l-ghc9.3.20211103.dylib rts/dist-install/build/libHSrts_thr_debug_p.a rts/dist-install/build/libHSrts_debug_p.a rts/dist-install/build/libffi.dylib rts/dist-install/build/libCffi.a rts/dist-install/build/libCffi_p.a rts/dist-install/build/libCffi_l.a rts/dist-install/build/libCffi_debug.a rts/dist-install/build/libCffi_thr.a rts/dist-install/build/libCffi_thr_debug.a rts/dist-install/build/libCffi_thr_l.a rts/dist-install/build/libCffi_thr_p.a rts/dist-install/build/libCffi_thr_debug_p.a rts/dist-install/build/libCffi_debug_p.a; do case $i in *.a) /usr/bin/install -c -m 644  $i  "/usr/local/lib/ghc-9.3.20211103/rts"; ranlib  "/usr/local/lib/ghc-9.3.20211103/rts"/`basename $i` ;; *.dll) /usr/bin/install -c -m 755  $i  "/usr/local/lib/ghc-9.3.20211103/rts" ; strip  "/usr/local/lib/ghc-9.3.20211103/rts"/`basename $i` ;; *.so) /usr/bin/install -c -m 755  $i  "/usr/local/lib/ghc-9.3.20211103/rts" ;; *.dylib) /usr/bin/install -c -m 755  $i  "/usr/local/lib/ghc-9.3.20211103/rts";; *) /usr/bin/install -c -m 644  $i  "/usr/local/lib/ghc-9.3.20211103/rts"; esac; done
"inplace/bin/ghc-cabal" copy libraries/ghc-prim dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/ghc-prim-0.8.0
"inplace/bin/ghc-cabal" copy libraries/ghc-bignum dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/ghc-bignum-1.2
"inplace/bin/ghc-cabal" copy libraries/base dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/base-4.16.0.0
"inplace/bin/ghc-cabal" copy libraries/filepath dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/filepath-1.4.2.1
"inplace/bin/ghc-cabal" copy libraries/array dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/array-0.5.4.0
"inplace/bin/ghc-cabal" copy libraries/deepseq dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/deepseq-1.4.4.0
"inplace/bin/ghc-cabal" copy libraries/bytestring dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/bytestring-0.11.1.0
"inplace/bin/ghc-cabal" copy libraries/containers/containers dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/containers-0.6.4.1
"inplace/bin/ghc-cabal" copy libraries/time dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/time-1.11.1.1
"inplace/bin/ghc-cabal" copy libraries/unix dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/unix-2.7.2.2
"inplace/bin/ghc-cabal" copy libraries/directory dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/directory-1.3.6.1
"inplace/bin/ghc-cabal" copy libraries/process dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/process-1.6.13.1
"inplace/bin/ghc-cabal" copy libraries/hpc dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/hpc-0.6.1.0
"inplace/bin/ghc-cabal" copy libraries/pretty dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/pretty-1.1.3.6
"inplace/bin/ghc-cabal" copy libraries/binary dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/binary-0.8.8.0
"inplace/bin/ghc-cabal" copy libraries/transformers dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/transformers-0.5.6.2
"inplace/bin/ghc-cabal" copy libraries/mtl dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/mtl-2.2.2
"inplace/bin/ghc-cabal" copy libraries/ghc-boot-th dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/ghc-boot-th-9.3
"inplace/bin/ghc-cabal" copy libraries/ghc-boot dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/ghc-boot-9.3
"inplace/bin/ghc-cabal" copy libraries/template-haskell dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/template-haskell-2.18.0.0
"inplace/bin/ghc-cabal" copy libraries/text dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/text-1.2.4.2
"inplace/bin/ghc-cabal" copy libraries/parsec dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/parsec-3.1.14.0
"inplace/bin/ghc-cabal" copy libraries/Cabal/Cabal dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/Cabal-3.5.0.0
"inplace/bin/ghc-cabal" copy libraries/ghc-compact dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/ghc-compact-0.1.0.0
"inplace/bin/ghc-cabal" copy libraries/ghc-heap dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/ghc-heap-9.3
"inplace/bin/ghc-cabal" copy libraries/integer-gmp dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/integer-gmp-1.1
"inplace/bin/ghc-cabal" copy libraries/xhtml dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/xhtml-3000.2.2.1
"inplace/bin/ghc-cabal" copy libraries/terminfo dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/terminfo-0.4.1.5
"inplace/bin/ghc-cabal" copy libraries/stm dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/stm-2.5.0.0
"inplace/bin/ghc-cabal" copy libraries/exceptions dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/exceptions-0.10.4
"inplace/bin/ghc-cabal" copy libraries/haskeline dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/haskeline-0.8.2
"inplace/bin/ghc-cabal" copy libraries/ghci dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/ghci-9.3
"inplace/bin/ghc-cabal" copy libraries/libiserv dist-install "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'  
Installing library in /usr/local/lib/ghc-9.3.20211103/libiserv-9.3
"inplace/bin/ghc-cabal" copy compiler stage2 "strip" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' 'v p dyn'
Installing library in /usr/local/lib/ghc-9.3.20211103/ghc-9.3
"/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" --force --global-package-db "/usr/local/lib/ghc-9.3.20211103/package.conf.d" update rts/dist-install/package.conf.install
Reading package info from "rts/dist-install/package.conf.install" ... done.
"inplace/bin/ghc-cabal" register libraries/ghc-prim dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for ghc-prim-0.8.0..
"inplace/bin/ghc-cabal" register libraries/ghc-bignum dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for ghc-bignum-1.2..
"inplace/bin/ghc-cabal" register libraries/base dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for base-4.16.0.0..
"inplace/bin/ghc-cabal" register libraries/filepath dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for filepath-1.4.2.1..
"inplace/bin/ghc-cabal" register libraries/array dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for array-0.5.4.0..
"inplace/bin/ghc-cabal" register libraries/deepseq dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for deepseq-1.4.4.0..
"inplace/bin/ghc-cabal" register libraries/bytestring dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for bytestring-0.11.1.0..
"inplace/bin/ghc-cabal" register libraries/containers/containers dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for containers-0.6.4.1..
"inplace/bin/ghc-cabal" register libraries/time dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for time-1.11.1.1..
"inplace/bin/ghc-cabal" register libraries/unix dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for unix-2.7.2.2..
"inplace/bin/ghc-cabal" register libraries/directory dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for directory-1.3.6.1..
"inplace/bin/ghc-cabal" register libraries/process dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for process-1.6.13.1..
"inplace/bin/ghc-cabal" register libraries/hpc dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for hpc-0.6.1.0..
"inplace/bin/ghc-cabal" register libraries/pretty dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for pretty-1.1.3.6..
"inplace/bin/ghc-cabal" register libraries/binary dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for binary-0.8.8.0..
"inplace/bin/ghc-cabal" register libraries/transformers dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for transformers-0.5.6.2..
"inplace/bin/ghc-cabal" register libraries/mtl dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for mtl-2.2.2..
"inplace/bin/ghc-cabal" register libraries/ghc-boot-th dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for ghc-boot-th-9.3..
"inplace/bin/ghc-cabal" register libraries/ghc-boot dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for ghc-boot-9.3..
"inplace/bin/ghc-cabal" register libraries/template-haskell dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for template-haskell-2.18.0.0..
"inplace/bin/ghc-cabal" register libraries/text dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for text-1.2.4.2..
"inplace/bin/ghc-cabal" register libraries/parsec dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for parsec-3.1.14.0..
"inplace/bin/ghc-cabal" register libraries/Cabal/Cabal dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for Cabal-3.5.0.0..
"inplace/bin/ghc-cabal" register libraries/ghc-compact dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for ghc-compact-0.1.0.0..
"inplace/bin/ghc-cabal" register libraries/ghc-heap dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for ghc-heap-9.3..
"inplace/bin/ghc-cabal" register libraries/integer-gmp dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for integer-gmp-1.1..
"inplace/bin/ghc-cabal" register libraries/xhtml dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for xhtml-3000.2.2.1..
"inplace/bin/ghc-cabal" register libraries/terminfo dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for terminfo-0.4.1.5..
"inplace/bin/ghc-cabal" register libraries/stm dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for stm-2.5.0.0..
"inplace/bin/ghc-cabal" register libraries/exceptions dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for exceptions-0.10.4..
"inplace/bin/ghc-cabal" register libraries/haskeline dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for haskeline-0.8.2..
"inplace/bin/ghc-cabal" register libraries/ghci dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for ghci-9.3..
"inplace/bin/ghc-cabal" register libraries/libiserv dist-install "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO  
Registering library for libiserv-9.3..
"inplace/bin/ghc-cabal" register compiler stage2 "/usr/local/lib/ghc-9.3.20211103/bin/ghc" "/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" "/usr/local/lib/ghc-9.3.20211103" '' '/usr/local' '/usr/local/lib/ghc-9.3.20211103' '/usr/local/share/doc/ghc-9.3.20211103/html/libraries' NO
Registering library for ghc-9.3..
for f in '/usr/local/lib/ghc-9.3.20211103/package.conf.d'/*; do create () { touch "$1" && chmod 644 "$1" ; } && create "$f"; done
"/usr/local/lib/ghc-9.3.20211103/bin/ghc-pkg" --global-package-db "/usr/local/lib/ghc-9.3.20211103/package.conf.d" recache
/usr/bin/install -c -m 755 -d "/usr/local/bin"
/usr/bin/install -c -m 755 -d "/usr/local/share/doc/ghc-9.3.20211103"
/usr/bin/install -c -m 755 -d "/usr/local/share/doc/ghc-9.3.20211103/html"
/usr/bin/install -c -m 644  docs/index.html "/usr/local/share/doc/ghc-9.3.20211103/html"
/usr/bin/install -c -m 755 -d "/usr/local/share/doc/ghc-9.3.20211103/html/libraries"
for i in libraries/dist-haddock/*; do \
		/usr/bin/install -c -m 644  $i "/usr/local/share/doc/ghc-9.3.20211103/html/libraries/"; \
	done
/usr/bin/install -c -m 644  libraries/prologue.txt "/usr/local/share/doc/ghc-9.3.20211103/html/libraries/"
/usr/bin/install -c -m 755  libraries/gen_contents_index "/usr/local/share/doc/ghc-9.3.20211103/html/libraries/"
```
