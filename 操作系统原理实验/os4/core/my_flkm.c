#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>

MODULE_AUTHOR("lhb20211401206");
MODULE_DESCRIPTION("An simple Linux Kernel Module for lhb20211401206");
MODULE_LICENSE("GPL");
MODULE_VERSION("1.1.0");

static int debug_level = 0;
module_param(debug_level, int, 0644);
MODULE_PARM_DESC(debug_level, "Debug level for myflkm (0=off, 1=on)");

static int some_initialization_function(void)
{
    if (debug_level)
        printk(KERN_DEBUG "myflkm: Performing initialization tasks.\n");
    return 0;
}

static void some_cleanup_function(void)
{
    if (debug_level)
        printk(KERN_DEBUG "myflkm: Performing cleanup tasks.\n");
}

static int __init myflkm_init(void)
{
    int result;

    if (debug_level)
        printk(KERN_DEBUG "myflkm: Initialization started.\n");

    result = some_initialization_function();
    if (result < 0)
    {
        if (debug_level)
            printk(KERN_DEBUG "myflkm: Initialization failed with error %d.\n", result);
        return result;
    }

    printk(KERN_INFO "Hello lhb20211401206! Welcome to linux LKM.\n");
    if (debug_level)
        printk(KERN_DEBUG "myflkm: Initialization completed successfully.\n");

    return 0;
}

static void __exit myflkm_exit(void)
{
    printk(KERN_INFO "Goodbye! lhb20211401206 USERS.\n");

    some_cleanup_function();

    if (debug_level)
        printk(KERN_DEBUG "myflkm: Cleanup completed.\n");
}

module_init(myflkm_init);
module_exit(myflkm_exit);