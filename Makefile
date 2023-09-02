build-nicenano-bin:
	@cargo build --release --target thumbv7em-none-eabihf
	@arm-none-eabi-objcopy -O ihex target/thumbv7em-none-eabihf/release/keeble target/thumbv7em-none-eabihf/release/keeble.hex
	@echo
	@echo "    hex file generated at target/thumbv7em-none-eabihf/release/keeble.hex"
	@echo
	@echo "    Next run 'make flash-with-adafruit' outside the container to flash to device"


flash-with-adafruit:
ifeq ("$(wildcard target/thumbv7em-none-eabihf/release/keeble.hex)","")
	@echo "Can't find bin file. Make sure to run 'make build-nicenano-bin' from the devcontainer before attempting to flash to device."
	@exit 1
endif

ifeq (, $(shell which adafruit-nrfutil))
	@echo "Can't find adafruit-nrfutil. This is either because you are running inside the devcontainer which is not correct or it"
	@echo " has not been installed on the host yet."
	@echo " Install with 'pip3 install --user adafruit-nrfutil' and try again. You may need to restart your shell before adafruit-nrfutil"
	@echo " will be in your PATH. See https://github.com/adafruit/Adafruit_nRF52_nrfutil for more info."
endif
	adafruit-nrfutil dfu genpkg --dev-type 0x0052 --application target/thumbv7em-none-eabihf/release/keeble.hex target/thumbv7em-none-eabihf/keeble-pkg.zip
