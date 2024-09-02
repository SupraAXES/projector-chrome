#!/bin/bash

# avoid session corruption
rm -rf /home/supra/.config/google-chrome/Singleton*

runuser -u supra -- google-chrome $SUPRA_RBI_URL --kiosk --renderer-process-limit=2 --enable-low-end-device-mode \
    --disable-infobars --disable-background-networking \
    --disable-site-isolation-trials \
    --no-sandbox --no-first-run --window-position=0,0 \
    --force-device-scale-factor=1 --disable-dev-shm-usage \
    --test-type --disable-notifications \
    &> /dev/null
