THEOS_PACKAGE_SCHEME = rootless

TARGET := iphone:clang:latest:15.0
ARCHS = arm64

INSTALL_TARGET_PROCESSES = Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwitchColor15

SwitchColor15_FILES = Tweak.xm
SwitchColor15_CFLAGS = -fobjc-arc
SwitchColor15_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp SwitchColor15.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SwitchColor15.plist$(ECHO_END)
