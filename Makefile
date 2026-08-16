TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = Preferences
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwitchColor15

SwitchColor15_FILES = Tweak.xm
SwitchColor15_CFLAGS = -fobjc-arc
SwitchColor15_FRAMEWORKS = UIKit
# Manual rootless packaging for Dopamine: put the dylib and plist under /var/jb.
# This avoids asking dpkg to create the legacy rootful /Library tree.
SwitchColor15_INSTALL_PATH = /var/jb/Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/tweak.mk
