TARGET := iphone:clang:latest:15.0
ARCHS = arm64

INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwitchColor15

SwitchColor15_FILES = Tweak.xm
SwitchColor15_CFLAGS = -fobjc-arc
SwitchColor15_FRAMEWORKS = UIKit

BUNDLE_NAME = SwitchColor15Prefs

SwitchColor15Prefs_FILES = SwitchColor15Prefs/SwitchColor15Prefs.m
SwitchColor15Prefs_RESOURCES = SwitchColor15Prefs/Root.plist
SwitchColor15Prefs_FRAMEWORKS = UIKit
SwitchColor15Prefs_PRIVATE_FRAMEWORKS = Preferences
SwitchColor15Prefs_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

THEOS_PACKAGE_SCHEME = rootless
