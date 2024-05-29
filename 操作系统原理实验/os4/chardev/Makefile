TARGET = mychardev

obj-m := $(TARGET).o

CURRENT_PATH := $(shell pwd)

LINUX_KERNEL_PATH := /usr/src/kernels/$(shell uname -r)

all: modules

modules:
	$(MAKE) -C $(LINUX_KERNEL_PATH) M=$(CURRENT_PATH) modules

clean:
	$(MAKE) -C $(LINUX_KERNEL_PATH) M=$(CURRENT_PATH) clean
