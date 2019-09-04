package talkiepi

import (
	"fmt"
	"time"

	"github.com/dchote/gpio"
	"github.com/stianeikeland/go-rpio"
)

func (b *Talkiepi) initGPIO() {
	// we need to pull in rpio to pullup our button pin
	if err := rpio.Open(); err != nil {
		fmt.Println(err)
		b.GPIOEnabled = false
		return
	} else {
		b.GPIOEnabled = true
	}

	//TransmitButtonPinPullUp := rpio.Pin(PushToTalkButtonPin)
	//TransmitButtonPinPullUp.PullUp()

	rpio.Close()


	b.Buttons = []TalkieButton{
		TalkieButton{
			Pin: gpio.NewInput(PushToTalkButtonPin),
			State: 1,
			OnPress: func() {
				fmt.Printf("Transmit is pressed\n")
				b.TransmitStart()
			},
			OnRelease: func() {
				fmt.Printf("Transmit is released\n")
				b.TransmitStop()
			},
		},
		TalkieButton{
			Pin: gpio.NewInput(SelectButtonPin),
			State: 1,
			OnPress: func() {
				fmt.Printf("ChannelSelection Button is pressed\n")
				b.NextChannel()
			},
			OnRelease: func() {
				fmt.Printf("ChannelSelection Button is released\n")
				//no further action to do
			},
		}
	}

	// unfortunately the gpio watcher stuff doesnt work for me in this context, so we have to poll the buttons instead
	go func() {
		for {

			if b.AlwaysListening {
				if b.Stream != nil && !b.IsTransmitting {
					   b.TransmitStart()
				}
			}
			else
			{
				if b.GPIOEnabled{
					for i := 0; i < len(b.Buttons); i++ {
						currentState, err := b.Buttons[i].Pin.Read()
	
						if currentState != b.Buttons[i].State && err == nil {
							b.Buttons[i].State = currentState
	
							if b.Stream != nil {
								if b.Buttons[i].State == 1 {
									b.Buttons[i].OnRelease()
								} else {
									b.Buttons[i].OnPress()
								}
							}
						}
					}
				}
			}
			time.Sleep(500 * time.Millisecond)
		}
	}()

	// then we can do our gpio stuff
	b.OnlineLED = gpio.NewOutput(OnlineLEDPin, false)
	b.ParticipantsLED = gpio.NewOutput(ParticipantsLEDPin, false)
	b.TransmitLED = gpio.NewOutput(TransmitLEDPin, false)


}

func (b *Talkiepi) LEDOn(LED gpio.Pin) {
	if b.GPIOEnabled == false {
		return
	}

	LED.High()
}

func (b *Talkiepi) LEDOff(LED gpio.Pin) {
	if b.GPIOEnabled == false {
		return
	}

	LED.Low()
}

func (b *Talkiepi) LEDOffAll() {
	if b.GPIOEnabled == false {
		return
	}

	b.LEDOff(b.OnlineLED)
	b.LEDOff(b.ParticipantsLED)
	b.LEDOff(b.TransmitLED)
}
