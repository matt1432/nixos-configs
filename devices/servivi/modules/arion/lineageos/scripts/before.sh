#!/usr/bin/env bash

## See here for AndroidAuto: https://github.com/sn-00-x/aa4mg

## add MulchWebView
sed -i "1s;^;\$(call inherit-product-if-exists, vendor/mulch/mulch.mk)\n\n;" "/srv/src/LINEAGE_20_0/vendor/lineage/config/common.mk"

## add lawnchair overlay to build
sed -i "1s;^;\$(call inherit-product-if-exists, vendor/lawnchair/lawnchair.mk)\n\n;" "/srv/src/LINEAGE_20_0/vendor/lineage/config/common.mk"

## remove Trebuchet
sed -i 's/overrides.*/overrides: ["Home", "Launcher2", "Launcher3", "Launcher3QuickStep", "ParanoidQuickStep", "PixelLauncher", "TrebuchetQuickStep", "TrebuchetOverlay"],/' "/srv/src/LINEAGE_20_0/vendor/lawnchair/Android.bp"

## only add needed packages from microg
echo "PRODUCT_PACKAGES += \\
    GmsCore \\
    GsfProxy \\
    FakeStore \\
    IchnaeaNlpBackend \\
    NominatimGeocoderBackend" > "/srv/src/LINEAGE_20_0/vendor/partner_gms/products/gms.mk"
