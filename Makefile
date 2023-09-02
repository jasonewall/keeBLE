build-nicenano-bin:
	@cargo build --release --target thumbv7em-none-eabihf
	@arm-none-eabi-objcopy -O binary target/thumbv7em-none-eabihf/release/keeble target/thumbv7em-none-eabihf/release/keeble.bin
	@echo
	@echo "    bin file generated at target/thumbv7em-none-eabihf/release/keeble.bin"
	@echo
	@echo "    Next run 'make flash-with-adafruit SRC=bin' outside the container to flash to device"


build-nicenano-hex:
	@cargo build --release --target thumbv7em-none-eabihf
	@arm-none-eabi-objcopy -O ihex target/thumbv7em-none-eabihf/release/keeble target/thumbv7em-none-eabihf/release/keeble.hex
	@echo
	@echo "    hex file generated at target/thumbv7em-none-eabihf/release/keeble.hex"
	@echo
	@echo "    Next run 'make flash-with-adafruit SRC=hex' outside the container to flash to device"

help:
	@echo "Run make build-nicenano-bin/hex first inside the devcontainer to build the application"
	@echo "After run make flash-with-adafruit SRC=bin/hex SERIAL=/dev/ttyXXXX"
	@echo "For WSL use usbipd wsl attach --busid <busid> from PowerShell"
	@echo "Use usbipd wsl list to find busid"

flash-with-adafruit:
ifeq ("$(wildcard target/thumbv7em-none-eabihf/release/keeble.$(SRC))","")
	@echo "Can't find $(SRC) file. Make sure to run 'make build-nicenano-$(SRC)' from the devcontainer before attempting to flash to device."
	@exit 1
endif

ifeq (, $(shell which adafruit-nrfutil))
	@echo "Can't find adafruit-nrfutil. This is either because you are running inside the devcontainer which is not correct or it"
	@echo " has not been installed on the host yet."
	@echo " Install with 'pip3 install --user adafruit-nrfutil' and try again. You may need to restart your shell before adafruit-nrfutil"
	@echo " will be in your PATH. See https://github.com/adafruit/Adafruit_nRF52_nrfutil for more info."
	exit 1
endif

ifeq ("$(SERIAL)", "")
	@echo "SERIAL not provided. Should be the /dev/ttyXXXX value of your USB device"
	exit 1
endif

	adafruit-nrfutil dfu genpkg --dev-type 0x0052 --application target/thumbv7em-none-eabihf/release/keeble.$(SRC) target/thumbv7em-none-eabihf/keeble-pkg.zip
	adafruit-nrfutil dfu serial --package target/thumbv7em-none-eabihf/keeble-pkg.zip -b 115200 -p $(SERIAL)
