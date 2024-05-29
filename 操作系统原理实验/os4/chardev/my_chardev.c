#include <linux/init.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <asm/uaccess.h>

#define CHDEV_NAME "my_chardev"
#define MAX_NAME_LEN 80
#define DEV_MAJOR 0

static const char driver_name[] = "my_chardev";
static struct cdev my_cdev;
static dev_t dev_num;

static int dev_count = 0;

int mytest_open(struct inode *inode, struct file *file)
{
    dev_count++;
    printk(KERN_INFO "Device /dev/%s opened %d times\n", CHDEV_NAME, dev_count);
    return 0;
}

ssize_t mytest_read(struct file *file, char __user *buf, size_t size, loff_t *offset)
{
    char temp_buf[MAX_NAME_LEN];
    snprintf(temp_buf, MAX_NAME_LEN, "Hello from mychardev!\n");
    int len = strlen(temp_buf);
    if (len > size)
    {
        printk(KERN_WARNING "Buffer size is too small\n");
        return -ENOMEM;
    }
    if (copy_to_user(buf, temp_buf, len))
    {
        printk(KERN_ERR "Failed to copy data to user buffer\n");
        return -EFAULT;
    }
    *offset += len;
    return len;
}

ssize_t mytest_write(struct file *file, const char __user *buf, size_t size, loff_t *offset)
{
    char temp_buf[MAX_NAME_LEN];
    if (size > MAX_NAME_LEN)
    {
        printk(KERN_WARNING "Write size exceeds buffer limit\n");
        return -ENOMEM;
    }
    if (copy_from_user(temp_buf, buf, size))
    {
        printk(KERN_ERR "Failed to copy data from user buffer\n");
        return -EFAULT;
    }
    temp_buf[size] = '\0';
    printk(KERN_INFO "Received: %s\n", temp_buf);
    *offset += size;
    return size;
}

int mytest_release(struct inode *inode, struct file *file)
{
    printk(KERN_INFO "Device /dev/%s closed\n", CHDEV_NAME);
    return 0;
}

static struct file_operations fops = {
    .owner = THIS_MODULE,
    .open = mytest_open,
    .read = mytest_read,
    .write = mytest_write,
    .release = mytest_release,
};

static int __init mychardev_init(void)
{
    int ret;
    dev_t num = MKDEV(DEV_MAJOR, 0);

    if (DEV_MAJOR == 0)
    {
        ret = alloc_chrdev_region(&dev_num, 0, 1, driver_name);
        if (ret < 0)
        {
            printk(KERN_ALERT "Failed to allocate char device region\n");
            return ret;
        }
    }
    else
    {
        dev_num = num;
    }

    cdev_init(&my_cdev, &fops);
    my_cdev.owner = THIS_MODULE;

    ret = cdev_add(&my_cdev, dev_num, 1);
    if (ret < 0)
    {
        if (DEV_MAJOR == 0)
        {
            unregister_chrdev_region(dev_num, 0);
        }
        printk(KERN_ALERT "Failed to add my char device\n");
        return ret;
    }

    printk(KERN_INFO "<1> register chardev successful!\n");
    printk(KERN_INFO "<1> assigned major number %d\n", MAJOR(dev_num));
    printk(KERN_INFO "<1> the device, create a dev file.\n");
    printk(KERN_INFO "Char device %s registered with major %d minor %d\n", CHDEV_NAME, MAJOR(dev_num), MINOR(dev_num));
    return 0;
}

static void __exit mychardev_exit(void)
{
    cdev_del(&my_cdev);
    if (DEV_MAJOR == 0)
    {
        unregister_chrdev_region(dev_num, 0);
    }
    printk(KERN_INFO "Char device %s unregistered\n", CHDEV_NAME);
}

module_init(mychardev_init);
module_exit(mychardev_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("lhb20211401206");
MODULE_DESCRIPTION("An simple char driver example");
