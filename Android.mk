# Android makefile for audio kernel modules

ifneq (, $(filter $(call get-component-name), miodm))

LOCAL_PATH := $(call my-dir)

ifeq ($(call is-board-platform-in-list,taro),true)
AUDIO_SELECT  := CONFIG_SND_SOC_WAIPIO=m
endif

ifeq ($(call is-board-platform-in-list,kalama),true)
AUDIO_SELECT  := CONFIG_SND_SOC_KALAMA=m
endif

ifeq ($(call is-board-platform-in-list,bengal),true)
AUDIO_SELECT  := CONFIG_SND_SOC_BENGAL=m
endif

ifeq ($(call is-board-platform-in-list,holi blair),true)
AUDIO_SELECT  := CONFIG_SND_SOC_HOLI=m
endif

ifeq ($(call is-board-platform-in-list,pineapple cliffs volcano),true)
AUDIO_SELECT  := CONFIG_SND_SOC_PINEAPPLE=m
endif

ifeq ($(call is-board-platform-in-list,volcano),true)
AUDIO_SELECT  := CONFIG_SND_SOC_VOLCANO=m
endif

ifeq ($(call is-board-platform-in-list,pitti),true)
AUDIO_SELECT  := CONFIG_SND_SOC_PITTI=m
endif

ifeq ($(ENABLE_AUDIO_LEGACY_TECHPACK),true)
include $(call all-subdir-makefiles)
LOCAL_PATH := vendor/qcom/opensource/audio-kernel
endif

# Build/Package only in case of supported target
ifeq ($(call is-board-platform-in-list,taro kalama bengal pineapple cliffs pitti holi blair gen4 msmnile niobe volcano), true)

# This makefile is only for DLKM
ifneq ($(findstring vendor,$(LOCAL_PATH)),)

ifneq ($(findstring opensource,$(LOCAL_PATH)),)
	AUDIO_BLD_DIR := $(abspath .)/vendor/qcom/opensource/audio-kernel
endif # opensource

include $(AUDIO_BLD_DIR)/EnableBazel.mk
DLKM_DIR := $(TOP)/device/qcom/common/dlkm


###########################################################
# This is set once per LOCAL_PATH, not per (kernel) module
KBUILD_OPTIONS := AUDIO_ROOT=$(AUDIO_BLD_DIR)

# We are actually building audio.ko here, as per the
# requirement we are specifying <chipset>_audio.ko as LOCAL_MODULE.
# This means we need to rename the module to <chipset>_audio.ko
# after audio.ko is built.
KBUILD_OPTIONS += MODNAME=audio_dlkm
KBUILD_OPTIONS += BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM)
KBUILD_OPTIONS += $(AUDIO_SELECT)

ifneq ($(call is-board-platform-in-list, bengal holi blair msmnile gen4),true)
KBUILD_OPTIONS += KBUILD_EXTRA_SYMBOLS=$(PWD)/$(call intermediates-dir-for,DLKM,msm-ext-disp-module-symvers)/Module.symvers
endif

ifeq ($(call is-board-platform-in-list, gen4 msmnile),true)
KBUILD_OPTIONS += CONFIG_SND_SOC_AUTO=y
ifneq (,$(filter $(TARGET_BOARD_PLATFORM)$(TARGET_BOARD_SUFFIX), gen4_gvm msmnile_gvmq))
KBUILD_OPTIONS +=CONFIG_SND_SOC_GVM=y
endif
endif

