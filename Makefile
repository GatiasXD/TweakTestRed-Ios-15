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

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp SwitchColor15Prefs.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SwitchColor15.plist$(ECHO_END)
