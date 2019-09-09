package talkiepi

import (
	"crypto/tls"

	"github.com/dchote/gpio"
	"layeh.com/gumble/gumble"
	"layeh.com/gumble/gumbleopenal"
)

// Raspberry Pi GPIO pin assignments (CPU pin definitions)
const (
	OnlineLEDPin        uint = 18
	ParticipantsLEDPin  uint = 23
	TransmitLEDPin      uint = 24
	PushToTalkButtonPin uint = 25
	SelectButtonPin	    uint = 26
	VolumeIncrement	    int = 10
)

type TalkieButton struct {
	Pin    gpio.Pin
	State  uint
	OnPress func ()
	OnRelease  func ()
}

type Talkiepi struct {
	Config *gumble.Config
	Client *gumble.Client

	Address   string
	TLSConfig tls.Config

	ConnectAttempts uint

	Stream *gumbleopenal.Stream

	ChannelName    string
	IsConnected    bool
	IsTransmitting bool
	AlwaysListening bool

	GPIOEnabled     bool
	OnlineLED       gpio.Pin
	ParticipantsLED gpio.Pin
	TransmitLED     gpio.Pin

	Buttons		[]TalkieButton
}
