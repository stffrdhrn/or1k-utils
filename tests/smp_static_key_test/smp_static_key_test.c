#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/jump_label.h>
#include <linux/kthread.h>
#include <linux/delay.h>
#include <linux/smp.h>
#include <linux/percpu.h>

static struct task_struct *reader_thread;
static struct task_struct *writer_thread;

int static_key_setting = 0;
int static_key_set = 0;
DEFINE_STATIC_KEY_FALSE(test_static_key);

/* This function contains the instruction stream that gets patched */
static noinline int check_static_key(void)
{
    if (static_branch_unlikely(&test_static_key))
        return 1;
    else
        return 0;
}
static noinline int check_static_key2(void)
{
    if (static_branch_unlikely(&test_static_key))
        return 2;
    else
        return 0;
}
static noinline int check_static_key3(void)
{
    if (static_branch_unlikely(&test_static_key))
        return 3;
    else
        return 0;
}
static noinline int check_static_key4(void)
{
    if (static_branch_unlikely(&test_static_key))
        return 4;
    else
        return 0;
}

/* Reader Thread: Runs on every CPU, tight loop checking the key.
   Needs to be a tight loop to avoid cache getting evicted.  */
static int reader_fn(void *data)
{
    unsigned int cpu = smp_processor_id();
    unsigned long timeout = jiffies + HZ;

    while (true) {
        int val = check_static_key();
        int val2 = check_static_key2();
        int val3 = check_static_key3();
        int val4 = check_static_key4();

	int setting = READ_ONCE(static_key_setting);
	int set = READ_ONCE(static_key_set);

	if (setting && set) {
		if (val == 0 || val2 == 0 || val3 == 0 || val4 == 0) {
			pr_info("SMP_TEST: Failure detected CPU %u static key values %d, %d, %d, %d\n",
				cpu, val, val2, val3, val4);
		}
	}

	if (time_after(jiffies, timeout)) {
		pr_info("SMP_TEST: CPU %u static key values %d, %d, %d, %d\n",
			cpu, val, val2, val3, val4);
		timeout = jiffies + HZ;

		if (kthread_should_stop())
			break;

		/* Give the kernel time for some work */
		msleep_interruptible(100);
	}

	cpu_relax();
    }
    return 0;
}

/* Writer Thread: Runs on CPU 0, toggles the key every 3 seconds */
static int writer_fn(void *data)
{
    while (!kthread_should_stop()) {
        msleep_interruptible(3000);

        if (static_key_enabled(&test_static_key)) {
            pr_info("SMP_TEST: CPU 0 toggling key to: DISABLED\n");
	    WRITE_ONCE(static_key_setting, 0);
            static_branch_disable(&test_static_key);
	    WRITE_ONCE(static_key_set, 0);
        } else {
            pr_info("SMP_TEST: CPU 0 toggling key to: ENABLED\n");
            static_branch_enable(&test_static_key);
	    WRITE_ONCE(static_key_setting, 1);
            static_branch_enable(&test_static_key);
	    WRITE_ONCE(static_key_set, 1);
        }
    }
    return 0;
}

static int __init smp_test_init(void)
{
    pr_info("SMP_TEST: Initializing static key stress test\n");

    reader_thread = kthread_create(reader_fn, NULL, "key_reader");
    if (IS_ERR(reader_thread))
        return PTR_ERR(reader_thread);

    kthread_bind(reader_thread, 1);
    wake_up_process(reader_thread);

    /* Start writer on current CPU */
    writer_thread = kthread_run(writer_fn, NULL, "key_writer");
    if (IS_ERR(writer_thread))
        return PTR_ERR(writer_thread);

    return 0;
}

static void __exit smp_test_exit(void)
{
    if (writer_thread)
        kthread_stop(writer_thread);

    if (reader_thread)
	kthread_stop(reader_thread);

    pr_info("SMP_TEST: Test stopped\n");
}

module_init(smp_test_init);
module_exit(smp_test_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Static Key SMP I-Cache Stress Test");
