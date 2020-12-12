#!/bin/sh
#
# To Do
# ~~~~~
# - None, yet !

MANIFEST=manifest
VERSION=v03
RELEASE_PATHNAME=aiko_$VERSION
rm -rf $RELEASE_PATHNAME

mkdir $RELEASE_PATHNAME
mkdir $RELEASE_PATHNAME/applications
mkdir $RELEASE_PATHNAME/configuration
mkdir $RELEASE_PATHNAME/examples
mkdir $RELEASE_PATHNAME/lib
mkdir $RELEASE_PATHNAME/lib/aiko

cp applications/default.py    $RELEASE_PATHNAME/applications
cp applications/swagbadge.py  $RELEASE_PATHNAME/applications

cp configuration/main.py      $RELEASE_PATHNAME/configuration
cp configuration/led.py       $RELEASE_PATHNAME/configuration
cp configuration/mqtt.py      $RELEASE_PATHNAME/configuration
# cp configuration/net.py     $RELEASE_PATHNAME/configuration
cp configuration/oled.py      $RELEASE_PATHNAME/configuration
cp configuration/services.py  $RELEASE_PATHNAME/configuration

cp lib/aiko/common.py         $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/event.py          $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/led.py            $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/mqtt.py           $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/net.py            $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/oled.py           $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/queue.py          $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/services.py       $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/test.py           $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/upgrade.py        $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/web_client.py     $RELEASE_PATHNAME/lib/aiko
cp lib/aiko/web_server.py     $RELEASE_PATHNAME/lib/aiko

cp lib/mpu9250.py             $RELEASE_PATHNAME/lib
cp lib/shutil.py              $RELEASE_PATHNAME/lib
cp lib/ssd1306.py             $RELEASE_PATHNAME/lib
cp lib/threading.py           $RELEASE_PATHNAME/lib
cp lib/utarfile.py            $RELEASE_PATHNAME/lib

find $RELEASE_PATHNAME -type f \( -exec md5sum {} \; -exec wc -c {} \; \) | paste - - | column -t | tr -s "[:blank:]" | cut -d" " -f1,3,4 >$MANIFEST
mv $MANIFEST $RELEASE_PATHNAME/$MANIFEST
chmod -R 755 $RELEASE_PATHNAME
find $RELEASE_PATHNAME -type f -exec chmod 444 '{}' \;
tar -cf $RELEASE_PATHNAME.tar $RELEASE_PATHNAME

MANIFEST_CHECKSUM=`md5sum $RELEASE_PATHNAME/$MANIFEST | column -t | cut -d" " -f1`
MANIFEST_SIZE=`wc -c $RELEASE_PATHNAME/$MANIFEST | column -t | cut -d" " -f1`
URL=http://205.185.125.62:8888/$RELEASE_PATHNAME/$MANIFEST
QUOTE=\'

echo '### FIRMWARE DETAILS --> MOSQUITTO UPGRADE TOPIC ###'
echo 'mosquitto_pub -h lounge.local -t aiko/upgrade -r -m '$QUOTE'('upgrade $VERSION $URL $MANIFEST_CHECKSUM $MANIFEST_SIZE')'$QUOTE
# rm -rf $RELEASE_PATHNAME

#   (upgrade v03 http://205.185.125.62:8888/aiko_v03/manifest 30712ed923059d1e3fcf445a3a855234)
