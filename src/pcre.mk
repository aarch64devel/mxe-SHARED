# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := pcre
$(PKG)_WEBSITE  := https://www.pcre.org/
$(PKG)_DESCR    := PCRE
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.45
$(PKG)_CHECKSUM := 4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8
$(PKG)_SUBDIR   := pcre-$($(PKG)_VERSION)
$(PKG)_FILE     := pcre-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/pcre/pcre/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)

define $(PKG)_BUILD_SHARED
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-pcre16 \
        --enable-utf \
        --enable-unicode-properties \
        --enable-cpp \
        --disable-pcregrep-libz \
        --disable-pcregrep-libbz2 \
        --disable-pcretest-libreadline
    # NOTE /1/ {a,b}{c,d} is the Bash for combinatorial enumeration, resolves to "ac ad bc bd"
    # NOTE /2/ There is a suppressed test suite in this package; we may want to reactivate it.
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_PROGRAMS) dist_html_DATA= dist_doc_DATA= \
        LDFLAGS='`$(MXE_INTRINSIC_SH) aeabi_{,u}{i,l}divmod.S.obj {,u}divmodsi4.S.obj {,u}divmoddi4.c.obj chkstk.S.obj`'
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man1/pcre*.1
    rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/pcre*.3
    ln -sf '$(PREFIX)/$(TARGET)/bin/pcre-config' '$(PREFIX)/bin/$(TARGET)-pcre-config'
endef

define $(PKG)_BUILD
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/pcre.h.in'
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/pcreposix.h'
    $($(PKG)_BUILD_SHARED)
endef

define $(PKG)_BUILD_$(BUILD)
    cd '$(BUILD_DIR)' && $(SOURCE_DIR)/configure \
        $(MXE_CONFIGURE_OPTS)
    $(MAKE) -C '$(BUILD_DIR)' -j '$(JOBS)'
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
