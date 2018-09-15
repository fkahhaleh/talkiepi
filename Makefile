talkiepi:
	mkdir $$(pwd)/gopath
	HOME=$$(pwd) GOPATH=$$(pwd)/gopath go get github.com/dchote/gopus
	HOME=$$(pwd) GOPATH=$$(pwd)/gopath go get github.com/dchote/talkiepi
	HOME=$$(pwd) GOPATH=$$(pwd)/gopath go build -o talkiepi cmd/talkiepi/main.go

install: talkiepi
	mkdir -p $$(pwd)/debian/talkiepi/usr/local/bin
	install -m 0755 talkiepi $$(pwd)/debian/talkiepi/usr/local/bin 

