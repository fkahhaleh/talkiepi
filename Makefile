talkiepi:
	mkdir $$(pwd)/gopath
	GOPATH=$$(pwd)/gopath go get github.com/dchote/gopus
	GOPATH=$$(pwd)/gopath go get github.com/dchote/talkiepi
	GOPATH=$$(pwd)/gopath GOOS=linux GOARCH=arm GOARM=5 go build -o talkiepi cmd/talkiepi/main.go

install: talkiepi
	mkdir -p $$(pwd)/debian/talkiepi/usr/local/bin
	install -m 0755 talkiepi $$(pwd)/debian/talkiepi/usr/local/bin 

