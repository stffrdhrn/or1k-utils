#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/jump_label.h>
#include <linux/kthread.h>
#include <linux/delay.h>
#include <linux/smp.h>
#include <linux/percpu.h>

static struct task_struct *reader_thread;
static struct task_struct *writer_thread;

int static_key_set = 0;
DEFINE_STATIC_KEY_FALSE(test_static_key);

/* This function contains the instruction stream that gets patched */
#define DEFINE_CHECK(num)					\
	static noinline int check_static_key_##num(void)	\
	{							\
		if (static_branch_unlikely(&test_static_key))	\
			return 1;				\
		return 0;					\
	}

DEFINE_CHECK(0); DEFINE_CHECK(1); DEFINE_CHECK(2); DEFINE_CHECK(3);
DEFINE_CHECK(4); DEFINE_CHECK(5); DEFINE_CHECK(6); DEFINE_CHECK(7);
DEFINE_CHECK(8); DEFINE_CHECK(9); DEFINE_CHECK(10); DEFINE_CHECK(11);
DEFINE_CHECK(12); DEFINE_CHECK(13); DEFINE_CHECK(14); DEFINE_CHECK(15);
DEFINE_CHECK(16); DEFINE_CHECK(17); DEFINE_CHECK(18); DEFINE_CHECK(19);
DEFINE_CHECK(20); DEFINE_CHECK(21); DEFINE_CHECK(22); DEFINE_CHECK(23);
DEFINE_CHECK(24); DEFINE_CHECK(25); DEFINE_CHECK(26); DEFINE_CHECK(27);
DEFINE_CHECK(28); DEFINE_CHECK(29); DEFINE_CHECK(30); DEFINE_CHECK(31);
DEFINE_CHECK(32); DEFINE_CHECK(33); DEFINE_CHECK(34); DEFINE_CHECK(35);
DEFINE_CHECK(36); DEFINE_CHECK(37); DEFINE_CHECK(38); DEFINE_CHECK(39);
DEFINE_CHECK(40); DEFINE_CHECK(41); DEFINE_CHECK(42); DEFINE_CHECK(43);
DEFINE_CHECK(44); DEFINE_CHECK(45); DEFINE_CHECK(46); DEFINE_CHECK(47);
DEFINE_CHECK(48); DEFINE_CHECK(49); DEFINE_CHECK(50); DEFINE_CHECK(51);
DEFINE_CHECK(52); DEFINE_CHECK(53); DEFINE_CHECK(54); DEFINE_CHECK(55);
DEFINE_CHECK(56); DEFINE_CHECK(57); DEFINE_CHECK(58); DEFINE_CHECK(59);
DEFINE_CHECK(60); DEFINE_CHECK(61); DEFINE_CHECK(62); DEFINE_CHECK(63);
DEFINE_CHECK(64); DEFINE_CHECK(65); DEFINE_CHECK(66); DEFINE_CHECK(67);
DEFINE_CHECK(68); DEFINE_CHECK(69); DEFINE_CHECK(70); DEFINE_CHECK(71);
DEFINE_CHECK(72); DEFINE_CHECK(73); DEFINE_CHECK(74); DEFINE_CHECK(75);
DEFINE_CHECK(76); DEFINE_CHECK(77); DEFINE_CHECK(78); DEFINE_CHECK(79);
DEFINE_CHECK(80); DEFINE_CHECK(81); DEFINE_CHECK(82); DEFINE_CHECK(83);
DEFINE_CHECK(84); DEFINE_CHECK(85); DEFINE_CHECK(86); DEFINE_CHECK(87);
DEFINE_CHECK(88); DEFINE_CHECK(89); DEFINE_CHECK(90); DEFINE_CHECK(91);
DEFINE_CHECK(92); DEFINE_CHECK(93); DEFINE_CHECK(94); DEFINE_CHECK(95);
DEFINE_CHECK(96); DEFINE_CHECK(97); DEFINE_CHECK(98); DEFINE_CHECK(99);
DEFINE_CHECK(100); DEFINE_CHECK(101); DEFINE_CHECK(102); DEFINE_CHECK(103);
DEFINE_CHECK(104); DEFINE_CHECK(105); DEFINE_CHECK(106); DEFINE_CHECK(107);
DEFINE_CHECK(108); DEFINE_CHECK(109); DEFINE_CHECK(110); DEFINE_CHECK(111);
DEFINE_CHECK(112); DEFINE_CHECK(113); DEFINE_CHECK(114); DEFINE_CHECK(115);
DEFINE_CHECK(116); DEFINE_CHECK(117); DEFINE_CHECK(118); DEFINE_CHECK(119);
DEFINE_CHECK(120); DEFINE_CHECK(121); DEFINE_CHECK(122); DEFINE_CHECK(123);
DEFINE_CHECK(124); DEFINE_CHECK(125); DEFINE_CHECK(126); DEFINE_CHECK(127);

