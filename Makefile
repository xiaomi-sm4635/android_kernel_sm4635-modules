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
