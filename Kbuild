obj-y := dsp/ ipc/ soc/ asoc/ asoc/codecs/ asoc/codecs/lpass-cdc/ asoc/codecs/bolero/ asoc/codecs/wcd939x/ asoc/codecs/sia8001/ asoc/codecs/wsa884x/ asoc/codecs/wcd938x/ asoc/codecs/wsa883x/ asoc/codecs/wcd937x/ asoc/codecs/wcd9378/ asoc/codecs/lct_audio_info/ asoc/codecs/fs1512/
# SPDX-License-Identifier: GPL-2.0-only

ifeq ($(DISPLAY_ROOT),)
DISPLAY_ROOT=$(srctree)/techpack/display
endif

LINUXINCLUDE    += \
		   -I$(DISPLAY_ROOT)/include/uapi/display \
		   -I$(DISPLAY_ROOT)/include
USERINCLUDE     += -I$(DISPLAY_ROOT)/include/uapi/display

obj-$(CONFIG_DRM_MSM) += msm/