static int (*checkers[128])(void) = {
	check_static_key_0, check_static_key_1, check_static_key_2, check_static_key_3,
	check_static_key_4, check_static_key_5, check_static_key_6, check_static_key_7,
	check_static_key_8, check_static_key_9, check_static_key_10, check_static_key_11,
	check_static_key_12, check_static_key_13, check_static_key_14, check_static_key_15,
	check_static_key_16, check_static_key_17, check_static_key_18, check_static_key_19,
	check_static_key_20, check_static_key_21, check_static_key_22, check_static_key_23,
	check_static_key_24, check_static_key_25, check_static_key_26, check_static_key_27,
	check_static_key_28, check_static_key_29, check_static_key_30, check_static_key_31,
	check_static_key_32, check_static_key_33, check_static_key_34, check_static_key_35,
	check_static_key_36, check_static_key_37, check_static_key_38, check_static_key_39,
	check_static_key_40, check_static_key_41, check_static_key_42, check_static_key_43,
	check_static_key_44, check_static_key_45, check_static_key_46, check_static_key_47,
	check_static_key_48, check_static_key_49, check_static_key_50, check_static_key_51,
	check_static_key_52, check_static_key_53, check_static_key_54, check_static_key_55,
	check_static_key_56, check_static_key_57, check_static_key_58, check_static_key_59,
	check_static_key_60, check_static_key_61, check_static_key_62, check_static_key_63,
	check_static_key_64, check_static_key_65, check_static_key_66, check_static_key_67,
	check_static_key_68, check_static_key_69, check_static_key_70, check_static_key_71,
	check_static_key_72, check_static_key_73, check_static_key_74, check_static_key_75,
	check_static_key_76, check_static_key_77, check_static_key_78, check_static_key_79,
	check_static_key_80, check_static_key_81, check_static_key_82, check_static_key_83,
	check_static_key_84, check_static_key_85, check_static_key_86, check_static_key_87,
	check_static_key_88, check_static_key_89, check_static_key_90, check_static_key_91,
	check_static_key_92, check_static_key_93, check_static_key_94, check_static_key_95,
	check_static_key_96, check_static_key_97, check_static_key_98, check_static_key_99,
	check_static_key_100, check_static_key_101, check_static_key_102, check_static_key_103,
	check_static_key_104, check_static_key_105, check_static_key_106, check_static_key_107,
	check_static_key_108, check_static_key_109, check_static_key_110, check_static_key_111,
	check_static_key_112, check_static_key_113, check_static_key_114, check_static_key_115,
	check_static_key_116, check_static_key_117, check_static_key_118, check_static_key_119,
	check_static_key_120, check_static_key_121, check_static_key_122, check_static_key_123,
	check_static_key_124, check_static_key_125, check_static_key_126, check_static_key_127
};

/* Reader Thread: Runs on every CPU, tight loop checking the key.
   Needs to be a tight loop to avoid cache getting evicted.  */
static int reader_fn(void *data)
{
	unsigned int cpu = smp_processor_id();
	unsigned long timeout = jiffies + HZ;
	unsigned int check_idx = 0;

	while (true) {
		int set = READ_ONCE(static_key_set);

		int val = checkers[check_idx % 128]();

		int still_set = READ_ONCE(static_key_set);

		/* If val should be set and is not we found a bug.  */
		if (set && still_set && val == 0) {
				pr_info("SMP_TEST: Failure detected CPU %u static key value[%d] %d\n", cpu, check_idx, val);
		}

		if (time_after(jiffies, timeout)) {
			pr_info("SMP_TEST: CPU %u static key value[%d] %d\n", cpu, check_idx, val);
			timeout = jiffies + HZ;
			check_idx++;

			if (kthread_should_stop())
				break;

			/* Give the kernel time for some work */
			msleep_interruptible(100);
		}

		cpu_relax();
	}
	return 0;
}

/* Writer Thread: Runs on CPU 0, toggles the key every second */
static int writer_fn(void *data)
{
	while (!kthread_should_stop()) {
		msleep_interruptible(1000);

		if (static_key_enabled(&test_static_key)) {
			pr_info("SMP_TEST: CPU 0 toggling key to: DISABLED\n");
			WRITE_ONCE(static_key_set, 0);
			static_branch_disable(&test_static_key);
		} else {
			pr_info("SMP_TEST: CPU 0 toggling key to: ENABLED\n");
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
