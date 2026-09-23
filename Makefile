THEOS_PACKAGE_SCHEME = rootless
TARGET = iphone:clang:latest:15.0
ARCHS = arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AVFCameraSupport
AVFCameraSupport_FILES = Tweak.x AVAssetStreamAdapter.m
AVFCameraSupport_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -O2 -fvisibility=hidden
AVFCameraSupport_FRAMEWORKS = UIKit AVFoundation CoreMedia CoreVideo QuartzCore CoreGraphics CoreImage Foundation ImageIO
AVFCameraSupport_LDFLAGS = -undefined dynamic_lookup -Wl,-dead_strip
AVFCameraSupport_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

SUBPROJECTS += prefs

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
