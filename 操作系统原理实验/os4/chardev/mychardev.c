#include <linux/init.h>
#include <linux/module.h>
#include <linux/fs.h>

#define CHDEV_NAME "mychardev"

int major = 0;

int mytest_open(struct inode *inode, struct file *file)
{
    printk("open my test chardev successful!\n");
    return 0;
}

ssize_t mytest_read(struct file *file, char __user *buf, size_t size, loff_t *offset)
{
    printk("read my test chardev successful!\n");
    return 0;
}

ssize_t mytest_write(struct file *file, const char __user *buf, size_t size, loff_t *offset)
{
    printk("write my test chardev successful!\n");
    return 0;
}

int mytest_close(struct inode *inode, struct file *file)
{
    printk("close my test chardev successful!\n");
    return 0;
}

struct file_operations fops = {
    .open = mytest_open,
    .write = mytest_write,
    .read = mytest_read,
    .release = mytest_close};

static int __init mychardev_init(void)
{
    major = register_chrdev(0, CHDEV_NAME, &fops);
    if (major < 0)
    {
        printk(KERN_ALERT "register chardev failed!\n");
        return major;
    }
    printk(KERN_INFO "<1> register chardev successful!\n");
    printk(KERN_INFO "<1> assigned major number %d\n", major);
    printk(KERN_INFO "<1> the device, create a dev file.\n");
    printk(KERN_INFO "<1> mknod /dev/mychardev c %d 0\n", major);
    return 0;
}

static void __exit mychardev_exit(void)
{
    printk(KERN_INFO "My char-device exit\n");
    unregister_chrdev(major, CHDEV_NAME);
}

module_init(mychardev_init);
module_exit(mychardev_exit);
MODULE_LICENSE("GPL");