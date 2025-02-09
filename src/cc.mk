# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cc
$(PKG)_WEBSITE  := https://mxe.cc/
$(PKG)_DESCR    := Dependency package for cross libraries
$(PKG)_VERSION  := 1
$(PKG)_DEPS     := gcc $(BUILD)~llvm-mingw
$(PKG)_OO_DEPS   = pkgconf
$(PKG)_TYPE     := meta
$(PKG)_DEPS_$(BUILD) :=
$(PKG)_TARGETS  := $(BUILD) $(MXE_TARGETS)
