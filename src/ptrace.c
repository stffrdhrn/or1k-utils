#include <sys/ptrace.h>
#include <asm/ptrace.h>
#include <sys/reg.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/user.h>
#include <sys/uio.h>   /* for iovec */

#include <linux/elf.h> /* for NT_PRSTATUS */

#include <syscall.h>

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{   pid_t child;
    struct user_regs_struct regs;
    struct iovec iov;
    long orig_eax;

    iov.iov_base = &regs;
    iov.iov_len = sizeof(regs);

    child = fork();
    if(child == 0) {
        ptrace(PTRACE_TRACEME, 0, NULL, NULL);
        execl("/bin/ls", "ls", NULL);
    }
    else {
        wait(NULL);
        printf("Attepting read %d bytes\n", iov.iov_len);
        orig_eax = ptrace(PTRACE_GETREGSET, child, NT_PRSTATUS, &iov);
        if (orig_eax) {
          printf("Failed to get regs %ld\n", orig_eax);
        } else {
        printf("Read %d bytes\n", iov.iov_len);
        printf("The child made a system call %ld\n", regs.gpr[11]);
        printf("Full reg dump: \n");
        for (int i = 0; i < 32; i++) {
           printf("  r%d %ld\n", i, regs.gpr[i]);
        }
        printf("  pc %ld\n", regs.pc);
        printf("  sr %ld\n", regs.sr);
        }

        ptrace(PTRACE_CONT, child, NULL, NULL);
    }
    return 0;
}
