#/bin/bash
#apt-get update
#apt-get dist-upgrade
apt-get install golang libltc11 libopenal-dev libopus-dev git || exit

 echo "adding mumble user"
adduser --disabled-password --disabled-login --gecos "" mumble
usermod -a -G cdrom,audio,video,plugdev,users,dialout,dip,input,gpio mumble

 #echo "installing intercom software..."
su mumble -c "cd ; mkdir ~/gocode ; mkdir ~/bin ; "
su mumble -c "export GOPATH=/home/mumble/gocode ; export GOBIN=/home/mumble/bin ; cd $GOPATH && go get layeh.com/gopus" || exit
su mumble -c "export GOPATH=/home/mumble/gocode ; export GOBIN=/home/mumble/bin ; cd $GOPATH && go get github.com/dchote/gopus" || exit
su mumble -c "export GOPATH=/home/mumble/gocode ; export GOBIN=/home/mumble/bin ; cd $GOPATH && go get github.com/MarcusWolschon/RasPi_stage_intercom " || exit
su mumble -c "export GOPATH=/home/mumble/gocode ; export GOBIN=/home/mumble/bin ; cd /home/mumble/gocode/src/github.com/MarcusWolschon/RasPi_stage_intercom && go build -o /home/mumble/bin/talkiepi cmd/talkiepi/main.go "  || exit

 echo "generating mumble client certificate...pleae enter a random passphrase and repeat it when asked to"
su mumble -c "cd ; openssl genrsa -aes256 -out key.pem && openssl req -new -x509 -key key.pem -out cert.pem -days 1095 && openssl req -new -x509 -key key.pem -out cert.pem -days 1095 && openssl rsa -in key.pem -out nopasskey.pem && cat nopasskey.pem cert.pem > mumble.pem"

 echo "installing system service..."
cp /boot/INTERCOM_SERVER.txt /etc/systemd/system/mumble.service &&  systemctl enable mumble.service

 echo "please edit /usr/share/alsa/alsa.conf to set defaults.ctl.card  and defaults.pcm.card to the index of your USB soundcard..."
aplay -l

