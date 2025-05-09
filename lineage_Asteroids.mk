#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from Asteroids device
$(call inherit-product, device/nothing/Asteroids/device.mk)

PRODUCT_DEVICE := Asteroids
PRODUCT_NAME := lineage_Asteroids
PRODUCT_BRAND := Nothing
PRODUCT_MODEL := A059
PRODUCT_MANUFACTURER := Nothing

PRODUCT_GMS_CLIENTID_BASE := android-nothing

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="Asteroids-user 15 AQ3A.241015.001 2503021856 release-keys"

BUILD_FINGERPRINT := Nothing/Asteroids/Asteroids:15/AQ3A.241015.001/2503021856:user/release-keys
