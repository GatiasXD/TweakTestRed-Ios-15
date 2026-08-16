TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = Preferences
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwitchColor15

SwitchColor15_FILES = Tweak.xm
SwitchColor15_CFLAGS = -fobjc-arc
SwitchColor15_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

THEOS_PACKAGE_SCHEME = rootless