AUDIO_SRC_FILES := \
	$(wildcard $(LOCAL_PATH)/*) \
	$(wildcard $(LOCAL_PATH)/*/*) \
	$(wildcard $(LOCAL_PATH)/*/*/*) \
	$(wildcard $(LOCAL_PATH)/*/*/*/*)

ifneq (,$(filter $(TARGET_BOARD_PLATFORM)$(TARGET_BOARD_SUFFIX), gen4_gvm msmnile_gvmq))
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := stub_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/stub_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### ASOC MACHINE ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := machine_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/spf_machine_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### LPASS-CDC CODEC  ###########################
else
########################### dsp ################################

include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := q6_notifier_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := dsp/q6_notifier_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := spf_core_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := dsp/spf_core_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################

include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := audpkt_ion_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := dsp/audpkt_ion_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := gpr_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := ipc/gpr_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := audio_pkt_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := ipc/audio_pkt_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := q6_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := dsp/q6_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := adsp_loader_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := dsp/adsp_loader_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk

########################### ipc  ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := audio_prm_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := dsp/audio_prm_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := q6_pdr_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := dsp/q6_pdr_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk

############################ soc ###############################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := pinctrl_lpi_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := soc/pinctrl_lpi_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := swr_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := soc/swr_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := swr_ctrl_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := soc/swr_ctrl_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := snd_event_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := soc/snd_event_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### audio_info ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := lct_audio_info_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/lct_audio_info/lct_audio_info_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################  ASOC CODEC ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd_core_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd_core_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := mbhc_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/mbhc_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
ifneq ($(call is-board-platform-in-list, bengal holi blair pitti),true)
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := swr_dmic_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/swr_dmic_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd9xxx_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd9xxx_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
ifneq ($(call is-board-platform-in-list, bengal holi blair),true)
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := swr_haptics_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/swr_haptics_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := stub_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/stub_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### ASOC MACHINE ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := machine_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/machine_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### LPASS-CDC CODEC  ###########################
ifneq ($(call is-board-platform-in-list, bengal holi blair),true)
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := lpass_cdc_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/lpass-cdc/lpass_cdc_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := lpass_cdc_wsa2_macro_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/lpass-cdc/lpass_cdc_wsa2_macro_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := lpass_cdc_wsa_macro_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/lpass-cdc/lpass_cdc_wsa_macro_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := lpass_cdc_va_macro_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/lpass-cdc/lpass_cdc_va_macro_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := lpass_cdc_tx_macro_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/lpass-cdc/lpass_cdc_tx_macro_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := lpass_cdc_rx_macro_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/lpass-cdc/lpass_cdc_rx_macro_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk

ifneq ($(call is-board-platform-in-list, pitti),true)
########################### WSA884x CODEC  ###########################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wsa884x_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wsa884x/wsa884x_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk

########################### WSA883x CODEC  ###########################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wsa883x_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wsa883x/wsa883x_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk

########################### WCD937x CODEC  ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd937x_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd937x/wcd937x_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd937x_slave_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd937x/wcd937x_slave_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### WCD938x CODEC  ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd938x_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd938x/wcd938x_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd938x_slave_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd938x/wcd938x_slave_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### WCD939x CODEC  ################################
endif

ifneq ($(call is-board-platform-in-list, niobe pitti),true)
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd939x_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd939x/wcd939x_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd939x_slave_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd939x/wcd939x_slave_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd9378_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd9378/wcd9378_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### FS1512 ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := fs1512_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/fs1512/fs1512_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd9378_slave_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd9378/wcd9378_slave_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif
ifeq ($(call is-board-platform-in-list, pitti),true)
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wsa881x_analog_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wsa881x_analog_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd9378_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd9378/wcd9378_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### FS1512 ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := fs1512_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/fs1512/fs1512_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### SIA8001 CODEC  ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := sia8001_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/sia8001/sia8001_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd9378_slave_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd9378/wcd9378_slave_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif
###########################################################
ifeq ($(AUDIO_DLKM_ENABLE), true)
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := hdmi_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/hdmi_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
LOCAL_REQUIRED_MODULES    := msm-ext-disp-module-symvers
LOCAL_ADDITIONAL_DEPENDENCIES := $(call intermediates-dir-for,DLKM,msm-ext-disp-module-symvers)/Module.symvers
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif
endif

ifeq ($(call is-board-platform-in-list, bengal holi blair),true)
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := bolero_cdc_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/bolero/bolero_cdc_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := va_macro_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/bolero/va_macro_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := tx_macro_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/bolero/tx_macro_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := rx_macro_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/bolero/rx_macro_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wsa881x_analog_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wsa881x_analog_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
########################### WCD937x CODEC  ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd937x_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd937x/wcd937x_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd937x_slave_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd937x/wcd937x_slave_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif

ifeq ($(call is-board-platform-in-list,holi blair),true)
########################### WCD938x CODEC  ################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd938x_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd938x/wcd938x_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
###########################################################
include $(CLEAR_VARS)
LOCAL_SRC_FILES           := $(AUDIO_SRC_FILES)
LOCAL_MODULE              := wcd938x_slave_dlkm.ko
LOCAL_MODULE_KBUILD_NAME  := asoc/codecs/wcd938x/wcd938x_slave_dlkm.ko
LOCAL_MODULE_TAGS         := optional
LOCAL_MODULE_DEBUG_ENABLE := true
LOCAL_MODULE_PATH         := $(KERNEL_MODULES_OUT)
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif
##########################################################
endif # DLKM check
endif # supported target check
# Android makefile for display kernel modules
ifneq (, $(filter $(call get-component-name), miodm))

DISPLAY_DLKM_ENABLE := true
ifeq ($(TARGET_KERNEL_DLKM_DISABLE), true)
	ifeq ($(TARGET_KERNEL_DLKM_DISPLAY_OVERRIDE), false)
		DISPLAY_DLKM_ENABLE := false
	endif
endif

ifeq ($(DISPLAY_DLKM_ENABLE),  true)
	LOCAL_PATH := $(call my-dir)
	include $(LOCAL_PATH)/msm/Android.mk

endif
ifneq (, $(filter $(call get-component-name), miodm))

CAMERA_DLKM_ENABLED := true
ifeq ($(TARGET_KERNEL_DLKM_DISABLE), true)
	ifeq ($(TARGET_KERNEL_DLKM_CAMERA_OVERRIDE), false)
		CAMERA_DLKM_ENABLED := false;
	endif
endif

ifeq ($(CAMERA_DLKM_ENABLED),true)
ifeq ($(call is-board-platform-in-list, $(TARGET_BOARD_PLATFORM)),true)

# Make target to specify building the camera.ko from within Android build system.
LOCAL_PATH := $(call my-dir)
# Path to DLKM make scripts
DLKM_DIR := $(TOP)/device/qcom/common/dlkm

LOCAL_MODULE_DDK_BUILD := true

CAMERA_SRC_FILES := \
                    $(addprefix $(LOCAL_PATH)/, $(call all-named-files-under,*.h,drivers dt-bindings include))\
                    $(addprefix $(LOCAL_PATH)/, $(call all-named-files-under,*.mk,config))\
                    $(addprefix $(LOCAL_PATH)/, $(call all-named-files-under,*.c,drivers))\
                    $(LOCAL_PATH)/board.mk      \
                    $(LOCAL_PATH)/product.mk    \
                    $(LOCAL_PATH)/Kbuild

# Kbuild options
KBUILD_OPTIONS := CAMERA_KERNEL_ROOT=$(TOP)/$(LOCAL_PATH)
KBUILD_OPTIONS += KERNEL_ROOT=$(TOP)/kernel_platform/common
KBUILD_OPTIONS += MODNAME=camera
KBUILD_OPTIONS += BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM)

# Clear shell environment variables from previous android module during build
include $(CLEAR_VARS)
# For incremental compilation support.
LOCAL_SRC_FILES             := $(CAMERA_SRC_FILES)
LOCAL_MODULE_PATH           := $(KERNEL_MODULES_OUT)
LOCAL_MODULE                := camera.ko
LOCAL_MODULE_TAGS           := optional
#LOCAL_MODULE_KBUILD_NAME   := camera.ko
#LOCAL_MODULE_DEBUG_ENABLE  := true

$(info KBUILD_OPTIONS = $(KBUILD_OPTIONS))

BOARD_VENDOR_KERNEL_MODULES += $(LOCAL_MODULE_PATH)/$(LOCAL_MODULE)
ifeq ($(TARGET_BOARD_PLATFORM), lahaina)
# Include Kernel DLKM Android.mk target to place generated .ko file in image
include $(DLKM_DIR)/AndroidKernelModule.mk
# Include Camera UAPI Android.mk target to copy headers
include $(LOCAL_PATH)/include/uapi/Android.mk
else
include $(DLKM_DIR)/Build_external_kernelmodule.mk
endif

endif # End of check for board platform
endif # ifeq ($(CAMERA_DLKM_ENABLED),true)
endif
