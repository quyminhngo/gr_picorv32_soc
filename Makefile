
PYTHON_NAME ?= python
RISCV_NAME 	?= riscv-none-embed
RISCV_PATH 	?= C:/8.2.0-2.1-20190425-1021
MAKE		?= make

FW_FILE 	 = fw/fw-flash/build/fw-flash.v

PROG_FILE	?= $(FW_FILE)
COMx	 	?= COM9

export PYTHON_NAME
export RISCV_NAME
export RISCV_PATH


.PHONY: all brom flash clean program

all: brom flash

$(FW_FILE): flash

brom:
	$(MAKE) -C fw/fw-brom

flash:
	$(MAKE) -C fw/fw-flash

clean:
	$(MAKE) -C fw/fw-brom clean
	$(MAKE) -C fw/fw-flash clean

program: $(PROG_FILE)
	$(PYTHON_NAME) sw/pico-programmer.py $(PROG_FILE) $(COMx)
