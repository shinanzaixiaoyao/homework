obj-m := my_flkm.o

LINUX_KERNEL_PATH := /usr/src/kernels/$(shell uname -r)

all:
	$(MAKE) -C $(LINUX_KERNEL_PATH) M=$(PWD) modules

clean:
	$(MAKE) -C $(LINUX_KERNEL_PATH) M=$(PWD) clean

.PHONY: all clean
