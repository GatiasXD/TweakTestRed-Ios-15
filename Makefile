TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = Preferences

ARCHS = arm64
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwitchColor15

SwitchColor15_FILES = Tweak.xm
SwitchColor15_CFLAGS = -fobjc-arc
SwitchColor15_FRAMEWORKS = UIKit

BUNDLE_NAME = SwitchColor15Prefs

SwitchColor15Prefs_FILES = SwitchColor15Prefs/SwitchColor15Prefs.m
SwitchColor15Prefs_INSTALL_PATH = /Library/PreferenceBundles
SwitchColor15Prefs_RESOURCES = SwitchColor15Prefs/Root.plist
SwitchColor15Prefs_FRAMEWORKS = UIKit
SwitchColor15Prefs_PRIVATE_FRAMEWORKS = Preferences
SwitchColor15Prefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk
