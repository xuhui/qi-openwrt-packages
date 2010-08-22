# Copyright (C) 2008 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nightsky
PKG_VERSION:=20100823
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=@SF/$(PKG_NAME)
PKG_MD5SUM:=56e60be8db24f6fb6456e6e39e3ae6bd

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/nightsky
  TITLE:=Nightsky
  SECTION:=education
  CATEGORY:=Education
  URL:=https://sourceforge.net/projects/nightsky/
  DEPENDS:=+libsdl +libsdl-image
endef

define Package/nightsky/description
  Nightsky is a very basic rendering of the stars in the sky for devices that aren't powerful enough to run Stellarium
endef

define Package/nightsky/install
	$(INSTALL_DIR) \
		$(1)/usr/bin/ \
		$(1)/usr/share/nightsky/ \

	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/src/nightsky \
		$(1)/usr/bin/

	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/example-nightsky.yml \
		$(PKG_BUILD_DIR)/README \
		$(PKG_BUILD_DIR)/data/*.tsv \
		$(PKG_BUILD_DIR)/data/cursor.png \
		$(1)/usr/share/nightsky/

	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/data/un-fuzzy-6x10-font.png \
		$(1)/usr/share/nightsky/font.png

endef

$(eval $(call BuildPackage,nightsky))