TOP=..
include $(TOP)/mk/boilerplate.mk

SUBDIRS = include

ALL_DIRS = \
	cbits \
	Data \
	Data/Time \
	Data/Time/Calendar \
	Data/Time/Clock \
	Data/Time/LocalTime

PACKAGE = time
VERSION = 1.1
PACKAGE_DEPS = base

SRC_HC_OPTS += -Wall -Werror -fffi -Iinclude

SRC_CC_OPTS += -Wall -Werror -Iinclude

EXCLUDED_SRCS += Setup.hs

SRC_HADDOCK_OPTS += -t "Haskell Hierarchical Libraries ($(PACKAGE) package)"

UseGhcForCc = YES

include $(TOP)/mk/target.mk
