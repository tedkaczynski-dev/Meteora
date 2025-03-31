TARGET = iphone:clang:10.2
ARCHS = arm64

Meteora_SYSROOT = $(THEOS)/sdks/iPhoneOS10.2.sdk

include $(THEOS)/makefiles/common.mk
THEOS_DEVICE_IP=192.168.1.3

TWEAK_NAME = Meteora
Meteora_FILES = Tweak.xm
Meteora_FRAMEWORKS = UIKit CoreGraphics AudioToolbox AVFoundation
Meteora_PRIVATE_FRAMEWORKS = MediaRemote
Meteora_EXTRA_FRAMEWORKS += Cephei
Meteora += -Wl,-segalign,4000
Meteora_CFLAGS = -Wno-deprecated -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
