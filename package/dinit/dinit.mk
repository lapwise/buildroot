################################################################################
#
# dinit
#
################################################################################
DINIT_VERSION = 0.11.0
DINIT_SOURCE = v$(DINIT_VERSION).tar.gz
DINIT_SITE = https://github.com/davmac314/dinit/archive
DINIT_LICENSE = Apache-2.0
DINIT_LICENSE_FILES = LICENSE

DINIT_CFLAGS = $(TARGET_CFLAGS) -std=c++11 -fno-rtti -fno-plt -flto
DINIT_LDFLAGS = $(TARGET_LDFLAGS) -flto -Os

ifdef BR2_INIT_DINIT_CONFIG
	CONFIG_INSTALL=cp -vr $(BR2_INIT_DINIT_CONFIG)/* $(TARGET_DIR)/etc/dinit.d/
else
	CONFIG_INSTALL=""
endif


define DINIT_BUILD_CMDS
	@echo "SBINDIR=/sbin" > $(@D)/mconfig
	@echo "MANDIR=/usr/share/man" >> $(@D)/mconfig
	@echo "SYSCONTROLSOCKET=/run/dinitctl" >> $(@D)/mconfig
	@echo "BUILD_SHUTDOWN=yes" >> $(@D)/mconfig
	@echo "SANITIZEOPTS=-fsanitize=address,undefined" >> $(@D)/mconfig
	@echo "HOST_CXX=$(CXX)" >> $(@D)/mconfig
	@echo "CXX=$(TARGET_CXX)" >> $(@D)/mconfig
	@echo "CXXOPTS=$(DINIT_CFLAGS)" >> $(@D)/mconfig
	@echo "LD=$(TARGET_LD)" >> $(@D)/mconfig
	@echo "LDFLAGS=$(DINIT_LDFLAGS)" >> $(@D)/mconfig
	@echo "STRIPOPTS=-s --strip-program=$(TARGET_STRIP)" >> $(@D)/mconfig
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define DINIT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src install DESTDIR=$(TARGET_DIR)
        cd $(TARGET_DIR)/sbin; ln -fs dinit init
	rm -rf $(TARGET_DIR)/etc/dinit.d/*
	mkdir -p $(TARGET_DIR)/etc/dinit.d
	touch $(TARGET_DIR)/etc/inittab
	$(CONFIG_INSTALL)

endef

$(eval $(generic-package))
