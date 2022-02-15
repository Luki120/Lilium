TARGET := iphone:clang:latest:latest
INSTALL_TARGET_PROCESSES = SpringBoard

TWEAK_NAME = Lilium

Lilium_FILES = Lilium.m Categories/UIView+Constraints.m Views/LiliumView.m
Lilium_CFLAGS = -fobjc-arc
Lilium_PRIVATE_FRAMEWORKS = SpringBoard SpringBoardHome

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
