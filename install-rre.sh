#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Usage: sudo ${0}"
  exit
fi

cd /tmp
curl -L https://git.spec.cat/attachments/658d775b-da93-4d01-8fa8-a7a325a73e67 | zstd -d > gamescope
echo "a1490bdaddf93a0b312f4fd62f389e72cbe4af8b8012d7be4f14aea7f393eaee gamescope" | sha256sum --check

if [ "$?" -ne 0 ]
  then echo "Download corrupt or invalid? Please try again..."
  rm gamescope
  exit
fi

steamos-readonly disable

if [ ! -f /usr/bin/gamescope.orig ]
  then cp /usr/bin/gamescope /usr/bin/gamescope.orig
fi

mv gamescope /usr/bin/gamescope
chmod +x /usr/bin/gamescope
chown root:root /usr/bin/gamescope

steamos-readonly enable

echo "Installation completed..."
