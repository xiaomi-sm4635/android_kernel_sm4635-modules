ifeq ($(TARGET_SUPPORT), monaco)
KBUILD_OPTIONS := CONFIG_SND_SOC_AUTO=y
KBUILD_OPTIONS += CONFIG_SND_SOC_SA7255=m
KBUILD_OPTIONS += MODNAME=audio_dlkm
endif

ifeq ($(AUTO_GVM), yes)
KBUILD_OPTIONS += CONFIG_SND_SOC_AUTO=y
KBUILD_OPTIONS += CONFIG_SND_SOC_GVM=y
KBUILD_OPTIONS += MODNAME=audio_dlkm
endif

M=$(PWD)
AUDIO_ROOT=$(KERNEL_SRC)/$(M)

KBUILD_OPTIONS+=  AUDIO_ROOT=$(AUDIO_ROOT)

all: modules

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) clean

# SPDX-License-Identifier: GPL-2.0-only

KBUILD_OPTIONS+= DISPLAY_ROOT=$(KERNEL_SRC)/$(M)

all:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) modules $(KBUILD_OPTIONS)

modules_install:
	$(MAKE) INSTALL_MOD_STRIP=1 -C $(KERNEL_SRC) M=$(M) modules_install

%:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) $@ $(KBUILD_OPTIONS)

clean:
	rm -f *.o *.ko *.mod.c *.mod.o *~ .*.cmd Module.symvers
	rm -rf .tmp_versions

KBUILD_OPTIONS += CAMERA_KERNEL_ROOT=$(shell pwd)
KBUILD_OPTIONS += KERNEL_ROOT=$(ROOT_DIR)/$(KERNEL_DIR)
KBUILD_OPTIONS += MODNAME=camera

all: modules

CAMERA_COMPILE_TIME = $(shell date)
CAMERA_COMPILE_BY = $(shell whoami | sed 's/\\/\\\\/')
CAMERA_COMPILE_HOST = $(shell uname -n)

cam_generated_h: $(shell find . -iname "*.c") $(shell find . -iname "*.h") $(shell find . -iname "*.mk")
	echo '#define CAMERA_COMPILE_TIME "$(CAMERA_COMPILE_TIME)"' > cam_generated_h
	echo '#define CAMERA_COMPILE_BY "$(CAMERA_COMPILE_BY)"' >> cam_generated_h
	echo '#define CAMERA_COMPILE_HOST "$(CAMERA_COMPILE_HOST)"' >> cam_generated_h

modules: cam_generated_h

modules dtbs:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) modules $(KBUILD_OPTIONS)

modules_install:
	$(MAKE) M=$(M) -C $(KERNEL_SRC) modules_install

clean:
	$(MAKE) -C $(KERNEL_SRC) M=$(M) clean

