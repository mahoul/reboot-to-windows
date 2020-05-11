#
# Global Settings
#

INSTALL = install
DESTDIR ?= /
PREFIX  ?= $(DESTDIR)/usr

PATH_RTW_SUDO = $(DESTDIR)/etc/sudoers.d/reboot-to-windows
PATH_RTW_BIN = $(PREFIX)/local/bin/reboot-to-windows.sh
PATH_RTW_DESKTOP = $(PREFIX)/local/share/applications/reboot-to-windows.desktop
PATH_RTW_ICON = $(PREFIX)/local/share/icons/Windows_logo_-_2012.svg

DIST := $(shell lsb_release -s -i)
#
# Targets
#

all:
	@echo "Nothing to do"


install:

ifeq ($(DIST),Ubuntu)
	$(INSTALL) -m0440 -D sudoers.d/reboot-to-windows.ubuntu $(PATH_RTW_SUDO)
else ifeq ($(DIST),Fedora)
	$(INSTALL) -m0440 -D sudoers.d/reboot-to-windows.fedora $(PATH_RTW_SUDO)
endif
	$(INSTALL) -m0775 -D local/bin/reboot-to-windows.sh $(PATH_RTW_BIN)
	$(INSTALL) -m0644 -D local/share/applications/reboot-to-windows.desktop $(PATH_RTW_DESKTOP)
	$(INSTALL) -m0644 -D local/share/icons/Windows_logo_-_2012.svg $(PATH_RTW_ICON)
	
uninstall:
	rm -f $(PATH_RTW_SUDO) 
	rm -f $(PATH_RTW_BIN)
	rm -f $(PATH_RTW_DESKTOP)
	rm -f $(PATH_RTW_ICON)

.PHONY: all install uninstall

