include theos/makefiles/common.mk

export GO_EASY_ON_ME=1

BUNDLE_NAME = WeeToolbox
WeeToolbox_FILES = WeeToolboxController.m
WeeToolbox_INSTALL_PATH = /System/Library/WeeAppPlugins/
WeeToolbox_FRAMEWORKS = UIKit CoreGraphics Twitter AVFoundation Foundation AddressBook AddressBookUI

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
