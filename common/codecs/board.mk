# SPDX-License-Identifier: Apache-2.0
#
# GloDroid project (https://github.com/GloDroid)
#
# Copyright (C) 2022 Roman Stratiienko (r.stratiienko@gmail.com)


DEVICE_MANIFEST_FILE += \
    glodroid/configuration/common/codecs/android.hardware.media.omx@1.0.xml \

BOARD_VENDOR_SEPOLICY_DIRS += glodroid/configuration/common/codecs/sepolicy/vendor

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    glodroid/configuration/common/codecs/device_framework_compatibility_matrix_codec2.xml \
