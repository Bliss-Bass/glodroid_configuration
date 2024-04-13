
ifneq (,$(filter %_tv,$(TARGET_PRODUCT)))
    GD_NO_DEFAULT_MODEM := true
    $(call inherit-product, $(LOCAL_PATH)/device-tv.mk)
else ifneq (,$(filter %_auto,$(TARGET_PRODUCT)))
# TODO: Implement
    $(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
else
ifeq ($(wildcard lineage),lineage)
    $(call inherit-product, vendor/lineage/config/common_full_phone.mk)
else
    $(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
endif

endif

$(call inherit-product, $(LOCAL_PATH)/base/device.mk)

$(call inherit-product, $(LOCAL_PATH)/other-hals/device.mk)

$(call inherit-product, vendor/bass/branding.mk)

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

ifeq ($(BOARD_IS_GO_BUILD),true)
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-go
endif

# LMKd
ifneq ($(BOARD_IS_GO_BUILD),true)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.lmk.critical_upgrade=true \
    ro.lmk.use_psi=true \
    ro.lmk.use_new_strategy=false
endif

ifeq ($(BOARD_IS_GO_BUILD),true)
# Inherit common Android Go configurations
$(call inherit-product, build/target/product/go_defaults.mk)
PRODUCT_TYPE := go
DONT_UNCOMPRESS_PRIV_APPS_DEXS := true
endif

# Packages
$(call inherit-product,$(if $(wildcard $(PRODUCT_DIR)packages.mk),$(PRODUCT_DIR),$(LOCAL_PATH)/)packages.mk)

# Copy any Permissions files, overriding anything if needed
$(foreach f,$(wildcard $(LOCAL_PATH)/permissions/*.xml),\
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/$(notdir $f)))

$(foreach f,$(wildcard $(LOCAL_PATH)/permissions_product/*.xml),\
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/$(notdir $f)))

# Go Audio package
ifeq ($(IS_GO_VERSION),true)
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackageGo.mk)
else
$(call inherit-product-if-exists,frameworks/base/data/sounds/AudioPackage6.mk)
endif

# handheld_vendor
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_vendor.mk)


# Get GPS configuration
$(call inherit-product-if-exists,device/common/gps/gps_as.mk)


ifeq ($(GD_NO_DEFAULT_BLUETOOTH),)
    $(call inherit-product, $(LOCAL_PATH)/bluetooth/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_GRAPHICS),)
    $(call inherit-product, $(LOCAL_PATH)/graphics/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_CODECS),)
    $(call inherit-product, $(LOCAL_PATH)/codecs/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_CAMERA),)
    $(call inherit-product, $(LOCAL_PATH)/camera/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_MODEM),)
    $(call inherit-product, $(LOCAL_PATH)/modem/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_AUDIO),)
    $(call inherit-product, $(LOCAL_PATH)/audio/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_WIFI),)
    $(call inherit-product, $(LOCAL_PATH)/wifi/device.mk)
endif

ifeq ($(GD_NO_DEFAULT_APPS),)
    $(call inherit-product, glodroid/apks/glodroid-apks.mk)
endif

ifneq ($(GD_LOWRAM_CONFIG),)
    $(call inherit-product, $(LOCAL_PATH)/lowram/device.mk)
endif

ifeq ($(PRODUCT_BOARD_PLATFORM),sunxi)
    $(call inherit-product, $(LOCAL_PATH)/device-common-sunxi.mk)
endif

PRODUCT_SOONG_NAMESPACES += glodroid/configuration

# Copy Vendor Files
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.gamepad.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.gamepad.xml \
    frameworks/native/data/etc/android.hardware.location.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.uwb.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.uwb.xml \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.activities_on_secondary_displays.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.connectionservice.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.connectionservice.xml \
    frameworks/native/data/etc/android.software.controls.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.controls.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.picture_in_picture.xml \
    frameworks/native/data/etc/android.software.print.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.autofill.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.autofill.xml \
    frameworks/native/data/etc/android.software.sip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.xml \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml \
    frameworks/native/data/etc/android.software.webview.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.webview.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml
