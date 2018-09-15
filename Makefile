talkiepi:
	wget --no-check-certificate https://dl.google.com/go/go1.11.linux-amd64.tar.gz
	tar -C $$(pwd) -xzf go1.11.linux-amd64.tar.gz
	mkdir $$(pwd)/gopath
	HOME=$$(pwd) GOPATH=$$(pwd)/gopath $$(pwd)/go/bin/go get github.com/dchote/gopus
	HOME=$$(pwd) GOPATH=$$(pwd)/gopath $$(pwd)/go/bin/go get github.com/dchote/talkiepi
	HOME=$$(pwd) GOPATH=$$(pwd)/gopath $$(pwd)/go/bin/go build -o talkiepi cmd/talkiepi/main.go

install: talkiepi
	mkdir -p $$(pwd)/debian/talkiepi/usr/local/bin
	install -m 0755 talkiepi $$(pwd)/debian/talkiepi/usr/local/bin 

