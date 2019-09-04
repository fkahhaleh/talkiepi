#!/bin/bash
cd 

 echo "getting source code..."
git clone --verbose --progress https://github.com/larsks/gpio-watch.git  || exit

 echo "compiling helper..."
cd gpio-watch || exit
make || exit

 echo "installing button scripts for volume control..."
mkdir /etc/gpio-scripts/

 echo "#!/bin/sh" > /etc/gpio-scripts/14
echo '# echo "Something happened! Pin=$1, value=$2"' >> /etc/gpio-scripts/14
echo '#amixer -c 1 set Mic 10%+' >> /etc/gpio-scripts/14
echo 'amixer -c 1 set Speaker 10%+' >> /etc/gpio-scripts/14
chmod a+x /etc/gpio-scripts/14

 echo "#!/bin/sh" > /etc/gpio-scripts/15
echo '# echo "Something happened! Pin=$1, value=$2"' >> /etc/gpio-scripts/15
echo '#amixer -c 1 set Mic 10%-' >> /etc/gpio-scripts/15
echo 'amixer -c 1 set Speaker 10%-' >> /etc/gpio-scripts/15
chmod a+x /etc/gpio-scripts/15

 echo "installing system service..."
apt-get install raspi-gpio
cp /boot/VOLUMEKEYS_SERVER.txt /etc/systemd/system/volumekeys.service &&  systemctl enable volumekeys.service
systemctl daemon-reload

