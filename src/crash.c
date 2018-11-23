#include <stdlib.h>
#include <stdio.h>

/* Simple test program to cause a segfault.  Used to get a core dump testing
   OpenRISC linux gdb core dump analysis.  */

int main() {
  int i;
  int * data = NULL;

  for (i = 0; i< 128; i++) {
     if (i == 42)
       i = data[8];

     printf("Counting : %d\n", i);
  }
}
