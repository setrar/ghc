# -----------------------------------------------------------------------------
#
# (c) 2009 The University of Glasgow
#
# This file is part of the GHC build system.
#
# To understand how the build system works and how to modify it, see
#      https://gitlab.haskell.org/ghc/ghc/wikis/building/architecture
#      https://gitlab.haskell.org/ghc/ghc/wikis/building/modifying
#
# -----------------------------------------------------------------------------


define manual-package-config
# args:
# $1 = dir
# $2 = distdir
# $3 = stage
$(call trace, manual-package-config($1, $2, $3))
$(call profStart, manual-package-config($1, $2, $3))

$1/$2/package.conf.inplace : $1/package.conf.in $$$$(ghc-pkg_INPLACE) | $$$$(dir $$$$@)/.
	$$(HS_CPP) -P \
		-DTOP='"$$(TOP)"' \
		$$($1_PACKAGE_CPP_OPTS) \
		$$(addprefix -I,$$(GHC_INCLUDE_DIRS)) \
		-I$$(BUILD_$3_INCLUDE_DIR) \
		-x c $$< -o $$@.raw
	grep -v '^#pragma GCC' $$@.raw | \
	    sed -e 's/""//g' -e 's/:[ 	]*,/: /g' > $$@

	"$$(ghc-pkg_INPLACE)" update --force $$@

# This is actually a real file, but we need to recreate it on every
# "make install", so we declare it as phony
.PHONY: $1/$2/package.conf.install
$1/$2/package.conf.install : $1/package.conf.in | $$$$(dir $$$$@)/.
	$$(HS_CPP) -P \
		-DINSTALLING \
		-DLIB_DIR='"$$(if $$(filter YES,$$(RelocatableBuild)),$$$$topdir,$$(ghclibdir))"' \
		-DINCLUDE_DIR='"$$(if $$(filter YES,$$(RelocatableBuild)),$$$$topdir,$$(ghclibdir))/include"' \
		$$($1_PACKAGE_CPP_OPTS) \
		$$(addprefix -I,$$(GHC_INCLUDE_DIRS)) \
		-I$$(BUILD_$3_INCLUDE_DIR) \
		-x c $1/package.conf.in -o $$@.raw
	grep -v '^#pragma GCC' $$@.raw | \
	    sed -e 's/""//g' -e 's/:[ 	]*,/: /g' >$$@

$(call profEnd, manual-package-config($1, $2, $3))
endef
