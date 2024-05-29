#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#define DEVICE_NAME "/dev/my_chardev"
#define BUF_SIZE 32

int main()
{
    char buf[BUF_SIZE] = {0};
    int fd;
    int ret;

    fd = open(DEVICE_NAME, O_RDWR);
    if (fd == -1)
    {
        perror("open failed");
        return EXIT_FAILURE;
    }

    ret = read(fd, buf, BUF_SIZE);
    if (ret == -1)
    {
        perror("read failed");
        close(fd);
        return EXIT_FAILURE;
    }

    printf("Read from device: %s\n", buf);

    ret = write(fd, buf, BUF_SIZE);
    if (ret == -1)
    {
        perror("write failed");
        close(fd);
        return EXIT_FAILURE;
    }

    close(fd);

    return EXIT_SUCCESS;
}