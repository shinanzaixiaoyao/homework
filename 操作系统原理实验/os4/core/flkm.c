#include <linux/module.h>
static int __init myflkm_init(void)
{
    printk("Hello XJU JSJ211! Welcome to linux LKM.\n");
    return 0;
}
static void __exit myflkm_exit(void)
{
    printk("GoodBye!XJU JSJ211 USERS.\n");
}

module_init(myflkm_init);
module_exit(myflkm_exit);
MODULE_LICENSE("GPL");
