# On Mac


## using 8.10.7

```
wget https://downloads.haskell.org/ghc/8.10.7/ghc-8.10.7-src.tar.xz && tar zxvf ghc-8.10.7-src.tar.xz
```

## prerequisite

- [ ] Make Tools

```
brew install autoconf automake libtool
```

- [ ] Cabal Tools

```
cabal install alex happy
```

:x: Unless after `configure` failure install:


## Compiling

- [ ] Initiate

```
./boot
```

- [ ] Configure

```
./configure
```

- [ ] Compile -jX : X being the number of cores


```
make -j8   
```

- Install the binaries and libraries

```
make install
```

- [ ] Binaries

```
-rwxr-xr-x  1 root  wheel       240  3 Nov 19:01 hp2ps
-rwxr-xr-x  1 root  wheel        68  3 Nov 19:01 ghci-9.3.20211103
lrwxr-xr-x  1 root  wheel        17  3 Nov 19:01 ghci -> ghci-9.3.20211103
-rwxr-xr-x  1 root  wheel       267  3 Nov 19:01 haddock-ghc-9.3.20211103
lrwxr-xr-x  1 root  wheel        24  3 Nov 19:01 haddock -> haddock-ghc-9.3.20211103
-rwxr-xr-x  1 root  wheel       998  3 Nov 19:01 hsc2hs
-rwxr-xr-x  1 root  wheel       308  3 Nov 19:01 ghc-pkg-9.3.20211103
lrwxr-xr-x  1 root  wheel        20  3 Nov 19:01 ghc-pkg -> ghc-pkg-9.3.20211103
-rwxr-xr-x  1 root  wheel       238  3 Nov 19:01 hpc
-rwxr-xr-x  1 root  wheel       291  3 Nov 19:01 runghc-9.3.20211103
lrwxr-xr-x  1 root  wheel         6  3 Nov 19:01 runhaskell -> runghc
lrwxr-xr-x  1 root  wheel        19  3 Nov 19:01 runghc -> runghc-9.3.20211103
-rwxr-xr-x  1 root  wheel       276  3 Nov 19:01 ghc-9.3.20211103
lrwxr-xr-x  1 root  wheel        16  3 Nov 19:01 ghc -> ghc-9.3.20211103
```
