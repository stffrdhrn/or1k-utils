# Compile the bins
#
CROSS_COMPILE=or1k-linux-musl-
CFLAGS=-I ${HOME}/work/linux/usr/include -g -Og
CC=${CROSS_COMPILE}gcc



all: ptrace crash fork
clean:
	rm -f ptrace crash fork
install: ../initramfs ptrace crash fork
	cp ptrace crash fork ../initramfs

# linux /usr/include must be for an openrisc kernel created
# using 'make headers_install'
ptrace: ptrace.c ${HOME}/work/linux/usr/include
	${CC} ${CFLAGS} -o ptrace ptrace.c

crash: crash.c
	${CC} ${CFLAGS} -o crash crash.c

fork: fork.c
	${CC} ${CFLAGS} -o fork fork.c
